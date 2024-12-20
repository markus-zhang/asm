00000000  EB20              jmp short 0x22
00000002  4831C0            xor rax,rax
00000005  4831FF            xor rdi,rdi
00000008  4831F6            xor rsi,rsi
0000000B  4831D2            xor rdx,rdx
0000000E  B001              mov al,0x1			; syscall number (1 for sys_write)
00000010  40B701            mov dil,0x1			; rdi <- 1 (write to stdout)
00000013  5E                pop rsi				; rsi <- address of 'H'
00000014  B20C              mov dl,0xc			; rdx <- count of chars to write (in this case 12)
; syscall: https://x64.syscall.sh/
00000016  0F05              syscall				; sys_write
00000018  4831C0            xor rax,rax
0000001B  B03C              mov al,0x3c			; syscall number (60 for sys_exit)
0000001D  40B700            mov dil,0x0			; rdi <- 0 (error_code)
00000020  0F05              syscall
00000022  E8DBFFFFFF        call 0x2			; call pushes the next instr ('H' at 00000027) onto stack

; Everything below is wrong, it's actually the string "Hello World!"
00000027  48                rex.w
00000028  656C              gs insb
0000002A  6C                insb
0000002B  6F                outsd
0000002C  20576F            and [rdi+0x6f],dl
0000002F  726C              jc 0x9d
00000031  64                fs
00000032  21                db 0x21
