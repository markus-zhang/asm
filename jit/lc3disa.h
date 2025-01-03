#ifndef _LC3DISA_H
#define _LC3DISA_H

#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define DEBUG_LEVEL 2

uint16_t sign_extended(uint16_t num, uint8_t effBits);

void dis_br(uint16_t instr, uint16_t address);
void dis_and(uint16_t instr, uint16_t address);

#endif