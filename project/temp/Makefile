input = "input.txt"
output = "output.txt"

all: compile

compile: test.o
	ld test.o -o test

test.o: test.s
	as test.s -o test.o

run: 
	cat ${input} | ./test > ${output}

clean: 
	rm test.o test