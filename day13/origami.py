from pathlib import Path
from operator import or_

input_str = Path("test.txt").read_text().split("\n\n")
dots = list(map(lambda x: tuple(map(int,x.split(","))),input_str[0].split("\n")))
axes = {"y":0,"x":1}
folds = list(map(lambda x:(axes[x[11]],int(x[13:])),input_str[1].split("\n")))

print(dots)
print(folds)

width = max(dots,key=lambda item:item[0])[0] +1
height = max(dots,key=lambda item:item[1])[1] +1
print(f"paper width {width} , height: {height}")

transparent_paper = [[0 for x in range(width)] for y in range(height)]

for dot in dots:
    transparent_paper[dot[1]][dot[0]] = 1


def fold_along(axis,line):
    global transparent_paper
    if axis == 0:
        for r in range(1,line):
            transparent_paper[line-r] = list(map(or_,transparent_paper[line-r],transparent_paper[line+r]))
        if line < height / 2:
            transparent_paper = transparent_paper[line+1:] + transparent_paper[:line]
        else:
            transparent_paper = transparent_paper[:line]
    if axis == 1:
        for i,row in enumerate(transparent_paper):
            for c in range(1,line):
                row[line-c] = or_(row[line+c],row[line-c])
            if line < width /2: 
                transparent_paper[i] = row[line+1:] + row[:line]
            else:
                transparent_paper[i] = row[:line]


for fold in folds:
    print(f"folding {fold}")
    fold_along(*fold)

# print(f"folding {folds[0]}")
# fold_along(*folds[0])

count = 0
for row in transparent_paper:
    print(row)
    count += sum(row)

print(count)