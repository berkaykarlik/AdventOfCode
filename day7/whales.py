from pathlib import Path
import math

initial_pos_str = Path("input.txt").read_text()
hor_pos = list(map(int,initial_pos_str.split(",")))

expected_val = sum(hor_pos) / len(hor_pos)

print("expected: ", expected_val)

variance = sum(list(map(lambda x: (x -expected_val)**2,hor_pos))) / len(hor_pos)
standart_dev = math.sqrt(variance)

print("variance: ", variance)
print("standard dev: ",standart_dev)

search_center = math.floor(expected_val)
distance_to_search = math.floor(standart_dev)
range_to_search = range(search_center-distance_to_search,search_center+distance_to_search)

fuel_spent = lambda dist: int((dist * (dist +1)) / 2)

total_distance = lambda point ,positions: sum(list(map(lambda x: fuel_spent(abs(x-point)),positions )))

smallest_dist = None
smallest_dist_point = None
print("range to search:",range_to_search)
for point in range_to_search:
    if not smallest_dist:
        smallest_dist_point =point
        smallest_dist = total_distance(point,hor_pos)
    else:
        curr_dist = total_distance(point,hor_pos)
        if curr_dist < smallest_dist :
            smallest_dist = curr_dist
            smallest_dist_point = point

print("point: ",smallest_dist_point)
print("smallest dist: ",smallest_dist)

