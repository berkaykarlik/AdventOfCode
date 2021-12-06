from pathlib import Path

initial_state_str = Path("test.txt").read_text()
lantern_fishes = list(map(int,initial_state_str.split(",")))
NUMBER_OF_DAYS = 8

def single_iter(some_fish):
    for i in range(len(some_fish)):
        if some_fish[i] > 0:
            some_fish[i] -= 1 
        elif some_fish[i] == 0:
            some_fish[i] = 6
    return some_fish


def get_nth_day_lantern_count(n,fish_tank):

    days = [[] for i in range(NUMBER_OF_DAYS)]
    fish_to_add = [0 for i in range(NUMBER_OF_DAYS)]
    days[0] += fish_tank
    prev_length = None
    for i in range(1,n+1):
        yesterday = (i -1) % NUMBER_OF_DAYS
        today = i % NUMBER_OF_DAYS
        tomorrow = (i + 1) % NUMBER_OF_DAYS

        if today == 0 and len(days[today]) > 0:
            prev_length = len(days[today])

        curr_fish = days[today][:prev_length] if prev_length else days[today] 

        part_to_calculate = days[yesterday][prev_length:] if prev_length else days[yesterday]

        part_calculated = single_iter(part_to_calculate.copy())

        days[today] = curr_fish.copy() + part_calculated

        if fish_to_add[today]:
            days[today] += [8 for i in range(fish_to_add[today])]

        fish_to_add[tomorrow] += part_calculated.count(0)

    return len(days[today])

print(get_nth_day_lantern_count(80,lantern_fishes))