SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0

.align 32

.data                                     
    first: .long 0x00000000, 0x00000000, 0x00000001
    first_len = (. - first) / 4

    second: .long 0x00000000, 0x00000000, 0x00000002
    second_len = (. - second) / 4

.text

.global _start
    
_start:
    # store numbers length in esi and edi
    movl $first_len, %esi
    movl $second_len, %edi

    # save stack pointer to ebx
    mov %esp, %ebx

    # reserve space for result (longer number + carry)
    cmp %esi, %edi
    jg _first_longer

    # get full lenghth
    mov $4, %eax
    mul %esi
    # save full length of longer number to edx (iterate at end)
    mov %eax, %edx
    # reserve space
    sub %eax, %esp
    jmp _next
    
_first_longer:
    # multiply length of first number by 4
    mov $4, %eax
    mul %edi
    
    # save full length of fisrt number to edx
    mov %eax, %edx

    # save space on stack
    sub %eax, %esp

_next:
    # reserve space for carry
    dec %esp
    inc %edx 

    # decrement length for iterating
    dec %edi
    dec %esi

    # clear and push flags
    clc
    pushf

    # xd
    mov $0, %ecx

_sub:
    # check if some digits of the first number stil left
    cmp $0, %esi

    # move only zeros to eax if there is no digits left
    jl _move_zeros

    # move digits of the first number to eax
    movl first(,%esi, 4), %eax

    # decrement current length of the first number
    dec %esi

_move_ret:    
    # check if some digits of the second number stil left
    cmp $0, %edi
    jl _sub_zeros

    # subtract next byte
    popf
    sbbl second(,%edi, 4), %eax
    pushf
    # decrement current length of the second number
    dec %edi

_sub_ret:
    # push to stack 
    mov %eax, (%ebx,%ecx,4)
    inc %ecx

    # if any digits of numbers still left - jmp to _sub
    cmp $0, %edi
    jge _sub 

    cmp $0, %esi
    jge _sub 

    # clear eax and subtract carry as last step
    xor %eax, %eax
    popf
    sbb $0, %eax
    mov %eax, (%ebx,%ecx,4)

    # edx is defined earlier
    mov %ebx, %ecx
    mov $SYSWRITE, %eax
    mov $STDOUT, %ebx
    int $0x80

    mov $SYSEXIT, %eax
    mov $0, %ebx
    int $0x80

_move_zeros:
    # move zeros to eax
    movl $0, %eax
    jmp _move_ret


_sub_zeros:
    # subtract zeros with borrow to eax
    popf
    sbbl $0, %eax
    pushf
    jmp _sub_ret
