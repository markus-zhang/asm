#include <stdio.h>
#include <stdint.h>
#include "lc3disa.h"

/* if STEP then pause after generating each basic block */
#define STEP 1
/* lc-3 block size is capped at 256 instructions (512 bytes) */
#define LC3_BLOCK_SIZE 256
/* x64 block size is capped at 4,092 bytes */
#define X64_BLOCK_SIZE 4092
/* more debug information */
#define BINWALK_DEBUG 1

typedef struct block
{
	/* address should not live in block, this is just for testing */
	uint16_t address;
	uint16_t lc3Code[LC3_BLOCK_SIZE];
	uint8_t x64Code[X64_BLOCK_SIZE];
} block;

int load_block(struct block* b, uint16_t* binary, uint16_t numInstr, uint16_t index, uint16_t address);

void optimize();

uint8_t get_opcode(uint16_t instr);

int is_branch(uint8_t opcode);

void write_16bit(uint16_t* targetArray, uint16_t targetIndex, uint16_t value);

void debug();