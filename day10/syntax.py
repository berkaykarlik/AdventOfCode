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
                return False ,illegal, None

    if not stack:
        return True, illegal, None
    
    completor = []
    for i in range(len(stack)):
        incomplete = stack.pop()
        completor.append(chunks[incomplete])
    return True, illegal, completor
    


result_list = list(map(is_complete,input_list))
wrong_ones = list(filter(lambda x: x[0]== False,result_list))
get_line_score =  lambda arr :sum(map(closing_score.get,arr))
score = sum(map(lambda x: get_line_score(x[1]),wrong_ones))
print(score)

completion_score = {
    ")":1,
    "]":2,
    "}":3,
    ">":4
}

missing_ones = list(filter(lambda x: x[0]== True,result_list))

def get_complation_score(completors):
    scores = map(completion_score.get,completors)
    score = 0
    for i,s in enumerate(scores):
        score = score * 5 + s
    return score

scores = list(map(lambda x: get_complation_score(x[2]),missing_ones))
print(sorted(scores)[len(scores)//2 ])
