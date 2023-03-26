

.data
first: .ascii "%llu\n"

.text

.global main

main:
    rdtscp

    push %edx
    push %eax
    push $first
    call printf
    add $12, %esp

    
