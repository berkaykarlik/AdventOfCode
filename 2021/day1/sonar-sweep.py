from pathlib import Path

depths_str: str = Path("input.txt").read_text()

depths_list: list = depths_str.split("\n")
depths_list = list(map(lambda x: int(x), depths_list))


def sonar_sweep(list):
    increse_count = 0

    for i in range(1, len(list)):
        if list[i] > list[i-1]:
            increse_count += 1

    print(increse_count)


def sliding3_sonar_sweep():
    depths_list_m1 = depths_list[1:]
    depths_list_m2 = depths_list[2:]

    zipped = zip(depths_list, depths_list_m1, depths_list_m2)
    total = list(map(lambda x: x[0]+x[1]+x[2], zipped))
    sonar_sweep(total)


sonar_sweep(depths_list)  # part1
sliding3_sonar_sweep()  # part2
