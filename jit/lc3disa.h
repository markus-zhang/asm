#ifndef _LC3DISA_H
#define _LC3DISA_H

#include <stdlib.h>
#include <unistd.h>

#define DEBUG_LEVEL 1

void dis_br(uint16_t instr);
void dis_and(uint16_t instr);

#endif