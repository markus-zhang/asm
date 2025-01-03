/* 	A simply disassembler for lc3 - 
	User should pass an uint_16t instruction and address to it
*/

#include <stdio.h>
#include <stdint.h>
#include <signal.h>
#include "lc3disa.h"
#include <stdlib.h>
#include <unistd.h>

void dis_br(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 5 4 3 2 1 0
		0  0  0  0  | n  z  p |    PCOffset9
	*/

	dis_debug(instr, address);

	printf("BR");

	uint8_t n = (instr >> 11) & 0x0001;
	uint8_t z = (instr >> 10) & 0x0001;
	uint8_t p = (instr >> 9) & 0x0001;

	if (n) {putchar('n');}
	if (z) {putchar('z');}
	if (p) {putchar('p');}

	putchar('\t');
	printf("%#06x\n", sign_extended(instr & 0x01FF, 9));
}

void dis_add(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 | 2 1 0
		0  0  0  1  |   DR    |  SR1  | 0 | 0 0 |  SR2 
		----------------------or-----------------------
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 2 1 0
		0  0  0  1  |   DR    |  SR   | 1 |    IMM
	*/

	dis_debug(instr, address);

	printf("ADD");

	putchar('\t');

	uint8_t dr = (instr >> 9) & 0x0007;
	printf("r%hhu\t", dr);
	uint8_t sr = (instr >> 6) & 0x0007;
	printf("r%hhu\t", sr);

	uint8_t mode = (instr >> 5) & 0x0001;

	if (mode)
	{
		printf("%#06x\n", sign_extended(instr & 0x001F, 5));
	}
	else 
	{
		uint8_t sr2 = instr & 0x0007;
		printf("r%hhu\n", sr2);
	}
}


void dis_ld(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 5 4 3 2 1 0
		0  0  1  0  |   DR    |    PCOffset9
	*/

	dis_debug(instr, address);

	printf("LD");

	putchar('\t');

	uint8_t dr = (instr >> 9) & 0x0007;
	printf("r%hhu\t", dr);

	printf("%#06x\n", sign_extended(instr & 0x01FF, 9));
}

void dis_st(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 5 4 3 2 1 0
		0  0  1  1  |   SR    |    PCOffset9
	*/

	dis_debug(instr, address);

	printf("ST");

	putchar('\t');

	uint8_t sr = (instr >> 9) & 0x0007;
	printf("r%hhu\t", sr);

	printf("%#06x\n", sign_extended(instr & 0x01FF, 9));
}

void dis_jsr(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 | 10 9 8 7 6 5 4 3 2 1 0
		0  1  0  0  | 1  |      PCOffset11
		-----------------or----------------------
		15 14 13 12 | 11 | 10 9 | 8 7 6 | 5 4 3 2 1 0
		0  1  0  0  | 0  | 0  0 |   BR  | 0 0 0 0 0 0
	*/

	dis_debug(instr, address);

	printf("JSR");

	putchar('\t');

	uint8_t mode = (instr >> 11) & 0x0001;

	if (mode)
	{
		printf("%#06x\n", sign_extended(instr & 0x07FF, 11));
	}
	else 
	{
		uint16_t br = (instr >> 6)  & 0x0007;
		printf("r%hhu\n", br);
	}
}

void dis_and(uint16_t instr, uint16_t address)
{
	/* 
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 | 2 1 0
		0  1  0  1  |    DR   |  SR1  | 0 | 0 0 |  SR2
		---------------------or------------------------
		15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 2 1 0
		0  1  0  1  |    DR   |  SR1  | 1 |   imm5
	*/

	dis_debug(instr, address);

	printf("AND");

	putchar('\t');

	uint8_t dr = (instr >> 9) & 0x0007;
	printf("r%hhu\t", dr);
	uint8_t sr = (instr >> 6) & 0x0007;
	printf("r%hhu\t", sr);

	uint8_t mode = (instr >> 5) & 0x0001;
	if (mode)
	{
		uint16_t imm5 = sign_extended(instr & 0x001F, 5);
		printf("%#06x\n", imm5);
	}
	else
	{
		uint8_t sr2 = instr & 0x0007;
		printf("r%hhu\n", sr2);
	}
}



void dis_debug(uint16_t instr, uint16_t address)
{

	if (DEBUG_LEVEL == 2)
	{
		// Show current instruction in hex and mnenomics
		printf("Instruction to be executed - %#06x\n", instr);
		printf("15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00\n");
		for (int i = 15; i >= 0; i--)
		{
			printf("%hhu  ", (instr >> i) & 0x01);
		}
		printf("\n");
	}

	// First we print the address
	printf("Address: %#06x\t", (unsigned int)address);
	printf("%#06x\t", instr);
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