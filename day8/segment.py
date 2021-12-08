from pathlib import Path
from collections import namedtuple
input_file_path = Path("test.txt")
input_str = "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
entries_str = input_str.split("\n")
Entry = namedtuple('Entry', 'signal output')
entries = list(map(lambda x:x.split(" | "),entries_str))
entries = list(map(lambda x: Entry(x[0].split(" "),x[1].split(" ")),entries))

len2digit = {
    2:1,
    4:4,
    3:7,
    7:8
}

#------ Part 1 -----
def count_unique():
    count_1_4_7_8 = 0
    for entry in entries:
        for output in entry.output:
            if len2digit.get(len(output)):
                count_1_4_7_8 +=1
    return count_1_4_7_8

print("count_1_4_7_8: ",count_unique()) 
# ---------

digit2signal = {
    0: "abcefg",
    1: "cf",
    2: "acdeg",
    3: "acdfg",
    4: "bcdf",
    5: "abdfg",
    6: "abdefg",
    7: "acf",
    8: "abcdefg",
    9: "abcdfg"    
}


for entry in entries:
    numbers_found = [None for i in range(10)]
    two_three_five = []
    zero_six_nine = []

    for signal in entry.signal:
        unique_num = len2digit.get(len(signal))
        if unique_num:
            numbers_found[unique_num] = set(signal)
        elif len(signal) == 5:
            two_three_five.append(set(signal))
        elif len(signal) == 6:
            zero_six_nine.append(set(signal))

    top = numbers_found[7] - numbers_found[1]
    left_top_right_bottom_edge = set.intersection(*zero_six_nine)
    three_horizontal_lines = set.intersection(*two_three_five)
    numbers_found[9] = numbers_found[4].union(three_horizontal_lines)
    left_bottom = numbers_found[8] - numbers_found[9]
    numbers_found[6] = set.union(left_top_right_bottom_edge,three_horizontal_lines,left_bottom)
    numbers_found[0] = list(filter(lambda x: x != numbers_found[6] and x != numbers_found[9],zero_six_nine))[0]
    numbers_found[5] = numbers_found[9].intersection(numbers_found[6])
    numbers_found[2] = (numbers_found[0]-numbers_found[5]).union(three_horizontal_lines)
    print(numbers_found[2])