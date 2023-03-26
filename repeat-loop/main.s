SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDOUT = 1
STDIN = 0

EXIT_SUCCESS = 0

.ALIGN 32

.data
buff: .ascii "          "
buff_len = . - buff

.text

.global _start

_start:
    mov $SYSREAD, %eax
    mov $STDIN, %ebx
    mov $buff, %ecx
    mov $buff_len, %edx
    int $0x80

    mov $SYSWRITE, %eax
    mov $STDOUT, %ebx
    mov $buff, %ecx
    mov $buff_len, %edx
    int $0x80

    jmp _start
    