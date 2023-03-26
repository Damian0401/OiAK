

.global my_rdtsc

my_rdtsc:
    push %ebp
    mov %esp, %ebp
    push %ebx

    cmp $0, 8(%ebp)    
    je else

    # if not 0
    movl $0, %eax
    cpuid
    rdtsc
    jmp end

else:
    # if 0
    movl $0, %eax
    rdtscp

end:
    pop %ebx
    pop %ebp
    ret
