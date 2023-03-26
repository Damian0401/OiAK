SYSEXIT64 = 60
EXIT_SUCCESS = 0
SYSREAD = 0
SYSWRITE = 1
STDIN = 0
STDOUT = 1

.global mul_asm

.text

mul_asm:
    # first argument in rdi - first number pointer
    # second argument in rsi - second number pointer 
    # third argument in rdx - length of numbers rounded to byte size with zeroes
    
    
    pop %r8 # save return address
    
    mov %rbp, %r9 # save rbp
    mov %rsp, %rbp  # save stack pointer
    sub %rdx, %rsp  # reserve space 2 times greater than number
    sub %rdx, %rsp  # for result on stack
    dec %rsp # reserve for carry


    push %rdx
    mov $8, %r11
    mov %rdx, %rax
    mov $0, %rdx
    div %r11
    mov %rax, %r11 # move number of loops to r11
    pop %rdx

    push %rdx
    mov $2, %rax
    mov $0, %rdx
    mul %r11
    mov %rax, %r10 
    pop %rdx

    push %r8
    push %r9
    push %r12   # for using during programm 
    push %r13
    push %rdx   # overwritten in mul
    mov %rdi, %r12  # move first num pointer to r12
    mov %rsi, %r13

    xor %rsi, %rsi
    _zero:    # loop for clearing stack
    movq $0, (%rbp, %rsi, 8)
    inc %rsi
    cmp %r10, %rsi
    jl _zero


    # clear and push flags
    clc
    pushf
    # tutaj mnożenie ten tego

    xor %r10, %r10  # loop2 counter
    mov %r11, %rdi  # second number offset
    dec %rdi

    _loop2:
        mov %r11, %rsi  # first number offset
        dec %rsi

        mov %r10, %r8   # stack position offset
        
        xor %r9, %r9    # loop1 counter

        _loop1:
            xor %rdx, %rdx
            movq (%r12, %rsi, 8), %rax  # get 1st num with offset
            mulq (%r13, %rdi, 8)        # mul by 2nd with different offset

            clc
            movq (%rbp, %r8, 8), %rcx   # add previous result from stack to lower part of mul result
            adcq %rcx, %rax
            movq %rax, (%rbp, %r8, 8)   # save on stack
            
            adcq $0, %rdx   # add carry to higher part

            popf
            inc %r8         # move to higher part
            movq (%rbp, %r8, 8), %rcx   # add previous result from stack to higher part
            adcq %rcx, %rdx
            movq %rdx, (%rbp, %r8, 8)   # save on stack
            pushf


            dec %rsi
            inc %r9
            cmp %r11, %r9 
            jl _loop1

        inc %r8
        xor %rax, %rax
        popf
        movq (%rbp, %r8, 8), %rcx
        adcq %rcx, %rax     # add carry
        pushf
        movq %rax, (%rbp, %r8, 8)

        dec %rdi
        inc %r10
        cmp %r11, %r10
        jl _loop2
    
    # tutaj koniec mnożenia ten tego

    popf
    pop %rdx
    pop %r13
    pop %r12
    pop %r9
    pop %r8  
    
    mov $2, %rax
    mov %rdx, %r11
    mov $0, %rdx
    mul %r11
    mov %rax, %rdx

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
    