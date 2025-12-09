#include <stdio.h>
#include <stdlib.h>

typedef struct{
    int start;
    int end;
}Range;

//dont forget to dealloc ranges and ids
void parse_file(char* filename, Range **ranges_p, int **ids_p, int *ranges_size, int *ids_size){

    int ranges_buffer_size = 2;
    *ranges_p = (Range*)malloc(ranges_buffer_size* sizeof(Range));
    int read_index = 0;

    FILE *fptr;
    fptr = fopen(filename, "r");

    int start = 0;
    int end = 0;
    printf("reading ranges\n");
    while (fscanf(fptr, "%d-%d", &start, &end) == 2) {
        printf("start: %d\t end: %d\n", start, end);

        if((ranges_buffer_size - read_index) <= 0){
            ranges_buffer_size *= 2;
            Range *temp = realloc(*ranges_p,sizeof(Range) * ranges_buffer_size);
            if (temp == NULL) {
                printf("realloc failed, abondoning all hope...\n");
                free(*ranges_p);
                fclose(fptr);
                return;
            }
            *ranges_p = temp;
        }
        (*ranges_p)[read_index++] = (Range){start,end};
    }
   *ranges_size = read_index;

   int ids_buffer_size = 2;
   *ids_p = (int*)malloc(sizeof(int)* ids_buffer_size);
   read_index = 0;

   int current_id = 0;
    printf("reading ids\n");
    while (fscanf(fptr, "%d", &current_id) == 1) {
        printf("id:\t%d\n", current_id);

        if((ranges_buffer_size - read_index) <= 0){
            ids_buffer_size *= 2;
            int* temp = realloc(*ids_p,sizeof(int) * ids_buffer_size);
            if (temp == NULL) {
                printf("realloc failed, abondoning all hope...\n");
                free(*ranges_p);
                free(*ids_p);
                fclose(fptr);
                return;
            }
            *ids_p = temp;
        }
        (*ids_p)[read_index++] = current_id ;
    }
    *ids_size = read_index;
   fclose(fptr);
}

int main(int argc, char** argv){

    int *ids;
    Range *ranges;
    int ranges_size, ids_size;

    parse_file(argv[1],&ranges,&ids, &ranges_size, &ids_size);
    printf("ranges_size %d \n", ranges_size);

    // verifying range parsing
    for (int i = 0; i < ranges_size; i ++){
        printf("start: %d \tend %d\n", ranges[i].start, ranges[i].end);
    }
    //verfying ids parsing
    for (int i = 0; i < ids_size; i++){
        printf("id%d:\t %d\n",i, ids[i]);
    }

    //Answer goes here

    free(ranges);
    free(ids);
    return 0;
}