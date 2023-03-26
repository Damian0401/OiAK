.align 32

SYSEXIT  = 1
SYSREAD  = 3
SYSWRITE = 4

STDIN  = 0
STDOUT = 1

EXIT_SUCCESS = 0

.data
format:   .ascii "%d\n" 

.text


.global add_fun

add_fun:
    push %ebp

    mov %esp, %ebp
    
    movl 8(%ebp), %eax
    addl 12(%ebp), %eax

    push %eax
    push $format
    call printf
    add $4, %esp
    pop %eax

    pop %ebp
    ret
