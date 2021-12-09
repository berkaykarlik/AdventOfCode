from pathlib import Path

input_file_path = Path("test.txt")
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


# for point in low_point:
#     print(point)

print(risk_level_sum)