#include <stdio.h>
#include <stdlib.h>

typedef struct{
    long long start;
    long long end;
}Range;

//dont forget to dealloc ranges and ids
void parse_file(char* filename, Range **ranges_p, long long **ids_p, int *ranges_size, int *ids_size){

    int ranges_buffer_size = 2;
    *ranges_p = (Range*)malloc(ranges_buffer_size* sizeof(Range));
    int read_index = 0;

    FILE *fptr;
    fptr = fopen(filename, "r");

    long long start = 0;
    long long end = 0;
    // printf("reading ranges\n");
    while (fscanf(fptr, "%lld-%lld", &start, &end) == 2) {
        // printf("start: %d\t end: %d\n", start, end);

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
   *ids_p = (long long*)malloc(sizeof(long long)* ids_buffer_size);
   read_index = 0;

   long long current_id = 0;
    // printf("reading ids\n");
    while (fscanf(fptr, "%lld", &current_id) == 1) {
        // printf("id:\t%d\n", current_id);

        if((ids_buffer_size - read_index) <= 0){
            ids_buffer_size *= 2;
            long long* temp = realloc(*ids_p,sizeof(long long) * ids_buffer_size);
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

int is_in_range(long long i, Range r){
    if ((i >= r.start) && (i <= r.end))
        return 1;
    return 0;
}

int main(int argc, char** argv){

    long long *ids;
    Range *ranges;
    int ranges_size, ids_size;
    int fresh_ones = 0;

    parse_file(argv[1],&ranges,&ids, &ranges_size, &ids_size);
    // printf("ranges_size %d \n", ranges_size);

    // // verifying range parsing
    // for (int i = 0; i < ranges_size; i ++){
    //     printf("start: %d \tend %d\n", ranges[i].start, ranges[i].end);
    // }
    //verfying ids parsing
    for (int i = 0; i < ids_size; i++){
        // printf("id%d:\t %d\n",i, ids[i]);
        for (int j = 0; j < ranges_size; j ++){
            Range r = ranges[j];
            if (is_in_range(ids[i],r)){
                fresh_ones ++;
                break;
            }
        }
    }

    printf("Total fresh count %d\n",fresh_ones);

    free(ranges);
    free(ids);
    return 0;
}