.PHONY: test binwalk lc3disa_test lc3binwalk_test

test: lc3disa_test
	./lc3disa_test

binwalk: lc3binwalk_test
	./lc3binwalk_test

lc3disa_test: lc3disa_test.c
	gcc -g -Wall lc3disa_test.c lc3disa.c -o lc3disa_test

lc3binwalk_test: lc3binwalk_test.c
	rm -f ./lc3binwalk_test
	gcc -g -Wall lc3binwalk_test.c lc3disa.c lc3binwalk.c -o lc3binwalk_test