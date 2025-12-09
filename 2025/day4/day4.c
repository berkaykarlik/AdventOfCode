#include <stdio.h>
#include <math.h>
#define FIELD_SIZE 139
#define LIMIT 4

void print_arr(char field[][FIELD_SIZE]) {
    for(int i = 0; i < FIELD_SIZE; i++) {
        for(int j = 0; j < FIELD_SIZE; j++) {
            printf("%c ", field[i][j]);
        }
        printf("\n");
    }
}

struct coordinates{
    int r;
    int c;
};

void count_removable(char field[][FIELD_SIZE], struct coordinates to_be_removed[], int *removable_count){

    int total_movable = 0;
    int currs_around= -1;
    int fi = 0, si = 0;

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
                if(currs_around < LIMIT){
                    to_be_removed[total_movable] = (struct coordinates){k, j};
                    total_movable ++;
                }
            }
        }
    }
    printf("TOTAL MOVABLE: %d\n", total_movable);
    *removable_count = total_movable;
}

void clean_field(char field[][FIELD_SIZE], struct coordinates to_be_removed[], int removable_count){
    for (int i = 0; i < removable_count; i ++){
        struct coordinates to_remove = to_be_removed[i];
        field[to_remove.r][to_remove.c] = '.';
    }
}


int main(int argc, char** argv) {
    FILE *fptr = fopen(argv[1], "r");

    char field[FIELD_SIZE][FIELD_SIZE];
    int i = 0;
    int removable_count = 0;
    struct coordinates to_be_removed[FIELD_SIZE*FIELD_SIZE];


    while (fscanf(fptr, "%s", field[i]) == 1) {i++;}
    // print_arr(field);

    int grand_total_removed = 0;

    do{
    removable_count = 0;
    count_removable(field, to_be_removed, &removable_count);
    clean_field(field, to_be_removed, removable_count);
    grand_total_removed += removable_count;
    }while(removable_count > 0);

    printf("removed %d in total\n", grand_total_removed);
    fclose(fptr);
    return 0;
}
