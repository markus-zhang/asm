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


/* Register file mapping */
enum
{
	R_R8 = 0,
	R_R9,
	R_R10,
	R_R11,
	R_R12,
	R_R13,
	R_R14,
	R_R15,
	R_COUNT
};

uint16_t lc3pc = 0;
uint16_t shadowMemory[65536] = {0};

/*
For ChatGPT:

I have a question about mapping registers when emitting x64 binary code:
Let's say x64 r8-r15 are mapped to lc3 r0-r7
And then there is a load instruction: ld r6, stack

Let's focus on mapping lc-3 r6 to x64 r14. 
This is actually complicated, 
essentially I need to write a switch statement in assembly and manually translate it to binary. 

This seems pretty bad, is there way to avoid the translation part? 
*/


uint16_t sign_extended(uint16_t num, uint8_t effBits);
void execute_generated_machine_code(const uint8_t *code, size_t codelen);

void emit_ld(const uint16_t* shadowMemory, uint16_t instr);
void emit_ld_test();

void emit_ld(const uint16_t* shadowMemory, uint16_t instr)
{
	/* 	For reason of passing shadowMemory as an argument, see comments in 2048.asm
		shadowMemory -> rdi, instr -> rsi
	 	Example: 		LD    R6, STACK
		LC-3 binary:	15 14 13 12 | 11 10 9 | 8 7 6 5 4 3 2 1 0
						0  0  1  0  |   DR    |    PCOffset9
		Example binary:	0x2c17
		-----------------------
		Translated to something like:
		xor rcx, rcx
		mov cx, #value_at_index
	*/

	uint8_t dr = (instr >> 9) & 0x0007;
	uint16_t pcoffset9 = sign_extended(instr & 0x01FF, 9);

	/* 	dr tells which mapped x64 register to store,
		value gives #value_at_index
	*/
	uint16_t value = shadowMemory[lc3pc + pcoffset9];

	/* Now we need to figure out how to generate the binary code */
	// https://www.felixcloutier.com/x86/mov
	uint8_t x64Code[3]; 
	x64Code[0] = '\xB9';
	x64Code[1] = value & 0xFF;
	x64Code[2] = value >> 8;
	execute_generated_machine_code(x64Code, 3);
}

void emit_ld_test()
{
	uint8_t x64Code[7];
	// xor rcx, rcx
	x64Code[0] = '\x48';
	x64Code[1] = '\x31';
	x64Code[2] = '\xc9';
	x64Code[3] = '\x66';

	// mov cx, 0x5678
	x64Code[4] = '\xB9';
	x64Code[5] = 0x5678 & 0xFF;
	x64Code[6] = 0x5678 >> 8;
	execute_generated_machine_code(x64Code, 7);
}

int main()
{
	// MARKUS: https://stackoverflow.com/questions/15593214/linux-shellcode-hello-world
	const uint8_t code[] = "\xeb\x20\x48\x31\xc0\x48\x31\xff\x48\x31\xf6\x48\x31\xd2\xb0\x01\x40\xb7\x01\x5e\xb2\x0c\x0f\x05\x48\x31\xc0\xb0\x3c\x40\xb7\x00\x0f\x05\xe8\xdb\xff\xff\xff\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x21";
	const uint8_t code2[] = "\x48\x31\xc0\x48\x31\xff\x48\x31\xf6\x48\x31\xd2\xb0\x01\x40\xb7\x01\x48\x8d\x35\x0c\x00\x00\xb2\x0c\x0f\x05\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x21";
	const uint8_t code3[] = "\x48\x31\xc0\xc3";
	// const uint8_t code2[] = "\xeb\x16\x48\x31\xc0\x48\x31\xff\x48\x31\xf6\x48\x31\xd2\xb0\x01\x40\xb7\x01\x5e\xb2\x0c\x0f\x05\xe8\xdb\xff\xff\xff\x48\x65\x6c\x6c\x6f\x20\x57\x6f\x72\x6c\x64\x21";

	const uint8_t mov[] = "\x49\xc7\xc1\x02\x00\x00\x00\x48\x31\xc0\xb0\x3c\x40\xb7\x00\x0f\x05";
	// 49 C7 C1 02 00 00 00: 	MOV r9, 0x02
	// 48 31 C0            		xor rax,rax
	// B0 3C              		mov al,0x3c			; syscall number (60 for sys_exit)
	// 40 B7 00            		mov dil,0x0			; rdi <- 0 (error_code)
	// 0F 05              		syscall

	// execute_generated_machine_code(code3, sizeof(code3));

	// Expect to see 0x5678 in rcx
	emit_ld_test();

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

uint16_t sign_extended(uint16_t num, uint8_t effBits)
{
	// Sign extend num that contains effBits of bits to a full 16-bit unsigned short
	// uint16_t is good even for negative numbers because of overflow ->
	// consider 0x3000 + 0xFFFF in 16-bit, this results in 0x2FFF which is what we want

	// check whether the top effective bit is 1
	if ((num >> (effBits - 1)) & 0x0001)
	{
		// e.g. 0x003F with 6 effective bits would be a negative number,
		// we left shift 0xFFFF to make the last 6 bits 0 so the 3F part doesn't get impacted
		// then sign extend the rest as 1, results in 0xFFFF
		// If 0x003F has 7 effective bits, then it's a positive number and nothing needs to be done
		return (num | (0xFFFF << effBits));
	}
	else
	{
		return num;
	}
}