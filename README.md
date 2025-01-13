This is a very simple, interpreter style emulator for the LC-3 machine.

The only game that has been tested is the 2048 one, so I cannot guarantee the correctness of the project.

**TODO**:
- I'm in the middle of converting it a Dynarec (to x64) style emulator. Right now there is no JIT, and the JIT version you saw is merely copying the LC-3 machine code into a code cache and execute it using the interpreter. There is no x64 assembly at the moment, as I haven't figured out the syntax of x64 assembly yet;

- That said, my priority is to convert the code into a C++ version;

- Then I'll add SDL2 and IMGUI into the project. I'll use SDL2 to draw the terminal (instead of directly using the Linux terminal), and IMGUI to create the UI for all debugging widgets. Think a register display panel, a memory inspector, a x64 <-> lc-3 code cache mapper, and even a MIDI player perhaps;