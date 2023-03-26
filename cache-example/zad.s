.align 32

SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0


.bss
    .comm table1, 1024
    .comm table2, 10240
    .comm table3, 102400

.data
    fill_arg: .ascii "1:\n1kB:   %lu\n10kB:  %lu\n100kB: %lu\n\0"
    fill_arg_len = . - fill_arg

    read_arg: .ascii "\n2:\n1kB:   %lu\n10kB:  %lu\n100kB: %lu\n\0"

.text

.global main

main:

    # fill first table
    mov $0, %esi
    mov $0, %eax
    rdtscp
    mov %eax, %edi
tab1:
    movl $0, table1(, %esi, 4)
    inc %esi
    cmp $256, %esi
    jl tab1
    rdtscp
    sub %edi, %eax 
    mov %eax, %ecx

    # fill second table
    mov $0, %esi
    mov $0, %eax
    rdtscp
    mov %eax, %edi
tab2:
    movl $0, table2(, %esi, 4)
    inc %esi
    cmp $2560, %esi
    jl tab2
    rdtscp
    sub %edi, %eax 
    mov %eax, %ebx

    # fill third table
    mov $0, %esi
    mov $0, %eax
    rdtscp
    mov %eax, %edi
tab3:
    movl $0, table3(, %esi, 4)
    inc %esi
    cmp $25600, %esi
    jl tab3
    rdtscp
    sub %edi, %eax 

    # fill print results
    pushl %eax
    pushl %ebx
    pushl %ecx
    pushl $fill_arg
    call printf
    add $16, %esp

# read from table1
    mov $0, %esi
    mov $0, %eax
    mov $0, %edx
read1:
    rdtscp
    mov %eax, %ebx
    movl table1(, %esi, 4), %edx
    rdtscp
    sub %ebx, %eax
    add %eax, %edx
    inc %esi    
    cmp $256, %esi
    jl read1
    push %edx

# read from table2
    mov $0, %esi
    mov $0, %eax
    mov $0, %edx
read2:
    rdtscp
    mov %eax, %ebx
    movl table2(, %esi, 4), %edx
    rdtscp
    sub %ebx, %eax
    add %eax, %edx
    inc %esi    
    cmp $2560, %esi
    jl read2
    push %edx

# read from table3
    mov $0, %esi
    mov $0, %eax
    mov $0, %edx
read3:
    rdtscp
    mov %eax, %ebx
    movl table3(, %esi, 4), %edx
    rdtscp
    sub %ebx, %eax
    add %eax, %edx
    inc %esi    
    cmp $25600, %esi
    jl read3
    push %edx
    
    push $read_arg
    call printf

    # exit
    mov $SYSEXIT, %eax
    mov $EXIT_SUCCESS, %ebx
    int $0x80
    
