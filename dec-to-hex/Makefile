all: hex.o
	ld hex.o -o hex

hex.o: temp.s
	as temp.s -g -o hex.o

run:
	./hex

clean:
	rm hex.o ./hex
