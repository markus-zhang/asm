run: asm_example
	./asm_example

asm_example: asm_example.o
	ld -o asm_example asm_example.o

asm_example.o: asm_example.asm
	nasm -f elf64 -g -F dwarf -o asm_example.o asm_example.asm