/* A simply disassembler for lc3 - 
// User should pass an uint_16t instruction to it
*/

#include <stdio.h>
#include <stdint.h>
#include <signal.h>
#include "lc3disa.h"
#include <stdlib.h>
#include <unistd.h>

void dis_br(uint16_t instr)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 5 4 3 2 1 0
		0  0  0  0  | n  z  p |    PCOffset9
	*/
	if (DEBUG_LEVEL == 2)
	{
		// Show current instruction in hex and mnenomics
		printf("Instruction to be executed - %#06x\n", instr);
		printf("15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00\n");
		for (int i = 15; i >= 0; i--)
		{
			printf("%hhu  ", (instr >> i) & 0x01);
		}
		printf("\nPress ENTER to execute the instruction.");
	}

	printf("BR");

	uint8_t n = (instr >> 11) & 0x0001;
	uint8_t z = (instr >> 10) & 0x0001;
	uint8_t p = (instr >> 9) & 0x0001;

	if (n) {putchar('n');}
	if (z) {putchar('z');}
	if (p) {putchar('p');}

	putchar('\t');
	printf("%#06x\n", (instr & 0x01FF));
}

void dis_and(uint16_t instr)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 | 2 1 0
		0  1  0  1  |    DR   |  SR1  | 0 | 0 0 |  SR2
		---------------------or------------------------
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 2 1 0
		0  1  0  1  |    DR   |  SR1  | 1 |   imm5
	*/
	if (DEBUG_LEVEL == 2)
	{
		// Show current instruction in hex and mnenomics
		printf("Instruction to be executed - %#06x\n", instr);
		printf("15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00\n");
		for (int i = 15; i >= 0; i--)
		{
			printf("%hhu  ", (instr >> i) & 0x01);
		}
		printf("\nPress ENTER to execute the instruction.");
	}

	printf("AND");

	putchar('\t');

	uint8_t dr = (instr >> 9) & 0x0007;
	uint8_t sr = (instr >> 6) & 0x0007;
	
	
	printf("%#06x\n", (instr & 0x01FF));
}