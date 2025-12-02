#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int main(int argc, char** argv) {
    // Character that store the read
    // character
    char ch;
    int current_val = 50;
    int zero_count = 0;
    int pass_zero = 0;

    char *filename = argv[1];
    // Opening file in reading mode
    FILE *fptr = fopen(filename, "r");
    if (!fptr) {
        // alternatively, just `perror(argv[1])`
        fprintf(stderr, "cannot open %s \n", filename);
        return 1;
    }
    // Reading file character by character
    while ((ch = fgetc(fptr)) != EOF){
        char number[4] = {'\0', '\0', '\0', '\0'};
        int i = 0;
        char tmp;
        while ((tmp = fgetc(fptr)) != '\n' && tmp != '\r')
            number[i++] = tmp;
        int num = atoi(number);

       if (ch == 'L'){
            while (num > 0){
                current_val --;
                num --;
                if (current_val == 0){
                    pass_zero ++;
                }
                else if(current_val == -1){
                    current_val = 99;
                }
            }
            if (current_val == 0){
                zero_count ++;
            }
       }
       else if(ch == 'R'){
            while (num > 0){
                current_val ++;
                num --;
                if(current_val == 100){
                    current_val = 0;
                    pass_zero ++;
                }
            }
            if (current_val == 0){
                zero_count ++;
            }
       }
    }

    printf("zero count: %d\n", zero_count);
    printf("pass zero %d \n",pass_zero);
    // Closing the file
    fclose(fptr);
    return 0;
}
