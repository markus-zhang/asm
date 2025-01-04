/*
	This program walks through a LC-3 binary,
	starting from a given address,
	disassembly each instrction,
	and group them into a basic blocks until it reaches a jump

	It's a reseach prototype of the dynarec.
*/

#include "lc3binwalk.h"

/* if STEP then pause after generating each basic block */
#define STEP 1
/* lc-3 block size is capped at 256 instructions (512 bytes) */
#define LC3_BLOCK_SIZE 256
/* x64 block size is capped at 4,092 bytes */
#define X64_BLOCK_SIZE 4092

typedef struct block
{
	/* address should not live in block, this is just for testing */
	uint16_t address;
	uint16_t lc3Code[LC3_BLOCK_SIZE];
	uint8_t x64Code[X64_BLOCK_SIZE];
} block;

/*
	load_block() loads a block of lc3 code into a block struct.
	It is supposed to translate it to x64 binary too, but that's not a priority.

	index 	-> index into binary;
	address -> lc-3 vm address in shadow memory
*/
uint16_t load_block(struct block* b, uint16_t* binary, uint16_t numInstr, uint16_t index, uint16_t address)
{
	uint16_t indexBegin = index;
	while (index < numInstr)
	{
		write_16bit(b->lc3Code, 0, binary[index]);

		if (is_branch(get_opcode(binary[index])))
		{
			break;
		}
		index++;
	}
	return index;
}

/* 
	Optimize the code in x64Code.
	Well, not much that I know about optimization:
	1. No need to update flags for every instruction, only the one before a jump
	2. Eh, that's everything I know...
*/
void optimize()
{

}

uint8_t get_opcode(uint16_t instr)
{
	return (instr >> 12) & 0x000F;
}

/* returns 1 if it's a jump or trap, 0 otherwise */
int is_branch(uint8_t opcode)
{
	return ((opcode == 0x04) || (opcode == 0x0c) || (opcode == 0x0f));
}

void write_16bit(uint16_t* targetArray, uint16_t targetIndex, uint16_t value)
{
	targetArray[targetIndex] = value;
}