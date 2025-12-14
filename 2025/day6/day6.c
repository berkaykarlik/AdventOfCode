#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void parse_file(const char* filename, int **buff, int *size, int *col_count){

     //curr char read from file
    char ch;
    *col_count = -1;

    // buffer of all numbers
    size_t buffer_size= 128 * sizeof(int);
    *buff = (int*)malloc(buffer_size);

    // temp char buffer for current number or sign
    char curr_buff[10];
    int curr_buff_index = 0;

    // Opening file in reading mode
    FILE *fptr = fopen(filename, "r");
    // Reading file character by character
    while ((ch = fgetc(fptr)) != EOF){
        if (ch == ' ' || ch == '\n'){
            if (curr_buff_index > 0){
                curr_buff[curr_buff_index] = '\0';
                //resize buffer if needed
                if ((*size) * sizeof(int) >= buffer_size){

                    buffer_size *= 2;
                    (*buff) = realloc((*buff),buffer_size);
                    if (*buff == NULL)
                        printf("FUUCKK\n");
                }
                //convert signs to numbers too, we will diffirentiate by row count
                if (curr_buff[0] == '*')
                    (*buff)[(*size)++] = 1;
                else if (curr_buff[0] == '+')
                    (*buff)[(*size)++] = 0;
                else{
                    (*buff)[(*size)++] = atoi(curr_buff);
                }
                curr_buff_index = 0;
            }
            if (ch == '\n' && *col_count == -1)
                *col_count = *size;
        }
        else
            curr_buff[curr_buff_index++] = ch;
    }
    fclose(fptr);
}

int main(int argc, char ** argv) {

    int col_count = -1;
    int size = 0;
    int *buff;
    int tmp;
    int current_num;

    parse_file(argv[1],&buff, &size, &col_count);

    int row_count = (size+1) / col_count;
    printf("size %d col_count %d row count %d\n", size, col_count, row_count);

    long long * results = (long long*) malloc(sizeof(long long)* col_count);
    int * signs = (int*) malloc(sizeof(int)*col_count);

    //decide initial values for buffers and ops per column
    for(int j = 0; j < col_count; j++){
        tmp = buff[j + (row_count-1)*col_count];
        results[j] = tmp ? 1: 0;
        signs[j]   = tmp ? 1: 0;
    }

    //start calculations

    for (int i = 0; i < row_count -1; i ++){
        for(int j = 0; j < col_count ; j++){
            current_num = buff[j + i*col_count];
            printf("%d\t",current_num);
            if (signs[j] == 1){
                results[j] *= current_num;
            }
            else{
                results[j] += current_num;
            }
        }
        printf("\n");
    }

    //print cols
    printf("---results---\n");
    long long grand_total = 0;
    for(int j = 0; j < col_count; j++){
        printf("%lld\t", results[j]);
        grand_total += results[j];
    }
    printf("\ngrand total: %lld\n",grand_total);

    free(results);
    free(signs);
    free(buff);
    return 0;
}
