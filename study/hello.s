global _start

section .text

_start:
    xor rax, rax                  ; Clear rax
    xor rdi, rdi                  ; Clear rdi
    xor rsi, rsi                  ; Clear rsi
    xor rdx, rdx                  ; Clear rdx
    mov al, 1                     ; syscall: write
    mov dil, 1                    ; file descriptor: stdout
    lea rsi, [rel $+0xb]              ; Load address of the string into rsi
    mov dl, 13                    ; Message length (13 bytes, including newline)
    syscall                       ; Make the syscall

    ; Optional infinite loop to avoid exiting
    ret

    ; Inline string
    db 'Hello, World!', 0x00      ; String to print (13 bytes including newline)