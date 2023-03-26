SYSEXIT64 = 60
EXIT_SUCCESS = 0
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

.global mod_asm

.text

mod_asm:
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

    xor %r10, %r10
    mov %r13, %rbp

    load_result:
    dec %r11
    mov (%rdi, %r11, 8), %rax     # move digits of the second number to rax
    mov %rax, (%rbp, %r10, 8)    # push to stack 
    inc %r10
    
    cmp $0, %r11
    jne load_result

    xor %rdi, %rdi

mod_loop:
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
    jc _end_mod # if sub result is lower than zero - end calculating

    # count how many times made subb

    xor %r10, %r10
    mov %r12, %r11

    copy_loop:
        mov %r14, %rbp

        xor %rax, %rax
        mov (%rbp, %r10, 8), %rax     # move digits of the result to rax

        mov %r13, %rbp
        mov %rax, (%rbp, %r10, 8)   # push to result stack

        inc %r10
        dec %r11
        cmp $0, %r11
    jne copy_loop

    jmp mod_loop



    _end_mod:
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
    