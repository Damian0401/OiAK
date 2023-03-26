all: main.o
	ld main.o -o repeat

main.o: main.s
	as main.s -g -o main.o

run:
	./repeat

clean:
	rm main.o ./repeat
