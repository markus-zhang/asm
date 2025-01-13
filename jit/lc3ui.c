#include "lc3ui.h"

void ui_debug_info(uint16_t* reg, int screenHeight)
{
    // Save the cursor position
    printf("\033[s");
    printf("\033[%d;0H\033[KPC:%#06x", screenHeight - 1, reg[8]);
     // Restore the cursor position
    printf("\033[u");
    // fflush(stdout);
}