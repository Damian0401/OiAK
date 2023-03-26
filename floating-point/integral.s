SYSEXIT = 1
SYSREAD = 3
SYSWRITE = 4
STDOUT = 1
EXIT_SUCCESS = 0

.align 32

.data

format: .ascii "%f\n\0"

begin: .float 1
end: .float 20

height: .float 0
two_constant: .float 2
result: .double 0

iterations: .long 350

.text

.global main

calculate_height:
    fld end
    fsub begin
    fidiv iterations
    fstp height

    ret

calculate_fun:
    fld begin
    fsin
    fdiv begin

    ret

calculate_trapeze:
    call calculate_fun
    fld begin
    fadd height
    fstp begin
    call calculate_fun

    faddp %st(1)
    fmul height
    fdiv two_constant

    ret

calculate_integral:
    mov (iterations), %ecx
    call calculate_height

loop_calculate:
    call calculate_trapeze

    fadd result
    fstp result

    loop loop_calculate

    ret




main:
    call calculate_integral

    fld result

    subl $8, %esp
    fstpl (%esp)
    pushl $format
    call printf
    addl $12, %esp

    mov $SYSEXIT, %eax
    mov $EXIT_SUCCESS, %ebx
    int $0x80
