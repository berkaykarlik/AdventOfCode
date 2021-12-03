from pathlib import Path

code_str = Path("input.txt").read_text()
diagnostic_codes = code_str.split("\n")[:-1]
strin2intlist = lambda x : list(map(int,x))
diagnostic_codes  = list(map(strin2intlist,diagnostic_codes))

def find_gama_epsilon(diagnostic_codes):
    number_of_codes = len(diagnostic_codes)
    bit_sum = list(map(sum,zip(*diagnostic_codes)))
    one_or_zero = lambda x : 1 if x >= (number_of_codes/2) else 0 
    gama = list(map(one_or_zero,bit_sum))
    list_gamma = gama
    flip = lambda x : 1 -x 
    epsilon = list(map(flip,gama))
    list_epsilon = epsilon
    return gama, epsilon

gama,epsilon = find_gama_epsilon(diagnostic_codes)

list_gamma = gama
list_epsilon = epsilon

intlist2str = lambda x : "".join((list(map(str,x))))
intlist2int = lambda x : int(intlist2str(x),2)

gama = intlist2int(gama)
epsilon = intlist2int(epsilon)
power_consumption = gama * epsilon

print("gama",gama)
print("epsilon",epsilon)
print("power_consumption", power_consumption)

code_length = len(diagnostic_codes[0])

def filter_on_bits(candidate,comperand,is_gamma):
    for i in range(code_length):
        candidate = list(filter(lambda x : x[i] == comperand[i],candidate))
        gamma,epsilon =find_gama_epsilon(candidate)
        comperand = gamma if is_gamma else epsilon
        if len(candidate) == 1:
            return candidate

oxygen_candidates = filter_on_bits(diagnostic_codes,list_gamma,True)
co2_candidates = filter_on_bits(diagnostic_codes,list_epsilon,False)

o2_rate = intlist2int(oxygen_candidates[0])
co2_rate= intlist2int(co2_candidates[0])

life_support_rate = o2_rate * co2_rate

print("02",o2_rate)
print("co2",co2_rate)
print("life support",life_support_rate)
