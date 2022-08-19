from pathlib import Path

depths_str = Path("input.txt").read_text()
depths_list: list = depths_str.split("\n")

horizontal_pos = 0
depth = 0

def process_single_command(command_str):
    global horizontal_pos,depth
    dir, val = command_str.split(" ")
    val = int(val)
    if dir == "forward":
        horizontal_pos += val
    elif dir == "down":
        depth += val
    elif dir == "up":
        depth -= val

list(map(process_single_command,depths_list))
print("part 1")
print("horizontal_pos",horizontal_pos)
print("depth",depth)
print("horizontal_pos * depth = ",horizontal_pos*depth)

#part 2

horizontal_pos = 0
depth = 0
aim = 0

def process_single_command_w_aim(command_str):
    global horizontal_pos,depth,aim
    dir, val = command_str.split(" ")
    val = int(val)
    if dir == "forward":
        horizontal_pos += val
        depth += aim * val
    elif dir == "down":
        aim += val
    elif dir == "up":
        aim -= val

list(map(process_single_command_w_aim,depths_list))
print("part 2")
print("horizontal_pos",horizontal_pos)
print("depth",depth)
print("horizontal_pos * depth = ",horizontal_pos*depth)