#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#define JOLT_LENGTH 12

int main(int argc, char** argv) {
    FILE *fptr = fopen(argv[1], "r");

    // Variables for storing data
    char bank[100] = {0};
    char banks_max[JOLT_LENGTH + 1] = {0};
    char replacement;
    unsigned long long total_output = 0;
    unsigned long long int_banks_max = 0;
    size_t bank_length;
    int tmp;

    // Read data of file in specific format
    while (fscanf(fptr, "%s", bank) == 1) {
        printf("Bank: %s \n", bank);

        bank_length = strlen(bank);
        strncpy(banks_max, bank + (bank_length - JOLT_LENGTH),JOLT_LENGTH);

        for (int i = bank_length - JOLT_LENGTH -1 ; i > -1; i --){
            replacement = bank[i];
            // printf("checking %c\n", bank[i]);
            for(int j = 0; j  < JOLT_LENGTH; j++){
                // printf("hey: %c \n", replacement);
                // printf("hey: %c \n", banks_max[j]);
                if ( replacement >= banks_max[j]){
                    // printf("TRUE");
                    tmp = replacement;
                    replacement = banks_max[j];
                    banks_max[j] = tmp;
                }
                else{
                    break;
                }
            }
        }
        // printf("max: %s \n", banks_max);

        int_banks_max = strtoull(banks_max, NULL ,10);

        printf("int converted max: %llu\n", int_banks_max);
        total_output += int_banks_max;
    }

    printf("Part 1 answer: total max output: %llu", total_output);
    fclose(fptr);
    return 0;
}
