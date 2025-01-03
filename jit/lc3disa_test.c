#include "lc3disa.h"

int main()
{
	dis_br(0x0204, 0x3010);
	dis_and(0x52c4, 0x3012);
	return 0;
}