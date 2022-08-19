from pathlib import Path

line_input = Path("input.txt").read_text()
line_strs = line_input.split("\n")


class Point:
    def __init__(self, x, y) -> None:
        self.x = x
        self.y = y

    def __repr__(self) -> str:
        return f"Point: {self.x},{self.y}"


class Line:
    def __init__(self, p1, p2) -> None:
        self.p1 = p1
        self.p2 = p2

    def __repr__(self) -> str:
        return f"Line: {self.p1.x},{self.p1.y} -> {self.p2.x},{self.p2.y}"

    def is_horizontal(self):
        return self.p1.y == self.p2.y

    def is_vertical(self):
        return self.p1.x == self.p2.x

    def get_all_points_on_line(self):
        points = []
        if self.is_horizontal():
            max_x = max(self.p1.x, self.p2.x)
            min_x = min(self.p1.x, self.p2.x)
            for x in range(min_x, max_x + 1):
                points.append(Point(x, self.p1.y))
        elif self.is_vertical():
            max_y = max(self.p1.y, self.p2.y)
            min_y = min(self.p1.y, self.p2.y)
            for y in range(min_y, max_y + 1):
                points.append(Point(self.p1.x, y))
        else:
            x_range = range(self.p1.x, self.p2.x+1) if self.p1.x < self.p2.x else range(
                self.p1.x, self.p2.x-1, -1)
            y_range = range(self.p1.y, self.p2.y+1) if self.p1.y < self.p2.y else range(
                self.p1.y, self.p2.y-1, -1)
            for x, y in zip(x_range, y_range):
                points.append(Point(x, y))
        return points


def line_str_2_line_obj(line_str):
    p1_str, p2_str = line_str.split(' -> ')
    p1_x, p1_y = list(map(int, p1_str.split(',')))
    p2_x, p2_y = list(map(int, p2_str.split(',')))
    p1 = Point(p1_x, p1_y)
    p2 = Point(p2_x, p2_y)
    return Line(p1, p2)


area = [[0 for i in range(1000)] for j in range(1000)]


lines = list(map(line_str_2_line_obj, line_strs))

# horizontal_and_vertical_lines = list(
#     filter(lambda x: x.is_vertical() or x.is_horizontal(), lines))

for line in lines:
    for point in line.get_all_points_on_line():
        area[point.y][point.x] += 1

count = 0

for y in range(len(area)):
    for x in range(len(area[0])):
        if area[y][x] >= 2:
            count += 1

print(count)
