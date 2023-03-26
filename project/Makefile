
help:
	@echo "Please use 'make <target>_operation' where <target> is one of"
	@echo "  start		to compile, run and show results"
	@echo "  compile	to compile file"
	@echo "  run		to run operation and save results to bin file"
	@echo "  show		to show results from bin file"
	@echo "  clean		to remove result files"
	@echo "*** operation is on of: add, sub ***"

start_add: compile_add run_add show_add

compile_add: add_big.o
	ld add_big.o -melf_i386 -o add_big

add_big.o: add_big.s
	as add_big.s --32 -g -o add_big.o

run_add: add_big
	./add_big > result_add.bin

show_add: result_add.bin
	xxd -b result_add.bin

clean_add:
	rm add_big.o add_big result_add.bin

start_sub: compile_sub run_sub show_sub

compile_sub: sub_big.o
	ld sub_big.o -melf_i386 -o sub_big

sub_big.o: sub_big.s
	as sub_big.s --32 -g -o sub_big.o

run_sub: sub_big
	./sub_big > result_sub.bin

show_sub: result_sub.bin
	xxd -b result_sub.bin

clean_sub:
	rm sub_big.o sub_big result_sub.bin