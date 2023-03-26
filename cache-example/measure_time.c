#include <stdio.h>

unsigned long long my_rdtsc();

int main()
{
    unsigned long long result = my_rdtsc();

    printf("Hello, World! %llu\n", result);

    return 0;
}