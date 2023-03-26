SYSEXIT64 = 60
EXIT_SUCCESS = 0
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

.global sub_asm

.text

sub_asm:
    # first argument in rdi - first number pointer
    # second argument in rsi - second number pointer 
    # third argument in rdx - length of numbers rounded to byte size with zeroes
    
    pop %r8 # save return address
    
    mov %rbp, %r9 # save rbp
    mov %rsp, %rbp  # save stack pointer
    sub %rdx, %rsp  # reserve space for result on stack
    dec %rsp # reserve for carry

    push %rdx
    mov $8, %r11
    mov %rdx, %rax
    mov $0, %rdx
    div %r11
    mov %rax, %r11 # move number of loops to r11
    pop %rdx

    # clear and push flags
    clc
    pushf

    mov $0, %r10
    
subbing_loop:

    dec %r11    # decrement loops for iterating
    
    xor %rax, %rax
    mov (%rdi, %r11, 8), %rax     # move digits of the first number to rax
    popf
    sbb (%rsi, %r11, 8), %rax     # subb digits of the second number with borroe to rax
    pushf

    mov %rax, (%rbp, %r10, 8)    # push to stack 
    inc %r10
    
    cmp $0, %r11
    jne subbing_loop

    xor %rax, %rax
    popf
    sbb $0, %rax    # clear rax and sub borrow as last step
    mov %al, (%rbp, %r10, 8)

    inc %rdx
    mov $SYSWRITE, %rax
    mov $STDOUT, %rdi
    mov %rbp, %rsi 
    syscall


    add %rdx, %rsp  # restore stack

    mov %rbp, %rsp
    mov %r9, %rbp
    mov $0, %rax

    push %r8

    mov $SYSEXIT64, %rax
    mov $EXIT_SUCCESS, %rdi
    syscall
    