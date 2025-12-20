#include <stdio.h>
#include <stdlib.h>
#define MAX_NUMBER_OF_POINTS 1000
#define TARGET 1000 //question asks for 1000 closest

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


int main(int argc, char** argv) {
    Point points[MAX_NUMBER_OF_POINTS];
    long long  points_size;
    parse_file(argv[1],&points, &points_size);
    long long i = 0;
    while (i < points_size){
        Point t = points[i++];
        printf("%lld,%lld,%lld\n",t.x,t.y,t.z);
    }

    //calculate 1000 closest and store them
    Pair pairs[TARGET];
    long long pairs_size = 0;

    Point curr_point;
    Point compared_point;
    long long dist;
    Pair tmp;
    for(long long i = 0; i < points_size; i++){
        curr_point = points[i];
        for(long long j = 0; j < i; j++){ //to avoid duplicate pairs i<j  should work??
            compared_point = points[j];
            dist = get_dist2(&curr_point, &compared_point);
            tmp = (Pair){i,j,dist};

            if (pairs_size == TARGET && dist >= pairs[TARGET-1].distance)
                continue;
            else{
                //insert to appropriate place and then slide the rest
                //find the element bigger then curr
                long long k = 0;
                for (; k < pairs_size; k++){
                    if( tmp.distance < pairs[k].distance)
                        break;
                }
                long long z = (pairs_size < TARGET) ? pairs_size : TARGET - 1;
                for (; z > k; z--)
                    pairs[z] = pairs[z - 1];
                pairs[k] = tmp;
                if (pairs_size < TARGET)
                    pairs_size++;
            }
        }
    }

    printf("ordered closest %d pairs of junkboxes\n", TARGET);
    for (long long d = 0; d < pairs_size; d++) {
    Pair p = pairs[d];
    Point a = points[p.ip1];
    Point b = points[p.ip2];

    printf("  [%lld] P%lld=(%lld,%lld,%lld)  P%lld=(%lld,%lld,%lld)  dist2=%lld\n",
           d,
           p.ip1, a.x, a.y, a.z,
           p.ip2, b.x, b.y, b.z,
           p.distance);
    }

    long long *parent = malloc(sizeof(long long)*points_size);
    long long *size = malloc(sizeof(long long)*points_size);

    //ever junctionbox is its own circuit at the beginning
    for(long long i = 0; i < points_size; i++){
        parent[i] = i;
        size[i] = 1;
    }

    for (long long i = 0; i < pairs_size; i++) {
        unite(parent, size, pairs[i].ip1, pairs[i].ip2);
    }

    long long *circuit_sizes = calloc(points_size, sizeof(long long));
    for (long long i = 0; i < points_size; i++) {
        long long root = find(parent,i);
        circuit_sizes[root]++;
    }

    long long max1 = 0, max2 = 0, max3 = 0;

    for (long long i = 0; i < points_size; i++) {
        if (parent[i] == i && circuit_sizes[i] > 0) {
            printf("circuit %lld has size %lld\n", i, circuit_sizes[i]);
            long long s = circuit_sizes[i];

            if (s > max1) {
                max3 = max2;
                max2 = max1;
                max1 = s;
            } else if (s > max2) {
                max3 = max2;
                max2 = s;
            } else if (s > max3) {
                max3 = s;
            }
        }
    }

    printf("max sizes are %lld, %lld, %lld their product is: %lld\n", max1, max2, max3,(max1*max2*max3));



    free(parent);
    free(size);
    free(circuit_sizes);
    return 0;
}
