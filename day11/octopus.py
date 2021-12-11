from pathlib import Path

octopus_grid = list(map(lambda x: list(map(int, list(x))),
                        Path("input.txt").read_text().split("\n")))

height = len(octopus_grid)
width = len(octopus_grid[0])
flash_count = 0
flashed = set()


def in_boundary(y, x): return (
    y >= 0 and y < height) and (x >= 0 and x < width)


def increase_all_1(octopus_grid):
    for y in range(height):
        for x in range(width):
            octopus_grid[y][x] += 1


def flash(y, x):
    global octopus_grid, flashed
    if (y, x) in flashed:
        return
    octopus_grid[y][x] = 0
    flashed.add((y, x))
    for j, i in [(y-1, x-1), (y-1, x), (y-1, x+1),
                 (y, x-1), (y, x+1),
                 (y+1, x-1), (y+1, x), (y+1, x+1)]:
        if in_boundary(j, i) and not ((j, i) in flashed):
            octopus_grid[j][i] += 1
            if octopus_grid[j][i] > 9:
                flash(j, i)
    return


def step():
    global flash_count, octopus_grid, flashed
    flashed = set()
    increase_all_1(octopus_grid)
    for y in range(height):
        for x in range(width):
            if octopus_grid[y][x] > 9:
                flash(y, x)
    flash_count += len(flashed)


for i in range(100):
    step()


print(f'number of flashes after 100 steps: {flash_count}')
