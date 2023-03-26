SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDOUT = 1
STDIN = 0

EXIT_SUCCESS = 0

.align 32

.data 
buff: .ascii "           "
buff_len = . - buff

.text

.global _start

_start:
	mov $SYSREAD, %eax
	mov $STDIN, %ebx
	mov $buff, %ecx
	mov $buff_len, %edx
	int $0x80

	mov %eax, %edx
	mov $SYSWRITE, %eax
	mov $STDOUT, %ebx
	mov $buff, %ecx
	int $0x80

_exit:
	mov $SYSEXIT, %eax
	mov $EXIT_SUCCESS, %ebx

	int $0x80
