#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_NUMBER_OF_POINTS 1000
#define TARGET MAX_NUMBER_OF_POINTS*MAX_NUMBER_OF_POINTS / 2 //for part 2 target is all connections / 2 to avoid duplicates

typedef struct{
    long long x;
    long long y;
    long long z;
}Point;

typedef struct{
    long long ip1;
    long long ip2;
    long long distance;
}Pair;

long long get_dist2(const Point *p1, const Point *p2){
    long long dx = p1->x - p2->x;
    long long dy = p1->y - p2->y;
    long long dz = p1->z - p2->z;
    return dx*dx + dy*dy + dz*dz;
}

void parse_file(char *fname, Point (*points)[], long long *points_size){
    FILE *fptr = fopen(fname, "r");
    long long x,y,z;
    long long i = 0;
    while (fscanf(fptr, "%lld,%lld,%lld", &x,&y,&z) == 3) {
        (*points)[i++] = (Point){x,y,z}; // compound literal, creates tmp struct
    }
    *points_size = i;
    fclose(fptr);
}


long long find(long long *parent, long long x){
    if(parent[x] != x)
        parent[x] = find(parent,parent[x]);
    return parent[x];
}


void unite(long long *parent, long long *size, long long a, long long b){
    a = find(parent, a);
    b = find(parent, b);
    if (a == b) return;

    if (size[a] < size[b]) {
        long long tmp = a;
        a = b;
        b = tmp;
    }

    parent[b] = a;
    size[a] += size[b];
}

int cmp(const void *a, const void *b) {
    const Pair *pa = a;
    const Pair *pb = b;
    if (pa->distance < pb->distance) return -1;
    if (pa->distance > pb->distance) return 1;
    return 0;
}



int main(int argc, char** argv) {
    Point points[MAX_NUMBER_OF_POINTS];
    long long  points_size;
    parse_file(argv[1],&points, &points_size);

    Pair *pairs = malloc(sizeof(Pair) * (points_size * (points_size - 1) / 2));
    long long pairs_size = 0;

    for (long long i = 0; i < points_size; i++) {
        for (long long j = 0; j < i; j++) {
            pairs[pairs_size++] = (Pair){
                .ip1 = i,
                .ip2 = j,
                .distance = get_dist2(&points[i], &points[j])
            };
        }
    }
    qsort(pairs, pairs_size, sizeof(Pair), cmp);

    long long *parent = malloc(sizeof(long long)*points_size);
    long long *size = malloc(sizeof(long long)*points_size);
    long long *circuit_sizes = calloc(points_size, sizeof(long long));

    //ever junctionbox is its own circuit at the beginning
    for(long long i = 0; i < points_size; i++){
        parent[i] = i;
        size[i] = 1;
    }

    for (long long i = 0; i < pairs_size; i++) {
        long long a = pairs[i].ip1;
        long long b = pairs[i].ip2;

        long long ra = find(parent, a);
        long long rb = find(parent, b);

        if (ra != rb) {
            unite(parent, size, ra, rb);

            long long root = find(parent, ra);
            if (size[root] == points_size) {
                printf("last connection: (%lld,%lld,%lld) and (%lld,%lld,%lld)\n",
                    points[a].x, points[a].y, points[a].z,
                    points[b].x, points[b].y, points[b].z);

                printf("answer = %lld\n", points[a].x * points[b].x);
                break;
            }
        }
    }

    free(pairs);
    free(parent);
    free(size);
    free(circuit_sizes);
    return 0;
}
