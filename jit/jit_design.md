## LC-3

1. Registers

GPR: R0-R7 		-> using low 16-bit for compatability with LC-3;

COND: N, Z, P 	-> using x64's own SF(Sign Flag), ZF(Zero Flag), for P check SF and ZF

Scratch Regs 	-> using r10, r11 for scratch for arithmetic operations, r12-r15 for spillover for complex instruction sequences

PC				-> using r14

2. Instructions

In general we need to use sign extended 32-bit numbers because LC-3 has 16-bit word.

1) NOT

15 14 13 12 | 11 10 09 | 08 07 06 | 05 04 03 02 01 00
1  0  0  1  | 0  1  1  | 1  0  1  | 1  1  1  1  1  1
NOT              R3         R5

X-64: NOT can only apply to the destination so we need to:

- Store SR into DR (we are changing DR anyway)
- NOT DR

2) ADD

15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 | 2 1 0
0  0  0  1  |   DR    |  SR1  | 0 | 0 0 |  SR2 
----------------------or-----------------------
15 14 13 12 | 11 10 9 | 8 7 6 | 5 | 4 3 2 1 0
0  0  0  1  |   DR    |  SR   | 1 |    IMM

Case 1: 