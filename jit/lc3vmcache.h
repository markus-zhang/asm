#ifndef _LC3VMCACHE_H
#define _LC3VMCACHE_H

#include <stdint.h>

#define CACHE_SIZE_MAX 	1024	// I figured 1024 code blocks should be kinda enough
#define CODE_BLOCK_SIZE 256		// 256 instructions without jmp/ret/jsr/trap? No way...
#define CACHE_DEBUG		1		// 1 for debug

struct lc3Cache
{
	uint16_t 	lc3MemAddress;
	int 		numInstr;
	uint16_t* 	codeBlock;
};

struct lc3Cache cache_create_block(uint16_t* memory, uint16_t lc3Address);
void cache_clear();
void cache_add(struct lc3Cache c);
uint16_t* cache_find(uint16_t address);

/* Utility functions */
uint8_t get_opcode(uint16_t instr);
int is_branch(uint8_t opcode);

#endif