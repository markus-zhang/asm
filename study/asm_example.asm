; Executable name : EATSYSCALL
; Version : 1.0
; Created date : 4/25/2022
; Last update : 4/25/2022
; Author : Jeff Duntemann
; Architecture : x64
; From : Assembly Language Step By Step, 4th Edition
; Description : A simple program in assembly for x64 Linux, using
; NASM 2.14,
; demonstrating the use of the syscall instruction to display text.
;
; Build using these commands:
; nasm -f elf64 -g -F stabs eatsyscall.asm
; ld -o eatsyscall eatsyscall.o
;

SECTION .bss ; Section containing uninitialized data

SECTION .text ; Section containing code
	global .start ; Linker needs this to find the entry point!
	start:
		mov rbp, rsp ; for correct debugging
		nop ; This no-op keeps gdb happy...

		mov rax,1 ; 1 = sys_write for syscall
		mov rdi,1 ; 1 = fd for stdout; i.e., write to the
		; terminal window
		mov rsi,EatMsg ; Put address of the message string in rsi
		mov rdx,EatLen ; Length of string to be written in rdx
		syscall ; Make the system call
		mov rax,60 ; 60 = exit the program
		mov rdi,0 ; Return value in rdi 0 = nothing to return
		syscall ; Call syscall to exit

SECTION .data ; Section containing initialized data
EatMsg: db "Eat at Joe's!",10
EatLen: equ $-EatMsg