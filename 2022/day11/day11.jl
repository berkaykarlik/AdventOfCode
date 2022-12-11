input = open("input.txt")
lines = readlines(input)

remove_whitespace(s::String) = x.replace(" ", "")


mutable struct Monkey
    id::Int
    items::Vector{Int}
    op::Function
    second_operand::String
    test_divisible_by::Int
    if_true::Int
    if_false::Int
    items_inspected::Int
end

function parse_monkey(v::Vector{String})
    id = parse(Int,v[1][8:end-1])
    items = map(x-> parse(Int,x), split( v[2][19:end],", "))
    op = getfield(Main, Symbol( v[3][24]))
    second_operand = v[3][26:end]
    test_divisible_by = parse(Int,v[4][22:end])
    if_true = parse(Int,v[5][30:end])
    if_false = parse(Int,v[6][31:end])
    monkey = Monkey(id,
                    items,
                    op,
                    second_operand,
                    test_divisible_by,
                    if_true,
                    if_false,
                    0)
    return monkey
end


monkeys = Vector{Vector{String}}()

for i in 1:7:length(lines)
    push!(monkeys,lines[i:i+5])
end

monkeys = map(parse_monkey,monkeys)
rounds_to_observe = 10000

base = reduce(*,map(x-> x.test_divisible_by,monkeys ))

for round in 1:10000
    for monkey in monkeys
        #inspect
        for item in monkey.items
            if monkey.second_operand == "old"
                new = monkey.op(item,item)
            else
                new = monkey.op(item,parse(Int,monkey.second_operand))
            end
            new = new % base
            throw_to = new % monkey.test_divisible_by == 0 ? monkey.if_true : monkey.if_false
            push!(monkeys[throw_to+1].items,new)
            monkey.items_inspected +=1
        end
        deleteat!(monkey.items,eachindex(monkey.items))
    end
end

monkeys_by_activity = sort(monkeys; by= m -> m.items_inspected)
monkey_business = monkeys_by_activity[end].items_inspected * monkeys_by_activity[end-1].items_inspected
println("level of monkey business after $(rounds_to_observe) rounds of stuff-slinging simian shenanigans: ", monkey_business)
