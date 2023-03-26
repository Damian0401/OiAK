#include <stdio.h>
#include <stdlib.h>

double cpuClock =  3693063000;
int tabSize = 5000;


unsigned long long timer();
unsigned long long measureRows();
unsigned long long measureColumns();
double getSummaryTime(unsigned long long cycles);

int main(){

    double rowTime = getSummaryTime(measureRows());
    double columnTime = getSummaryTime(measureColumns());

    printf("Iterating through columns: %f[s]\nIterating through rows: %f[s]\n", columnTime, rowTime);
    return 0;
}

unsigned long long measureRows(){
    unsigned long long rowsCycles = 0;
    unsigned long long before = 0;
    unsigned long long after = 0;

    int** tab = (int**) malloc(tabSize * sizeof(int*));
    for (int i = 0; i < tabSize; i++)
    {
        tab[i] = (int*) malloc(tabSize * sizeof(int));
    }
    
    int number;

    for(size_t i = 0; i < tabSize; i++){
        for(size_t j = 0; j < tabSize; j++){
            before = timer();
            tab[j][i] = i;
            after = timer();

            rowsCycles += (after - before);
        }
    }

    for (int i = 0; i < tabSize; i++)
    {
        free (tab[i]);
    }
    free (tab);

    return rowsCycles;
}

unsigned long long measureColumns(){
    unsigned long long columnsCycles = 0;

    unsigned long long before;
    unsigned long long after;

    int** tab = (int**)malloc(tabSize * sizeof(int*));
    for (int i = 0; i < tabSize; i++)
    {
        tab[i] = (int*)malloc(tabSize * sizeof(int));
    }

    for(size_t i = 0; i < tabSize; i++){
        for(size_t j = 0; j < tabSize; j++){
            before = timer();
            tab[i][j] = i;
            after = timer();
            
            columnsCycles += (after - before);
        }
    }

    for (int i = 0; i < tabSize; i++)
    {
        free (tab[i]);
    }
    free (tab);

    return columnsCycles;
}

inline double getSummaryTime(unsigned long long cycles){
    return cycles / cpuClock;
}