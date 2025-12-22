#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

typedef struct {
    long long x;
    long long y;
} Point;

Point* parse_points(const char* filename, size_t* out_size) {
    FILE* f = fopen(filename, "r");
    if (!f) return NULL;

    size_t cap = 8, size = 0;
    Point* points = malloc(cap * sizeof(Point));

    while (fscanf(f, "%lld,%lld", &points[size].x, &points[size].y) == 2) {
        size++;
        if (size == cap) {
            cap *= 2;
            points = realloc(points, cap * sizeof(Point));
        }
    }

    fclose(f);
    *out_size = size;
    return points;
}

long long rect_blocked(long long*prefix,long long max_x,long long x1, long long y1, long long x2, long long y2){
    if (x1 > x2) { long long t = x1; x1 = x2; x2 = t; }
    if (y1 > y2) { long long t = y1; y1 = y2; y2 = t; }
    long long curr= prefix[y2*max_x+x2];
    long long up = (y1 > 0) ? prefix[(y1-1)*max_x +x2] : 0;
    long long left = (x1 > 0) ? prefix[y2*max_x +(x1-1)] : 0;
    long long diag = (y1 >0 && x1>0 ) ? prefix[(y1-1)*max_x + (x1-1)] : 0;
    return curr - up - left + diag;
}

int main(int argc, char** argv) {
    if (argc != 2) return 1;

    size_t count = 0;
    Point* points = parse_points(argv[1], &count);
    if (!points) return 1;

    long long x_diff, y_diff, area, largest_area = 0;
    long long max_x = 0, max_y= 0;
    for (size_t i = 0; i < count; i++){
        Point point1 = points[i];
        for (size_t j = 0; j < i; j++){
            Point point2 = points[j];
            x_diff = llabs(point1.x - point2.x) + 1;
            y_diff = llabs(point1.y - point2.y)+ 1;
            area = x_diff*y_diff;

            max_x = point1.x > max_x ? point1.x : max_x;
            max_x = point2.x > max_x ? point2.x : max_x;

            max_y = point1.y > max_y ? point1.y : max_y;
            max_y = point2.y > max_y ? point2.y : max_y;
            largest_area = area > largest_area ? area : largest_area;
        }
    }
    printf("max area %lld\n",largest_area);
    printf("max_x %lld\t max_y%lld\n", max_x, max_y);

    max_x ++;
    max_y ++;

    char *grid = malloc(sizeof(char)* max_x * max_y);
    memset(grid,'.',sizeof(char)* max_x * max_y);

    Point prev = points[count-1];
    Point curr;

    char *vert = calloc(max_x * max_y, 1);


    // add connecting green tiles between reds
    for(long long k = 0; k < count; k ++){
        curr = points[k];
        grid[curr.y*max_x +curr.x] = '#';
        if (prev.x == curr.x) {
            int inc = prev.y < curr.y ? 1 : -1;
            for (int y = prev.y; y != curr.y; y += inc) {
                vert[y * max_x + prev.x] = 1;
            }
        }
        else {
            if (prev.y == curr.y){
                int increment = prev.x < curr.x ? 1 : -1;
                for (int i= prev.x +increment; i != curr.x; i+= increment){
                    grid[prev.y*max_x + i] = 'X';
                }
            }
        }
        prev = curr;
    }

    // fill inside with green too
    for (long long y = 0; y < max_y; y++) {
        int inside = 0;
        for (long long x = 0; x < max_x; x++) {
            if (vert[y * max_x + x]) {
                inside ^= 1;  // toggle on vertical edge
            }
            if (inside && grid[y * max_x + x] == '.') {
                grid[y * max_x + x] = 'X';
            }
        }
    }

    //prefix sum
    long long *prefix_sum = malloc(sizeof(long long)* max_x * max_y);
    memset(prefix_sum, 0, sizeof(long long) * max_x * max_y);


    for(long long i = 0; i < max_y; i ++){
        for(long long j = 0; j < max_x; j++){
            long long blocked = grid[i*max_x+ j] == '.' ? 1 : 0;
            long long up =  i > 0 ? prefix_sum[(i-1)*max_x+ j] : 0;
            long long left =  j > 0 ? prefix_sum[i*max_x+ (j-1)] : 0;
            long long diag = (i >0 && j > 0) ? prefix_sum[(i-1)*max_x + (j-1)] : 0;
            prefix_sum[i*max_x+j] = blocked + up + left -diag;
        }
    }

    //PART2 AREA
   largest_area = 0;
    for (size_t i = 0; i < count; i++){
        Point point1 = points[i];
        for (size_t j = 0; j < i; j++){
            Point point2 = points[j];
            if(!rect_blocked(prefix_sum, max_x, point1.x,point1.y,point2.x,point2.y)){
                x_diff = llabs(point1.x - point2.x) + 1;
                y_diff = llabs(point1.y - point2.y)+ 1;
                area = x_diff*y_diff;
                largest_area = area > largest_area ? area : largest_area;
            }
        }
    }
    printf("max area %lld\n",largest_area);

    free(points);
    free(prefix_sum);
    free(grid);
    return 0;
}
