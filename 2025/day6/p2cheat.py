import re
import textwrap


with open("input.txt") as file:
    s = file.read()


lines= s.split("\n")

sign_line = lines[-2]

col_widths= [s.count(' ') for s in re.split("\+|\*",sign_line)]
col_widths[-1] += 1

col_widths = col_widths[1:]

number_of_cols = len(col_widths)
number_of_rows = len(lines) -2

signs = list(filter(lambda x: x != '' ,sign_line.split(' ')))

results = [1 if signs[i] == '*' else 0 for i in range(len(signs))]

lines = lines[:-2]
grid = [['' for i in range(number_of_cols)] for j in range(number_of_rows)]

for r,line in enumerate(lines):
    for c,width in enumerate(col_widths):
            grid[r][c] = line[0:width]
            line = line[width+1:]

# print(grid)

for c in range(number_of_cols):
    col_length = col_widths[c]
    for i in range(col_length):
        curr_num_s = ""
        for r in range(number_of_rows):
           curr_num_s += grid[r][c][col_length-i-1]
        curr_num = int(curr_num_s)
        results[c] = results[c]* curr_num if signs[c] == '*' else results[c]+ curr_num

print(sum(results))