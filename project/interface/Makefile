filename = result.bin

info:
	@echo "Please use 'make <target>' where <target> is one of"
	@echo "  compile	to compile all files"
	@echo "  add		to add numbers"
	@echo "  sub		to sub numbers"
	@echo "  mul		to mul numbers"
	@echo "  div		to div numbers"
	@echo "  mod 		to mod numbers"
	@echo "  show		to show result"
	@echo "  show_raw	to show raw binary result"
	@echo "  clean		to remove result files"

compile:
	gcc -g add_asm.s sub_asm.s mul_asm.s div_asm.s main.c -no-pie -o main
	gcc result.c -o result

add:
	./main a > ${filename}

sub:
	./main s > ${filename}

mul:
	./main m > ${filename}

div:
	./main d > ${filename}

mod:
	./main r > ${filename}

show:
	./result

show_raw:
	xxd -b ${filename}

clean:
	rm ${filename} main result