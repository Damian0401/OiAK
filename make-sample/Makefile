CFLAGS = -c

CC = gcc

all: main.o
	@echo "Creating executable..."
	$(CC) main.o -o hello

main.o: main.c
	@echo "Compiling files..."
	$(CC) $(CFLAGS) main.c -o main.o

run: 
	@echo "Running..."
	./hello

clean:
	@echo "Cleaning up..."
	rm main.o
