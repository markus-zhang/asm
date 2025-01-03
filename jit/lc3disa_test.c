#include "lc3disa.h"

int main()
{
	dis_br(0x0204, 	0x3010);

	// ADD 	R1, R7, R4
	dis_add(0x13e4, 0x3012);

	// Add 	R1, R7, 0x11c
	dis_add(0x13fc, 0x3014);


	dis_ld(0x2c17, 	0x3016);
	dis_st(0x3cff, 	0x3918);
	dis_jsr(0x49fe, 0x3020);
	dis_jsr(0x41c0, 0x3022);

	// AND	R1, R7, R4
	dis_and(0x53e4, 0x3024);

	// AND 	R1, R7, 0x11c
	dis_and(0x53fc, 0x3026);

	// 
	return 0;
}