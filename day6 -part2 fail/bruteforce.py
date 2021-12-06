from numpy import ndarray
from pathlib import Path

initial_state_str = Path("test.txt").read_text()
lantern_fishes = list(map(int,initial_state_str.split(",")))


def single_iter(some_fish):
    for i in range(len(some_fish)):
        if some_fish[i] > 0:
            some_fish[i] -= 1 
        elif some_fish[i] == 0:
            some_fish[i] = 6
        else:
            print("I screwed up")
    return some_fish

def get_nth_day_lantern_count(n,fish_tank):
    curr_iter =fish_tank
    for i in range(1,n+1):
        fish_to_add= curr_iter.count(0)
        curr_iter = single_iter(curr_iter)

        if fish_to_add:
            curr_iter += [8 for i in range(fish_to_add)]

    return len(curr_iter)

print(get_nth_day_lantern_count(80,lantern_fishes))