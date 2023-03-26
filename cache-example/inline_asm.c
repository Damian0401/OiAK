#include <stdio.h>

unsigned long long inline_rdtsc()
{
    unsigned long lo,hi;
    __asm__ __volatile__ ("rdtsc" : "=a" (lo), "=d" (hi));
    return ((unsigned long long)hi << 32) | lo;
}


int main()
{
    unsigned long long result = inline_rdtsc();

    printf("Hello, World! %llu\n", result);

    return 0;
}