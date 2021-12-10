from pathlib import Path

input_list = Path("input.txt").read_text().split("\n")

chunks = {
    "(":")",
    "[":"]",
    "{":"}",
    "<":">"
}

closing_score = {
    ")":3,
    "]":57,
    "}":1197,
    ">":25137
}

def is_complete(line):
    stack = []
    illegal = None
    for parenthesis in line:
        if parenthesis in chunks.keys():
            stack.append(parenthesis)
        else: 
            matching_parenthesis = stack.pop()
            if chunks[matching_parenthesis] != parenthesis:
                illegal = parenthesis
                return False ,illegal
    return True, illegal

result_list = list(map(is_complete,input_list))
wrong_ones = list(filter(lambda x: x[0]== False,result_list))
get_line_score =  lambda illegals :sum(map(closing_score.get,illegals))
score = sum(map(lambda x: get_line_score(x[1]),wrong_ones))
print(score)