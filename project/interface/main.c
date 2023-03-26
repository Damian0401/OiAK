#include <stdio.h>
#include <stdlib.h>

void add_asm(char*, char*, unsigned long long);
void sub_asm(char*, char*, unsigned long long);
void mul_asm(char*, char*, unsigned long long);
void div_asm(char*, char*, unsigned long long);
void mod_asm(char*, char*, unsigned long long);

// Change input string to byte array
char* getNumber(char* string, int numberSize)
{
    // Calculate length of passed string and change ascii characters to values
    int stringSize = 0;
    for (int i = 0; string[i] != '\0' ; i++)
    {
        if (string[i] >= '0' && string[i] < '9')
        {
            string[i] -= 48;
        } else {
            string[i] -= 87;
        }

        stringSize++;
    }

    int iterator = 0;

    // Calculate length of zeros needed to fill array
    int resultAdditionSize = (8 - (((stringSize + 1) / 2) % 8)) % 8;

    // Calculate length of result
    int resultSize = ((stringSize + 1) / 2) + resultAdditionSize;

    if (numberSize > resultSize)
    {
        resultAdditionSize += (numberSize - resultSize);
        resultSize = numberSize;
    }

    // Allocate memory for result
    char* result = (char*) malloc(resultSize * sizeof(char));
    for (int i = 0; i < resultSize; i++)
    {
        result[i] = 0;
    }

    int resultIndex = resultAdditionSize;

    if (stringSize % 2 == 1)
        iterator++;

    // Generate result
    char temp = 0;
    for (int i = 0; i < stringSize; i++)
    {
        if (iterator % 2 == 1)
        {
            temp = temp | string[i];
            result[resultIndex] = temp;
            temp = 0;
            resultIndex++;
            iterator++;
            continue;
        }
        iterator++;
        temp = temp | (string[i] << 4);
    }

    // Allocate memory of result in little endian
    char* resultLittleEndian = (char*) malloc(resultSize * sizeof(char));
    int helper = -1;
    for (int i = 0; i < resultSize; i += 8)
    {
        helper += 8;
        for (int j = 0; j < 8; j++)
        {
            resultLittleEndian[i + j] = result[helper - j];
        }
    }

    free(result);
    return resultLittleEndian;
}

void run(int selectedOperation)
{
    int bufforSize = 600;

    // Allocate memory for two numbers
    char* bufforFirst = (char*) malloc (bufforSize * sizeof(char));
    char* bufforSecond = (char*) malloc (bufforSize * sizeof(char));

    // Read first number
    scanf("%600s", bufforFirst);
    int firstSize = 0;
    while(bufforFirst[++firstSize] != '\0');
    firstSize = (firstSize + 1) / 2;

    // Read second number
    scanf("%600s", bufforSecond);
    int secondSize = 0;
    while(bufforSecond[++secondSize] != '\0');
    secondSize = (secondSize + 1) / 2;

    // Check which number is bigger 
    int biggerSize = firstSize > secondSize ? firstSize : secondSize;

    // Align the length of numbers to register length
    while(biggerSize % 8 != 0)
    {
        biggerSize++;
    }

    // Convert first number to byte array
    char* firstNumber = getNumber(bufforFirst, biggerSize);
    
    // Convert second number to byte array
    char* secondNumber = getNumber(bufforSecond, biggerSize);

    int isZero = 0;

    // Call assembly
    switch (selectedOperation)
    {
    case 'a':
        add_asm(firstNumber, secondNumber, biggerSize);
        break;
    case 's':
        sub_asm(firstNumber, secondNumber, biggerSize);
        break;
    case 'm':
        mul_asm(firstNumber, secondNumber, biggerSize);
        break;    
    case 'd':
        for (int i = 0; i < biggerSize; i++)
        {
            if (secondNumber[i] != 0)
                isZero++;
        }

        if (isZero == 0)
            return;


        div_asm(firstNumber, secondNumber, biggerSize);
        break;
    case 'r':
        for (int i = 0; i < biggerSize; i++)
        {
            if (secondNumber[i] != 0)
                isZero++;
        }

        if (isZero == 0)
            return;


        mod_asm(firstNumber, secondNumber, biggerSize);
        break;
    }
}



int main(int argc, char *argv[]) 
{
    run(argv[1][0]);

    return 0;
}