

p1_test_cases = Dict(
                    "(())" => 0,
                    "()()" => 0 ,
                    "(((" => 3,
                    "(()(()(" => 3,
                    "))(((((" => 3,
                    "())" => -1,
                    "))(" => -1,
                    ")))" => -3,
                    ")())())" => -3
                    )


input_file = open("input.txt")
input = readline(input_file)
close(input_file)


function test(func::Function,test_cases::Dict)
    for case in keys(test_cases)
        res = func(case)
        gt = test_cases[case]
        if res == gt
            println("$(case) => $(res) passed")
        else
            println("$(case) => $(res) failed, expected $(gt)")
        end
    end
end

function traverse_floors(instr::String)::Int64
    floor = 0
    for (i,c) in enumerate(instr)
        if c == '('
            floor += 1
        elseif c == ')'
            floor -= 1
        end
        if floor == -1
            println("entered basement at ", i)
        end
    end
    return floor
end


# test(traverse_floors,p1_test_cases)

println("p1 answer",traverse_floors(input))