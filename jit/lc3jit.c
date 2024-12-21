#include <stdio.h>
#include <stdint.h>
#include <signal.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <string.h>


void execute_generated_machine_code(const uint8_t *code, size_t codelen);

int main()
{
	// MARKUS: https://stackoverflow.com/questions/15593214/linux-shellcode-hello-world
	const uint8_t code[] = "\xeb\x20\x48\x31\xc0\x48\x31\xff\x48\x31\xf6\x48\x31\xd2\xb0\x01\x40\xb7\x01\x5e\xb2\x0c\x0f\x05\x48\x31\xc0\xb0\x3c\x40\xb7\x00\x0f\x05\xe8\xdb\xff\xff\xff\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x21";

	const uint8_t mov[] = "\x49\xc7\xc1\x02\x00\x00\x00\x48\x31\xc0\xb0\x3c\x40\xb7\x00\x0f\x05";
	// 49 C7 C1 02 00 00 00: 	MOV r9, 0x02
	// 48 31 C0            		xor rax,rax
	// B0 3C              		mov al,0x3c			; syscall number (60 for sys_exit)
	// 40 B7 00            		mov dil,0x0			; rdi <- 0 (error_code)
	// 0F 05              		syscall

	execute_generated_machine_code(mov, sizeof(mov));

	return 0;

}

void execute_generated_machine_code(const uint8_t *code, size_t codelen)
{
    // in order to manipulate memory protection, we must work with
    // whole pages allocated directly from the operating system.
    static size_t pagesize;
    if (!pagesize) {
        pagesize = sysconf(_SC_PAGESIZE);
        if (pagesize == (size_t)-1) perror("getpagesize");
    }

    // allocate at least enough space for the code + 1 byte
    // (so that there will be at least one INT3 - see below),
    // rounded up to a multiple of the system page size.

	// MARKUS: This is pretty smart. It never overallocates 
	// Consider pagesize = 4K and codelen = 4K-1 and you will understand
    size_t rounded_codesize = ((codelen + 1 + pagesize - 1)
                               / pagesize) * pagesize;

	// MARKUS:
	// https://man7.org/linux/man-pages/man2/mmap.2.html
	// void *mmap(void addr[.length], size_t length, int prot, int flags, int fd, off_t offset);
	// if addr is 0, then the kernel chooses the (page-aigned) address to create the mapping
	// prot: this says, pages are readable, writable (but not executable), 
	// for MAP_ANONYMOUS check https://stackoverflow.com/questions/34042915/what-is-the-purpose-of-map-anonymous-flag-in-mmap-system-call
	// fd is file descriptor, fd to be -1 if MAP_ANONYMOUS (or MAP_ANON) is specified,
	// offset = 0 due to MAP_ANONYMOUS

    void *executable_area = mmap(0, rounded_codesize,
                                 PROT_READ|PROT_WRITE|PROT_EXEC,
                                 MAP_PRIVATE|MAP_ANONYMOUS,
                                 -1, 0);
    if (!executable_area) perror("mmap");

    // at this point, executable_area points to memory that is writable but
    // *not* executable.  load the code into it.
    memcpy(executable_area, code, codelen);

    // fill the space at the end with INT3 instructions, to guarantee
    // a prompt crash if the generated code runs off the end.
    // must change this if generating code for non-x86.

	// MARKUS: INT3 generates a SIGSEGV
    memset(executable_area + codelen, 0xCC, rounded_codesize - codelen);

    // make executable_area actually executable (and unwritable)

	// MARKUS: On success, mprotect() and pkey_mprotect() return zero.  
	// On error, these system calls return -1, and errno is set to indicate the error.
    if (mprotect(executable_area, rounded_codesize, PROT_READ|PROT_EXEC))
        perror("mprotect");

    // now we can call it. passing arguments / receiving return values
    // is left as an exercise (consult libffi source code for clues).
    (*(void (*)()) executable_area)();

    munmap(executable_area, rounded_codesize);
}