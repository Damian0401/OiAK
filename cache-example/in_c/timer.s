.global timer

timer:
    push %ebp
    mov %esp, %ebp

    movl $0, %eax
    rdtscp

    pop %ebp
    ret
