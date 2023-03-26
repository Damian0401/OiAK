SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4

STDIN = 0
STDOUT = 1

EXIT_SUCCESS = 0


.data
var:
    .long 123456789

.align 32
.global _start

.bss
    .comm buffer, 9
    buffer_len = 9

.text

message:
    .ascii "0x"
message_len = . - message

newline:
    .ascii "\n"
newline_len = . - newline

_start:

    # Display '0x'
    mov $SYSWRITE, %eax
    mov $STDOUT, %ebx
    mov $message, %ecx
    mov $message_len, %edx
    int $0x80

    mov $10, %edi

    mov $0, %ecx


_loop:
    movl (var), %edx
    
    shr %cl, %edx
    andb $15, %dl

    cmpb $9, %dl
    jg _add_letter
    jmp _add_number

_next:
    movb %dl, buffer(, %edi, 1)

    add $4, %ecx
    dec %edi

    cmp $2, %edi
    jg _loop

    mov $SYSWRITE, %eax
    mov $STDOUT, %ebx
    mov $buffer, %ecx
    mov $buffer_len, %edx
    int $0x80 

    mov $SYSWRITE, %eax
    mov $STDOUT, %ebx
    mov $newline, %ecx
    mov $newline_len, %edx
    int $0x80

    mov $SYSEXIT, %eax
    mov $EXIT_SUCCESS, %ebx
    int $0x80

_add_number:
    addb $48, %dl
    jmp _next

_add_letter:
    addb $87, %dl
    jmp _next
