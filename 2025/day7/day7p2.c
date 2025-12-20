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


    long long traverse_light(char (*grid)[MAX_LENGTH], long long (*mem)[MAX_LENGTH], int row_count, int col_count, Point curr){
        long long res;
        if ((curr.x < row_count) && (curr.y < col_count) && (curr.y >= 0)){
            if (mem[curr.x][curr.y])
                return mem[curr.x][curr.y];
            //propagate
            if(grid[curr.x][curr.y] == '.'){
                Point next = {.x=curr.x+1,.y=curr.y};
                res = traverse_light(grid, mem, row_count, col_count, next);
                mem[curr.x][curr.y] = res;
                return res;
            }
            //split
            if(grid[curr.x][curr.y] == '^'){
                long long l = 0, r = 0;
                if (curr.y -1 > -1 ){
                    Point next = {.x=curr.x+1,.y=curr.y-1};
                    l = traverse_light(grid, mem, row_count, col_count, next);
                }
                if (curr.y +1 < col_count ){
                    Point next = {.x=curr.x+1,.y=curr.y+1};
                    r = traverse_light(grid, mem, row_count, col_count, next);
                }
                res = l + r;
                mem[curr.x][curr.y] = res;
                return res;
            }
            return 0;
        }
        else
            return 1;
    }


    int main(int argc, char** argv) {
        FILE *fptr = fopen(argv[1], "r");

        char grid[MAX_LENGTH][MAX_LENGTH];
        long long mem[MAX_LENGTH][MAX_LENGTH];
        char buff[MAX_LENGTH];
        int row_count = 0;

        while (fgets(buff, MAX_LENGTH, fptr)) {
            strcpy(grid[row_count],buff);
            row_count ++;

        };

        int col_count = get_first_index_of_c(grid[0], '\n');
        int s_index = get_first_index_of_c(grid[0],'S');
        printf("col count %d\t row count %d\t s index %d\n", col_count, row_count, s_index);

        long long  split_count = 0;
        Point start = {1, s_index};
        split_count = traverse_light(grid, mem, row_count, col_count, start );

        for (int i = 0; i< row_count; i++)
            printf("%s", grid[i]);

        printf("number of total splits %lld \n",split_count);
        fclose(fptr);
        return 0;
    }
