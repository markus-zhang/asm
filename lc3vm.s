	.file	"lc3vm.c"
	.text
	.globl	reg
	.bss
	.align 16
	.type	reg, @object
	.size	reg, 20
reg:
	.zero	20
	.globl	memory
	.align 32
	.type	memory, @object
	.size	memory, 131072
memory:
	.zero	131072
	.globl	binary
	.align 8
	.type	binary, @object
	.size	binary, 8
binary:
	.zero	8
	.globl	running
	.data
	.type	running, @object
	.size	running, 1
running:
	.byte	1
	.globl	original_tio
	.bss
	.align 32
	.type	original_tio, @object
	.size	original_tio, 60
original_tio:
	.zero	60
	.globl	instr_call_table
	.section	.data.rel.local,"aw"
	.align 32
	.type	instr_call_table, @object
	.size	instr_call_table, 128
instr_call_table:
	.quad	br
	.quad	add
	.quad	ld
	.quad	st
	.quad	jsr
	.quad	and
	.quad	ldr
	.quad	str
	.quad	rti
	.quad	not
	.quad	ldi
	.quad	sti
	.quad	jmp
	.quad	res
	.quad	lea
	.quad	trap
	.section	.rodata
.LC0:
	.string	"rb"
.LC1:
	.string	"./2048.obj"
	.text
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	movl	$0, %eax
	call	setup
	movw	$2, 18+reg(%rip)
	movw	$12288, 16+reg(%rip)
	movw	$0, -20(%rbp)
	movl	$131072, %edi
	call	malloc@PLT
	movq	%rax, binary(%rip)
	leaq	.LC0(%rip), %rax
	movq	%rax, %rsi
	leaq	.LC1(%rip), %rax
	movq	%rax, %rdi
	call	fopen@PLT
	movq	%rax, -16(%rbp)
	movw	$0, -22(%rbp)
	movq	binary(%rip), %rcx
	leaq	-22(%rbp), %rdx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	read_image
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	fclose@PLT
	jmp	.L2
.L3:
	movzwl	16+reg(%rip), %eax
	leal	1(%rax), %edx
	movw	%dx, 16+reg(%rip)
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	read_memory
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$12, %ax
	movw	%ax, -18(%rbp)
	movzwl	-18(%rbp), %eax
	cltq
	leaq	0(,%rax,8), %rdx
	leaq	instr_call_table(%rip), %rax
	movq	(%rdx,%rax), %rdx
	movzwl	-20(%rbp), %eax
	movl	%eax, %edi
	call	*%rdx
.L2:
	movzbl	running(%rip), %eax
	testb	%al, %al
	jne	.L3
	movl	$0, %eax
	call	shutdown
	movl	$0, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L5
	call	__stack_chk_fail@PLT
.L5:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.section	.rodata
.LC2:
	.string	"File not read!"
.LC3:
	.string	"Number of instructions: %d\n"
	.text
	.globl	read_image
	.type	read_image, @function
read_image:
.LFB7:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movq	%rsi, -32(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpq	$0, -24(%rbp)
	jne	.L7
	leaq	.LC2(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movl	$1, %edi
	call	exit@PLT
.L7:
	movw	$0, -14(%rbp)
	movq	-24(%rbp), %rdx
	leaq	-14(%rbp), %rax
	movq	%rdx, %rcx
	movl	$1, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	fread@PLT
	movzwl	-14(%rbp), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	swap16
	movw	%ax, -14(%rbp)
	movq	-24(%rbp), %rdx
	movq	-32(%rbp), %rax
	movq	%rdx, %rcx
	movl	$65536, %edx
	movl	$2, %esi
	movq	%rax, %rdi
	call	fread@PLT
	movl	%eax, %edx
	movq	-40(%rbp), %rax
	movw	%dx, (%rax)
	movq	-40(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %esi
	leaq	.LC3(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movl	$0, -12(%rbp)
	jmp	.L8
.L9:
	movl	-12(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	movq	-32(%rbp), %rax
	addq	%rdx, %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	swap16
	movzwl	%ax, %edx
	movl	-12(%rbp), %eax
	movl	%eax, %ecx
	movzwl	-14(%rbp), %eax
	addl	%ecx, %eax
	movzwl	%ax, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	write_memory
	addl	$1, -12(%rbp)
.L8:
	movq	-40(%rbp), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	cmpl	%eax, -12(%rbp)
	jl	.L9
	movzwl	-14(%rbp), %eax
	movw	%ax, 16+reg(%rip)
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L10
	call	__stack_chk_fail@PLT
.L10:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	read_image, .-read_image
	.globl	br
	.type	br, @function
br:
.LFB8:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzwl	18+reg(%rip), %eax
	movzwl	%ax, %eax
	movzwl	-20(%rbp), %edx
	shrw	$9, %dx
	movzwl	%dx, %edx
	andl	$7, %edx
	andl	%edx, %eax
	testl	%eax, %eax
	je	.L13
	movzwl	16+reg(%rip), %edx
	movzwl	-2(%rbp), %eax
	addl	%edx, %eax
	movw	%ax, 16+reg(%rip)
.L13:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	br, .-br
	.globl	add
	.type	add, @function
add:
.LFB9:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -6(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -5(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$5, %ax
	andl	$1, %eax
	movb	%al, -4(%rbp)
	cmpb	$0, -4(%rbp)
	je	.L15
	movzwl	-20(%rbp), %eax
	andl	$31, %eax
	movl	$5, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzbl	-5(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %ecx
	movzbl	-6(%rbp), %eax
	movzwl	-2(%rbp), %edx
	addl	%edx, %ecx
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movw	%cx, (%rdx,%rax)
	jmp	.L16
.L15:
	movzwl	-20(%rbp), %eax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzbl	-5(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %ecx
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %edx
	movzbl	-6(%rbp), %eax
	addl	%edx, %ecx
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movw	%cx, (%rdx,%rax)
.L16:
	movzbl	-6(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	add, .-add
	.globl	ld
	.type	ld, @function
ld:
.LFB10:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, %eax
	movw	%ax, -36(%rbp)
	movzwl	-36(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -18(%rbp)
	movzwl	-36(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -19(%rbp)
	movzwl	16+reg(%rip), %edx
	movzwl	-18(%rbp), %eax
	addl	%edx, %eax
	movzwl	%ax, %eax
	movzbl	-19(%rbp), %ebx
	movl	%eax, %edi
	call	read_memory
	movslq	%ebx, %rdx
	leaq	(%rdx,%rdx), %rcx
	leaq	reg(%rip), %rdx
	movw	%ax, (%rcx,%rdx)
	movzbl	-19(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	ld, .-ld
	.globl	st
	.type	st, @function
st:
.LFB11:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %edx
	movzwl	16+reg(%rip), %ecx
	movzwl	-2(%rbp), %eax
	addl	%ecx, %eax
	movzwl	%ax, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	write_memory
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	st, .-st
	.globl	jsr
	.type	jsr, @function
jsr:
.LFB12:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	16+reg(%rip), %eax
	movw	%ax, 14+reg(%rip)
	movzwl	-20(%rbp), %eax
	shrw	$11, %ax
	andl	$1, %eax
	movb	%al, -4(%rbp)
	cmpb	$0, -4(%rbp)
	je	.L20
	movzwl	-20(%rbp), %eax
	andl	$2047, %eax
	movl	$11, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzwl	16+reg(%rip), %edx
	movzwl	-2(%rbp), %eax
	addl	%edx, %eax
	movw	%ax, 16+reg(%rip)
	jmp	.L22
.L20:
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movw	%ax, 16+reg(%rip)
.L22:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	jsr, .-jsr
	.globl	and
	.type	and, @function
and:
.LFB13:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$5, %ax
	andl	$1, %eax
	movb	%al, -6(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -5(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -4(%rbp)
	cmpb	$0, -6(%rbp)
	je	.L24
	movzwl	-20(%rbp), %eax
	andl	$31, %eax
	movl	$5, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzbl	-4(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzbl	-5(%rbp), %edx
	andw	-2(%rbp), %ax
	movslq	%edx, %rdx
	leaq	(%rdx,%rdx), %rcx
	leaq	reg(%rip), %rdx
	movw	%ax, (%rcx,%rdx)
	jmp	.L25
.L24:
	movzwl	-20(%rbp), %eax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzbl	-4(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %ecx
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %edx
	movzbl	-5(%rbp), %eax
	andl	%edx, %ecx
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movw	%cx, (%rdx,%rax)
.L25:
	movzbl	-5(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	and, .-and
	.globl	ldr
	.type	ldr, @function
ldr:
.LFB14:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, %eax
	movw	%ax, -36(%rbp)
	movzwl	-36(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -20(%rbp)
	movzwl	-36(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -19(%rbp)
	movzwl	-36(%rbp), %eax
	andl	$63, %eax
	movl	$6, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -18(%rbp)
	movzbl	-19(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %edx
	movzwl	-18(%rbp), %eax
	addl	%edx, %eax
	movzwl	%ax, %eax
	movzbl	-20(%rbp), %ebx
	movl	%eax, %edi
	call	read_memory
	movslq	%ebx, %rdx
	leaq	(%rdx,%rdx), %rcx
	leaq	reg(%rip), %rdx
	movw	%ax, (%rcx,%rdx)
	movzbl	-20(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE14:
	.size	ldr, .-ldr
	.globl	str
	.type	str, @function
str:
.LFB15:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -4(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzwl	-20(%rbp), %eax
	andl	$63, %eax
	movl	$6, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzbl	-4(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %edx
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rcx
	leaq	reg(%rip), %rax
	movzwl	(%rcx,%rax), %ecx
	movzwl	-2(%rbp), %eax
	addl	%ecx, %eax
	movzwl	%ax, %eax
	movl	%edx, %esi
	movl	%eax, %edi
	call	write_memory
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE15:
	.size	str, .-str
	.section	.rodata
.LC4:
	.string	"Not supposed to be here!"
	.text
	.globl	rti
	.type	rti, @function
rti:
.LFB16:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	leaq	.LC4(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE16:
	.size	rti, .-rti
	.globl	not
	.type	not, @function
not:
.LFB17:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -2(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %edx
	movzbl	-2(%rbp), %eax
	movl	%edx, %ecx
	notl	%ecx
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movw	%cx, (%rdx,%rax)
	movzbl	-2(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE17:
	.size	not, .-not
	.globl	ldi
	.type	ldi, @function
ldi:
.LFB18:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, %eax
	movw	%ax, -36(%rbp)
	movzwl	-36(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -18(%rbp)
	movzwl	-36(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -19(%rbp)
	movzwl	16+reg(%rip), %edx
	movzwl	-18(%rbp), %eax
	addl	%edx, %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	read_memory
	movzwl	%ax, %eax
	movzbl	-19(%rbp), %ebx
	movl	%eax, %edi
	call	read_memory
	movslq	%ebx, %rdx
	leaq	(%rdx,%rdx), %rcx
	leaq	reg(%rip), %rdx
	movw	%ax, (%rcx,%rdx)
	movzbl	-19(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE18:
	.size	ldi, .-ldi
	.globl	sti
	.type	sti, @function
sti:
.LFB19:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	.cfi_offset 3, -24
	movl	%edi, %eax
	movw	%ax, -36(%rbp)
	movzwl	-36(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -19(%rbp)
	movzwl	-36(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -18(%rbp)
	movzbl	-19(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %ebx
	movzwl	16+reg(%rip), %edx
	movzwl	-18(%rbp), %eax
	addl	%edx, %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	read_memory
	movzwl	%ax, %eax
	movl	%ebx, %esi
	movl	%eax, %edi
	call	write_memory
	nop
	movq	-8(%rbp), %rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE19:
	.size	sti, .-sti
	.globl	jmp
	.type	jmp, @function
jmp:
.LFB20:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$6, %ax
	andl	$7, %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movw	%ax, 16+reg(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE20:
	.size	jmp, .-jmp
	.section	.rodata
.LC5:
	.string	"Not supposed to be here"
	.text
	.globl	res
	.type	res, @function
res:
.LFB21:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	leaq	.LC5(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE21:
	.size	res, .-res
	.globl	lea
	.type	lea, @function
lea:
.LFB22:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	andl	$511, %eax
	movl	$9, %esi
	movl	%eax, %edi
	call	sign_extended
	movw	%ax, -2(%rbp)
	movzwl	-20(%rbp), %eax
	shrw	$9, %ax
	andl	$7, %eax
	movb	%al, -3(%rbp)
	movzwl	16+reg(%rip), %ecx
	movzbl	-3(%rbp), %eax
	movzwl	-2(%rbp), %edx
	addl	%edx, %ecx
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movw	%cx, (%rdx,%rax)
	movzbl	-3(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	reg(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE22:
	.size	lea, .-lea
	.section	.rodata
.LC6:
	.string	"Erroneous TRAP vector!"
	.text
	.globl	trap
	.type	trap, @function
trap:
.LFB23:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	16+reg(%rip), %eax
	movw	%ax, 14+reg(%rip)
	movzwl	-20(%rbp), %eax
	movb	%al, -1(%rbp)
	movzbl	-1(%rbp), %eax
	subl	$32, %eax
	cmpl	$5, %eax
	ja	.L36
	movl	%eax, %eax
	leaq	0(,%rax,4), %rdx
	leaq	.L38(%rip), %rax
	movl	(%rdx,%rax), %eax
	cltq
	leaq	.L38(%rip), %rdx
	addq	%rdx, %rax
	notrack jmp	*%rax
	.section	.rodata
	.align 4
	.align 4
.L38:
	.long	.L43-.L38
	.long	.L42-.L38
	.long	.L41-.L38
	.long	.L40-.L38
	.long	.L39-.L38
	.long	.L37-.L38
	.text
.L43:
	movl	$0, %eax
	call	trap_0x20
	jmp	.L44
.L42:
	movl	$0, %eax
	call	trap_0x21
	jmp	.L44
.L41:
	movl	$0, %eax
	call	trap_0x22
	jmp	.L44
.L40:
	movl	$0, %eax
	call	trap_0x23
	jmp	.L44
.L39:
	movl	$0, %eax
	call	trap_0x24
	jmp	.L44
.L37:
	movl	$0, %eax
	call	trap_0x25
	jmp	.L44
.L36:
	leaq	.LC6(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	nop
.L44:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE23:
	.size	trap, .-trap
	.globl	setup
	.type	setup, @function
setup:
.LFB24:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	handle_interrupt(%rip), %rax
	movq	%rax, %rsi
	movl	$2, %edi
	call	signal@PLT
	movl	$0, %eax
	call	disable_input_buffering
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE24:
	.size	setup, .-setup
	.globl	shutdown
	.type	shutdown, @function
shutdown:
.LFB25:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	$0, %eax
	call	restore_input_buffering
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE25:
	.size	shutdown, .-shutdown
	.globl	handle_interrupt
	.type	handle_interrupt, @function
handle_interrupt:
.LFB26:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movl	$0, %eax
	call	restore_input_buffering
	movl	$10, %edi
	call	putchar@PLT
	movl	$-2, %edi
	call	exit@PLT
	.cfi_endproc
.LFE26:
	.size	handle_interrupt, .-handle_interrupt
	.globl	disable_input_buffering
	.type	disable_input_buffering, @function
disable_input_buffering:
.LFB27:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$80, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	original_tio(%rip), %rax
	movq	%rax, %rsi
	movl	$0, %edi
	call	tcgetattr@PLT
	movq	original_tio(%rip), %rax
	movq	8+original_tio(%rip), %rdx
	movq	%rax, -80(%rbp)
	movq	%rdx, -72(%rbp)
	movq	16+original_tio(%rip), %rax
	movq	24+original_tio(%rip), %rdx
	movq	%rax, -64(%rbp)
	movq	%rdx, -56(%rbp)
	movq	32+original_tio(%rip), %rax
	movq	40+original_tio(%rip), %rdx
	movq	%rax, -48(%rbp)
	movq	%rdx, -40(%rbp)
	movq	44+original_tio(%rip), %rax
	movq	52+original_tio(%rip), %rdx
	movq	%rax, -36(%rbp)
	movq	%rdx, -28(%rbp)
	movl	-68(%rbp), %eax
	andl	$-11, %eax
	movl	%eax, -68(%rbp)
	leaq	-80(%rbp), %rax
	movq	%rax, %rdx
	movl	$0, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	nop
	movq	-8(%rbp), %rax
	subq	%fs:40, %rax
	je	.L49
	call	__stack_chk_fail@PLT
.L49:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE27:
	.size	disable_input_buffering, .-disable_input_buffering
	.globl	restore_input_buffering
	.type	restore_input_buffering, @function
restore_input_buffering:
.LFB28:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	original_tio(%rip), %rax
	movq	%rax, %rdx
	movl	$0, %esi
	movl	$0, %edi
	call	tcsetattr@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE28:
	.size	restore_input_buffering, .-restore_input_buffering
	.globl	sign_extended
	.type	sign_extended, @function
sign_extended:
.LFB29:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %edx
	movl	%esi, %eax
	movw	%dx, -4(%rbp)
	movb	%al, -8(%rbp)
	movzwl	-4(%rbp), %edx
	movzbl	-8(%rbp), %eax
	subl	$1, %eax
	movl	%eax, %ecx
	sarl	%cl, %edx
	movl	%edx, %eax
	andl	$1, %eax
	testl	%eax, %eax
	je	.L52
	movzbl	-8(%rbp), %eax
	movl	$65535, %edx
	movl	%eax, %ecx
	sall	%cl, %edx
	movl	%edx, %eax
	movl	%eax, %edx
	movzwl	-4(%rbp), %eax
	orl	%edx, %eax
	jmp	.L53
.L52:
	movzwl	-4(%rbp), %eax
.L53:
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE29:
	.size	sign_extended, .-sign_extended
	.globl	update_flag
	.type	update_flag, @function
update_flag:
.LFB30:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	movzwl	18+reg(%rip), %eax
	andl	$-8, %eax
	movw	%ax, 18+reg(%rip)
	movzwl	-4(%rbp), %eax
	testw	%ax, %ax
	jns	.L55
	movzwl	18+reg(%rip), %eax
	orl	$4, %eax
	movw	%ax, 18+reg(%rip)
	jmp	.L58
.L55:
	cmpw	$0, -4(%rbp)
	jne	.L57
	movzwl	18+reg(%rip), %eax
	orl	$2, %eax
	movw	%ax, 18+reg(%rip)
	jmp	.L58
.L57:
	movzwl	18+reg(%rip), %eax
	orl	$1, %eax
	movw	%ax, 18+reg(%rip)
.L58:
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE30:
	.size	update_flag, .-update_flag
	.globl	read_memory
	.type	read_memory, @function
read_memory:
.LFB31:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, %eax
	movw	%ax, -4(%rbp)
	cmpw	$-512, -4(%rbp)
	jne	.L60
	movl	$0, %eax
	call	check_key
	testw	%ax, %ax
	je	.L61
	movw	$-32768, 130048+memory(%rip)
	call	getchar@PLT
	movw	%ax, 130052+memory(%rip)
	jmp	.L60
.L61:
	movw	$0, 130048+memory(%rip)
.L60:
	movzwl	-4(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rdx
	leaq	memory(%rip), %rax
	movzwl	(%rdx,%rax), %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE31:
	.size	read_memory, .-read_memory
	.globl	write_memory
	.type	write_memory, @function
write_memory:
.LFB32:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %edx
	movl	%esi, %eax
	movw	%dx, -4(%rbp)
	movw	%ax, -8(%rbp)
	movzwl	-4(%rbp), %eax
	cltq
	leaq	(%rax,%rax), %rcx
	leaq	memory(%rip), %rdx
	movzwl	-8(%rbp), %eax
	movw	%ax, (%rcx,%rdx)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE32:
	.size	write_memory, .-write_memory
	.globl	trap_0x20
	.type	trap_0x20, @function
trap_0x20:
.LFB33:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	call	getchar@PLT
	movw	%ax, reg(%rip)
	movzwl	reg(%rip), %eax
	movzbl	%al, %eax
	movw	%ax, reg(%rip)
	movzwl	reg(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE33:
	.size	trap_0x20, .-trap_0x20
	.globl	trap_0x21
	.type	trap_0x21, @function
trap_0x21:
.LFB34:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	stdout(%rip), %rdx
	movzwl	reg(%rip), %eax
	movzbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	putc@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE34:
	.size	trap_0x21, .-trap_0x21
	.globl	trap_0x22
	.type	trap_0x22, @function
trap_0x22:
.LFB35:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movzwl	reg(%rip), %eax
	movw	%ax, -2(%rbp)
.L69:
	movzwl	-2(%rbp), %eax
	movl	%eax, %edi
	call	read_memory
	movb	%al, -3(%rbp)
	cmpb	$0, -3(%rbp)
	je	.L71
	movq	stdout(%rip), %rdx
	movsbl	-3(%rbp), %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	putc@PLT
	movzwl	-2(%rbp), %eax
	addl	$1, %eax
	movw	%ax, -2(%rbp)
	jmp	.L69
.L71:
	nop
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE35:
	.size	trap_0x22, .-trap_0x22
	.section	.rodata
.LC7:
	.string	"> "
	.text
	.globl	trap_0x23
	.type	trap_0x23, @function
trap_0x23:
.LFB36:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC7(%rip), %rax
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf@PLT
	movq	stdin(%rip), %rax
	movq	%rax, %rdi
	call	fgetc@PLT
	movw	%ax, reg(%rip)
	movzwl	reg(%rip), %eax
	movzbl	%al, %eax
	movw	%ax, reg(%rip)
	movq	stdout(%rip), %rdx
	movzwl	reg(%rip), %eax
	movzbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	putc@PLT
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	movzwl	reg(%rip), %eax
	movzwl	%ax, %eax
	movl	%eax, %edi
	call	update_flag
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE36:
	.size	trap_0x23, .-trap_0x23
	.globl	trap_0x24
	.type	trap_0x24, @function
trap_0x24:
.LFB37:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movzwl	reg(%rip), %eax
	movw	%ax, -4(%rbp)
.L76:
	movzwl	-4(%rbp), %eax
	movl	%eax, %edi
	call	read_memory
	movw	%ax, -2(%rbp)
	cmpw	$0, -2(%rbp)
	je	.L78
	movq	stdout(%rip), %rdx
	movzwl	-2(%rbp), %eax
	movzbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	putc@PLT
	movq	stdout(%rip), %rdx
	movzwl	-2(%rbp), %eax
	shrw	$8, %ax
	movzbl	%al, %eax
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	putc@PLT
	movzwl	-4(%rbp), %eax
	addl	$1, %eax
	movw	%ax, -4(%rbp)
	jmp	.L76
.L78:
	nop
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush@PLT
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE37:
	.size	trap_0x24, .-trap_0x24
	.section	.rodata
.LC8:
	.string	"\nSystem HALT"
	.text
	.globl	trap_0x25
	.type	trap_0x25, @function
trap_0x25:
.LFB38:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	leaq	.LC8(%rip), %rax
	movq	%rax, %rdi
	call	puts@PLT
	movb	$0, running(%rip)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE38:
	.size	trap_0x25, .-trap_0x25
	.globl	swap16
	.type	swap16, @function
swap16:
.LFB39:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movl	%edi, %eax
	movw	%ax, -20(%rbp)
	movzwl	-20(%rbp), %eax
	rolw	$8, %ax
	movw	%ax, -2(%rbp)
	movzwl	-2(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE39:
	.size	swap16, .-swap16
	.globl	check_key
	.type	check_key, @function
check_key:
.LFB40:
	.cfi_startproc
	endbr64
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$176, %rsp
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	leaq	-144(%rbp), %rax
	movq	%rax, -168(%rbp)
	movl	$0, -172(%rbp)
	jmp	.L83
.L84:
	movq	-168(%rbp), %rax
	movl	-172(%rbp), %edx
	movq	$0, (%rax,%rdx,8)
	addl	$1, -172(%rbp)
.L83:
	cmpl	$15, -172(%rbp)
	jbe	.L84
	movq	-144(%rbp), %rax
	orq	$1, %rax
	movq	%rax, -144(%rbp)
	movq	$0, -160(%rbp)
	movq	$0, -152(%rbp)
	leaq	-160(%rbp), %rdx
	leaq	-144(%rbp), %rax
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rsi
	movl	$1, %edi
	call	select@PLT
	testl	%eax, %eax
	setne	%al
	movzbl	%al, %eax
	movq	-8(%rbp), %rdx
	subq	%fs:40, %rdx
	je	.L86
	call	__stack_chk_fail@PLT
.L86:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE40:
	.size	check_key, .-check_key
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04) 13.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
