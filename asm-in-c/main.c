#include <stdio.h>

unsigned long add_fun(unsigned long first, unsigned long second);

int main()
{
    unsigned long first = 5;
    unsigned long second = 10;
    
    unsigned long result = add_fun(first, second);

    
    printf("Wynik: %lu\n", result);
    
    return 0;
}