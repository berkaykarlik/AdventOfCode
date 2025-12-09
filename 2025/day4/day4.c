#include <stdio.h>
#include <math.h>
#define FIELD_SIZE 10
#define LIMIT 4


void print_arr(char field[][FIELD_SIZE]) {
    for(int i = 0; i < FIELD_SIZE; i++) {
        for(int j = 0; j < FIELD_SIZE; j++) {
            printf("%c ", field[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char** argv) {
    FILE *fptr = fopen(argv[1], "r");

    char field[FIELD_SIZE][FIELD_SIZE];
    int i = 0;
    int total_movable = 0;
    int currs_around= -1;
    int fi = 0, si = 0;

    while (fscanf(fptr, "%s", field[i]) == 1) {i++;}
    // print_arr(field);

    for (int k = 0; k < FIELD_SIZE; k++)
    {
        for (int j = 0; j < FIELD_SIZE; j++)
        {
            if (field[k][j] == '@'){
                currs_around = -1;
                for (int r = -1; r < 2; r++)
                {
                    for (int c = -1; c < 2; c++)
                    {
                        fi = k + r;
                        si = j + c;
                        //edges may overflow, skip
                        if ( (fi < 0) ||
                             (fi > (FIELD_SIZE -1)) ||
                             (si < 0) ||
                             (si > (FIELD_SIZE -1))
                            )
                            continue;

                        if (field[fi][si] == '@')
                            currs_around ++;
                    }
                }
                if(currs_around < LIMIT)
                    total_movable ++;
            }
        }
    }
    printf("TOTAL MOVABLE: %d\n", total_movable);

    fclose(fptr);
    return 0;
}
