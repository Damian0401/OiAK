.global my_rdtsc

my_rdtsc:
    push %ebp
    mov %esp, %ebp

    movl $0, %eax
    rdtscp

    pop %ebp
    ret
