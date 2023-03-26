SYSEXIT64 = 60
EXIT_SUCCESS = 0
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

.global div_asm

.text

div_asm:
    # first argument in rdi - first number pointer
    # second argument in rsi - second number pointer 
    # third argument in rdx - length of numbers rounded to byte size with zeroes
    
    pop %r8 # save return address
    
    mov %rbp, %r9 # save rbp
    mov %rsp, %rbp  # save stack pointer
    sub %rdx, %rsp  # reserve space for sub result on stack

    push %rdx
    mov $8, %r11
    mov %rdx, %rax
    mov $0, %rdx
    div %r11
    mov %rax, %r11 # move number of loops to r11
    pop %rdx

    xor %r10, %r10
    mov %r11, %rcx
    
    load_first_num:
    dec %rcx
    mov (%rdi, %rcx, 8), %rax     # move digits of the first number to rax
    mov %rax, (%rbp, %r10, 8)    # push to stack 
    inc %r10
      
    cmp $0, %rcx
    jne load_first_num


    mov %rsp, %rcx  # save sub result stack pointer
    sub %rdx, %rsp  # reserve space for result on stack

    push %r12
    push %r13
    push %r14

    mov %r11, %r12
    mov %rcx, %r13
    mov %rbp, %r14

    mov %r13, %rbp
    xor %rdi, %rdi
    
    _zero:    # loop for clearing stack
    movq $0, (%rbp, %rdi, 8)
    inc %rdi
    cmp %r11, %rdi
    jl _zero


div_loop:
    # clear and push flags
    clc
    pushf

    xor %r10, %r10
    mov %r12, %r11
    mov %r14, %rbp
    
    subbing_loop:

        dec %r11    # decrement loops for iterating
        
        xor %rax, %rax
        mov (%rbp, %r10, 8), %rax     # move digits of the first number to rax
        popf
        sbb (%rsi, %r11, 8), %rax     # subb digits of the second number with borrow to rax
        pushf

        mov %rax, (%rbp, %r10, 8)    # push to stack 
        inc %r10
        
        cmp $0, %r11
        jne subbing_loop


    popf
    jc _end_div # if sub result is lower than zero - end calculating

    # count how many times made subb

    xor %r10, %r10
    mov %r12, %r11
    mov %r13, %rbp

    xor %rax, %rax
    mov (%rbp, %r10, 8), %rax     # move digits of the result to rax
    clc
    adc $1, %rax     # add 1 to result
    pushf
    mov %rax, (%rbp, %r10, 8)    # push to stack 

    inc %r10
    dec %r11
    cmp $0, %r11
    je _end_add

    adding_loop:

        dec %r11    # decrement loops for iterating
        
        xor %rax, %rax
        mov (%rbp, %r10, 8), %rax     # move digits of the result to rax
        popf
        adc $0, %rax     # add carry to result
        pushf

        mov %rax, (%rbp, %r10, 8)    # push to stack 
        inc %r10
        
        cmp $0, %r11
        jne adding_loop

    _end_add:
    popf

    jmp div_loop



    _end_div:
    mov %r13, %rbp
    mov %r14, %rsp

    pop %r12
    pop %r13
    pop %r14

    mov $SYSWRITE, %rax
    mov $STDOUT, %rdi
    mov %rbp, %rsi 
    syscall


    mov %r9, %rbp
    mov $0, %rax

    push %r8

    mov $SYSEXIT64, %rax
    mov $EXIT_SUCCESS, %rdi
    syscall
    