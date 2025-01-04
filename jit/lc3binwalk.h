#include <stdio.h>
#include <stdint.h>
#include "lc3disa.h"

uint16_t load_block(struct block* b, uint16_t* binary, uint16_t numInstr, uint16_t index, uint16_t address);

void optimize();

uint8_t get_opcode(uint16_t instr);

int is_branch(uint8_t opcode);

void write_16bit(uint16_t* targetArray, uint16_t targetIndex, uint16_t value);