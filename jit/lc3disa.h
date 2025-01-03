#ifndef _LC3DISA_H
#define _LC3DISA_H

#include <stdlib.h>
#include <unistd.h>
#include <stdint.h>

#define DEBUG_LEVEL 1

uint16_t sign_extended(uint16_t num, uint8_t effBits);

void dis_debug(uint16_t instr, uint16_t address);
void dis_br(uint16_t instr, uint16_t address);
void dis_add(uint16_t instr, uint16_t address);
void dis_ld(uint16_t instr, uint16_t address);
void dis_st(uint16_t instr, uint16_t address);
void dis_jsr(uint16_t instr, uint16_t address);
void dis_and(uint16_t instr, uint16_t address);
void dis_ldr(uint16_t instr, uint16_t address);
void dis_str(uint16_t instr, uint16_t address);

#endif