
all: main.o
	ld main.o -o hex

main.o: main.s
	as main.s -g -o main.o

run: hex
	./hex

clean:
	rm main.o