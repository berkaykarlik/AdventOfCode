#include <stdio.h>
#include <string.h>

#define MAX_LENGTH 150


int get_first_index_of_c(char* s, char c){
    char *e;
    e = strchr(s, c);
    return (int)(e - s);
}

typedef struct {
  int x, y;
} Point;


int traverse_light(char (*grid)[MAX_LENGTH], int row_count, int col_count, Point curr, int *split_count){
    if ((curr.x < row_count) && (curr.y < col_count)){
        //propagate
        if(grid[curr.x][curr.y] == '.'){
            grid[curr.x][curr.y] = '|';
            Point next = {.x=curr.x+1,.y=curr.y};
            traverse_light(grid, row_count, col_count, next, split_count);
        }

        //split
        if(grid[curr.x][curr.y] == '^'){
            (*split_count)++;
            if (curr.y -1 > -1 ){
                if(grid[curr.x][curr.y-1] != '|'){ // not already processed by another split
                    grid[curr.x][curr.y-1] = '|';
                    Point next = {.x=curr.x+1,.y=curr.y-1};
                    traverse_light(grid, row_count, col_count, next, split_count);
                }
            }
            if (curr.y +1 < col_count ){
                if(grid[curr.x][curr.y+1] != '|'){ // not already processed by another split
                    grid[curr.x][curr.y+1] = '|';
                    Point next = {.x=curr.x+1,.y=curr.y+1};
                    traverse_light(grid, row_count, col_count, next, split_count);
                }
            }
        }
    }
}


int main(int argc, char** argv) {
    FILE *fptr = fopen(argv[1], "r");

    char grid[MAX_LENGTH][MAX_LENGTH];
    char buff[MAX_LENGTH];
    int row_count = 0;

    while (fgets(buff, MAX_LENGTH, fptr)) {
        strcpy(grid[row_count],buff);
        row_count ++;

    };

    int col_count = get_first_index_of_c(grid[0], '\n');
    int s_index = get_first_index_of_c(grid[0],'S');
    printf("col count %d\t row count %d\t s index %d\n", col_count, row_count, s_index);

    int split_count = 0;
    Point start = {1, s_index};
    traverse_light(grid, row_count, col_count, start, &split_count);

    for (int i = 0; i< row_count; i++)
        printf("%s", grid[i]);

    printf("number of total splits %d \n",split_count);
    fclose(fptr);
    return 0;
}
