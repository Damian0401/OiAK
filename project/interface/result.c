#include <stdio.h>
#include <stdlib.h>

// Change number to ascii character 
char numberToAscii(char number)
{
    return number < 10
            ? number + 48
            : number + 87;
}

int main()
{
    int bufforSize = 600;

    char* fileName = "result.bin";

    // Allocate memory for data from file
    char* buffor = (char*) malloc (bufforSize * sizeof(char));
    char* reversedBuffor = (char*) malloc (2 * bufforSize * sizeof(char));
    for (int i = 0; i < bufforSize * 2; i++)
    {
        reversedBuffor[i] = '\0';
    }
    int dataSize = 0;

    // Open file
    FILE* file = fopen(fileName, "r"); 
    char singleByte;

    // Read file
    while(!feof(file))
    {
        singleByte = fgetc(file);

        if (dataSize > bufforSize)
            break;

        buffor[dataSize] = singleByte;
        dataSize++;
    }
    dataSize--;
    
    // Close file
    fclose(file);

    // Reverse the buffor
    int resultIndex = 0;
    for (int i = dataSize - 1; i >= 0; i--)
    {
        singleByte = (buffor[i] & 0xf0) >> 4;
        reversedBuffor[2 * resultIndex] = numberToAscii(singleByte);

        singleByte = buffor[i] & 0x0f;
        reversedBuffor[2 * resultIndex + 1] = numberToAscii(singleByte);

        resultIndex++;
    }

    // Save copy of the buffor 
    char* reversedBufforCopy = reversedBuffor;

    // Cut off zeros from the beginnig
    while(reversedBuffor[0] == '0')
        reversedBuffor++;

    // Print result
    printf("%s\n", reversedBuffor);

    // Free memory
    free(buffor);
    free(reversedBufforCopy);

    return 0;
}