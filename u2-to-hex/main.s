.align 32

SYSEXIT  = 1
SYSREAD  = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

buffer_len = 9

.bss
    .comm buffer, 9

.data
number:
    .long -123456789


.text
    minus: .ascii "-"
    minus_len = . - minus

.global _start

_start:
    movb $'\n', (buffer + 8)

    mov $0, %ecx # przesuniecia    
    mov $7, %esi # licznik petli
    
    call _check_sign

_loop:
    movl (number), %edx
    shr %cl, %edx
    andb $15, %dl
    
    call _add_ascii
    movb %dl, buffer(,%esi,1)

    add $4, %ecx
    dec %esi

    cmp $0, %esi
    jge _loop

    movl $SYSWRITE, %eax
    movl $STDOUT, %ebx
    movl $buffer, %ecx
    movl $buffer_len, %edx
    int  $0x80

    mov $SYSEXIT, %eax
    mov $EXIT_SUCCESS, %ebx
    int $0x80

_add_ascii:
    cmpb $9, %dl
    jg _add_letter
    jmp _add_number

_add_number:
    addb $48, %dl
    ret

_add_letter:
    addb $87, %dl
    ret



_check_sign:
    movb (number), %al

    cmp $0, %al
    jge _loop

    movl (number), %edi
    not %edi
    inc %edi

    movl %edi, (number)

    mov %ecx, %ebp # zachowanie licznika przesuniecia

    movl $SYSWRITE, %eax
    movl $STDOUT, %ebx
    movl $minus, %ecx
    movl $minus_len, %edx
    int  $0x80

    mov %ebp, %ecx # przywrocenie licznika przesuniecia

    ret
