#include <stdio.h>
#include <stdlib.h>
#include <math.h>

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

int main(int argc, char** argv) {
    if (argc != 2) return 1;

    size_t count = 0;
    Point* points = parse_points(argv[1], &count);
    if (!points) return 1;

    long long x_diff, y_diff, area, largest_area = 0;
    for (size_t i = 0; i < count; i++){
        Point point1 = points[i];
        for (size_t j = 0; j < i; j++){
            Point point2 = points[j];
            x_diff = llabs(point1.x - point2.x) + 1;
            y_diff = llabs(point1.y - point2.y)+ 1;
            area = x_diff*y_diff;
            // printf("p1 %d,%d and p2 %d,%d with area %d\n",
            //     point1.x, point1.y,
            //     point2.x, point2.y,
            //     area);
            largest_area = area > largest_area ? area : largest_area;
        }
    }
    printf("max area %lld\n",largest_area);

    free(points);
    return 0;
}
