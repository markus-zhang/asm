#include "lc3binwalk.h"
#include "lc3disa.h"

#define MAX_SIZE 65536

enum
{
	R_R0 = 0, R_R1, R_R2, R_R3, R_R4, R_R5, R_R6, R_R7,
	R_PC, 
	R_COND, 
	R_COUNT
};

// Condition codes are supposed to be in R[COND]'s bit-0/1/2, to be used in BR
enum
{
	FL_POS = 1 << 0,	// P
	FL_ZRO = 1 << 1,	// Z
	FL_NEG = 1 << 2		// N
};

enum
{
    MR_KBSR = 0xFE00, /* keyboard status */
    MR_KBDR = 0xFE02  /* keyboard data */
};

// Registers
uint16_t reg[R_COUNT];

// RAM
uint16_t memory[MAX_SIZE];

uint16_t* binary = NULL;
uint8_t running = 1;

void (*disa_call_table[])(uint16_t, uint16_t) = {
	&dis_br, &dis_add, &dis_ld, &dis_st, &dis_jsr, &dis_and, &dis_ldr, &dis_str, 
	&dis_rti, &dis_not, &dis_ldi, &dis_sti, &dis_jmp, &dis_rsv, &dis_lea, &dis_trap
};

/* Functions Declaration BEGIN */

uint16_t swap16(uint16_t value);
void write_memory(uint16_t index, uint16_t value);
void read_image(FILE* fp, uint16_t* arrayBase, uint16_t* arraySize);

int main()
{
	reg[R_COND] = FL_ZRO;

	reg[R_PC] = 0x3000;
	uint16_t currentInstr = 0;

    binary = (uint16_t*)malloc(MAX_SIZE * sizeof(uint16_t));
    FILE* fp = fopen("./2048.obj", "rb");
	uint16_t numInstr = 0;

	read_image(fp, binary, &numInstr);
	// read_image_file(fp);
	fclose(fp);

	/* Start testing */
	struct block* b = (struct block*)malloc(sizeof(struct block));
	// Note that memory has the correct endian while binary is raw
	int instrCopied = load_block(b, memory, numInstr, 0x3000, 0x3000);

	for (int i = 0; i < instrCopied; i++)
	{
		currentInstr = b->lc3Code[i];
		uint16_t op = currentInstr >> 12;
		disa_call_table[op](currentInstr, 0x3000 + i * 2);
	}

	return 0;
}


void read_image(FILE* fp, uint16_t* arrayBase, uint16_t* arraySize)
{
	// LC-3 image is big endian while mine is little
	// So we need to swap the bytes
	// Also the first byte is where the code should be loaded into

	if (!fp)
	{
		printf("File not read!\n");
		exit(1);
	}

	// First 2-byte is origin and we should NOT read
	// it into memory
	uint16_t org = 0;
	fread(&org, 2, 1, fp);
	org = swap16(org);

	// Then we read the rest into memory
    *arraySize = fread(arrayBase, 2, MAX_SIZE, fp);
	// uint16_t org = swap16(arrayBase[0]);
	printf("Number of instructions: %d\n", *arraySize);
	for (int i = 0; i < *arraySize; i++)
	{
		write_memory(org + i, swap16(arrayBase[i]));
	}
	// 0x3000 contains the first "instruction" -- 0x3000 itself
	// the proper way is to do 2 fread(), the first fread() gets the org
	// and then the second fread() gets the code, and PC = 0x3000 instead of 0x3001
	reg[R_PC] = org;
}

uint16_t swap16(uint16_t value)
{
	// For translating endianness
	uint16_t result = ((value >> 8) & 0x00FF) + ((value << 8) & 0xFF00);
	return result;
}

void write_memory(uint16_t index, uint16_t value)
{
	memory[index] = value;
}