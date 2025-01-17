/* 
	Code cache - an array of struct cache
*/

#include <stdio.h>
#include <stdint.h>
#include "lc3disa.h"
#include "lc3vmcache.h"

int cacheCount = 0;
struct lc3Cache codeCache[CACHE_SIZE_MAX];

struct lc3Cache cache_create_block(uint16_t* memory, uint16_t lc3Address)
{
	uint16_t lc3MemAddress = lc3Address;
	uint16_t* codeBlock = (uint16_t*)malloc(sizeof(uint16_t) * CODE_BLOCK_SIZE);
	if (!codeBlock)
	{
		printf("%s at line %d: codeBlock created failure\n", __FILE__, __LINE__);
	}
	int numInstr = 0;

	while (1)
	{
		write_16bit(codeBlock, numInstr, memory[lc3Address]);
		numInstr++;
		/*
			find the last lc3Address that is a jump/ret/trap
		*/
		if (is_branch(get_opcode(memory[lc3Address])))
		{
			break;
		}
		lc3Address++;
	}

	struct lc3Cache cache = {lc3MemAddress, numInstr, codeBlock};

	return cache;
}

void cache_clear()
{
	for(int i = cacheCount; i > 0; i--)
	{
		free(codeCache[i - 1].codeBlock);
	}

	// cacheCount should be 0 by now
	cacheCount = 0;
}

void cache_add(struct lc3Cache c)
{
	if (cacheCount < CACHE_SIZE_MAX - 1)
	{
		codeCache[cacheCount] = c;
		cacheCount++;
	}
	// what if we already have CACHE_SIZE_MAX blocks?
	else
	{
		codeCache[CACHE_SIZE_MAX - 1] = c;
	}
}


int cache_find(uint16_t address)
{
	for (int i = 0; i < cacheCount; i++)
	{
		if (codeCache[i].lc3MemAddress == address)
		{
			return i;
		}
	}
	return -1;
}


/* Utility functions */

uint8_t get_opcode(uint16_t instr)
{
	return (instr >> 12) & 0x000F;
}

/* returns 1 if it's a br/jmp/ret/jsr, 0 otherwise (trap is allowed to stay) */
int is_branch(uint8_t opcode)
{
	return ((opcode == 0x00) || (opcode == 0x04) || (opcode == 0x0c));
}

void write_16bit(uint16_t* targetArray, uint16_t targetIndex, uint16_t value)
{
	targetArray[targetIndex] = value;
}

