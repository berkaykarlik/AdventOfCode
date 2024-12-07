pattern::Regex = r"mul\(([1-9]+[0-9]*),([1-9]+[0-9]*)\)"
disable_pattern::Regex = r"don't\(\).*?(?:do\(\)|$)"

mul_calc(i,r) = sum(map(x-> parse(Int, x[1]) * parse(Int, x[2]), eachmatch(r,i)))


input::String = read(open("input.txt"),String)[1:end-1]
rm_n = replace(input, r"\n" => "")

p1_ans = mul_calc(rm_n,pattern)
println("p1: ", p1_ans)

p2_disabled_input = replace(rm_n,disable_pattern => "")
p2_ans = mul_calc(p2_disabled_input,pattern)
println("p2: ", p2_ans)
