SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDOUT = 1
STDIN = 0

EXIT_SUCCESS = 0

.align 32

.data 
buff: .ascii "          "
buff_len = . - buff

.text
init: .ascii "Enter text: "
init_len = . - init

to_exit: .ascii "Q\n"

.global _start

_start:
	
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $init, %ecx
	mov $init_len, %edx
	int $0x80

	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $buff, %ecx
	mov $buff_len, %edx
	int $0x80

	movw (buff), %dx
	cmpw (to_exit), %dx
	je _exit

_display:	
	mov %eax, %edx
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $buff, %ecx
	int $0x80

	jmp _start

_exit:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx

	int $0x80
