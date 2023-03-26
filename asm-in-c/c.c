#include <stdio.h>

long long unsigned my_rdtsc(char);

int main()
{
    printf("%llu\n", my_rdtsc(0));

    return 0;
}