.PHONY: test binwalk lc3disa_test lc3binwalk_test lc3jit_debug lc3jit

jit: lc3jit
	./lc3vm_jit

jit_debug: lc3jit
	gdb -x lc3jit_gdb_commands.txt --tui ./lc3vm_jit

lc3jit: lc3vm_jit.c
	rm -f ./lc3vm_jit
	gcc -g -Wall lc3disa.c lc3vmcache.c lc3vm_jit.c -o lc3vm_jit

test: lc3disa_test
	./lc3disa_test

binwalk: lc3binwalk_test
	./lc3binwalk_test

lc3disa_test: lc3disa_test.c
	gcc -g -Wall lc3disa_test.c lc3disa.c -o lc3disa_test

lc3binwalk_test: lc3binwalk_test.c
	rm -f ./lc3binwalk_test
	gcc -g -Wall lc3binwalk_test.c lc3disa.c lc3binwalk.c -o lc3binwalk_test