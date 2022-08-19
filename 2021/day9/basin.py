from pathlib import Path
from time import time
input_file_path = Path("input.txt")
input_str = input_file_path.read_text()
input_str = input_str.split("\n")

line_to_row = lambda x: list(map(int,x))
ground_map = list(map(line_to_row,input_str))

col_range = range(len(ground_map))
row_range = range(len(ground_map[0]))

low_point = []
risk_level_sum = 0
for j in col_range:
    for i in row_range:
        height = ground_map[j][i]

        if height == 9:
            continue
        elif height == 0:
            low_point.append((i,j))
            risk_level_sum += height +1
            continue

        is_low = True
        for x,y in [(i-1,j),(i+1,j),(i,j-1),(i,j+1)]:
            if y in col_range and x in row_range:
                if height >= ground_map[y][x]:
                    is_low = False
        
        if is_low:
            low_point.append((i,j))
            risk_level_sum += height +1

print("PART1")
# print("points")
# for point in low_point:
#     print(point)

print("total risk level: ",risk_level_sum)
print("PART2")

def discover_basin(x,y):
    """recursive function to discover basin starting from lowest point of it"""
    height = ground_map[y][x]
    basin = []
    basin.append((x,y))
    ground_map[y][x] = None #comment out this and below line to test non-dynamic approach 
    for x,y in [(x-1,y),(x+1,y),(x,y-1),(x,y+1)]:
            if y in col_range and x in row_range:
                neighbour_height = ground_map[y][x]
                if not neighbour_height  or neighbour_height == 9: #remove not neighbour_height  and above line to test non-dynamic approach 
                    continue
                if neighbour_height > height:
                    basin += discover_basin(x,y)
    return basin


sizes = []
t1 = time()
for point in low_point:
    size = len(set(discover_basin(point[0],point[1])))
    sizes.append(size)
t2 = time()

x1,x2,x3 =sorted(sizes)[-3:]

print(x1*x2*x3)
print("time spent:",t2-t1) #to compare dynamic and non dynamic