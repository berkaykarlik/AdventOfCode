input = open("input.txt")




@enum INSTR noop=0 addx=1

function parse_command_string(s::String)
    if s == "noop"
        return noop , nothing
    end
    matches = match(r"^addx\s(-?\d+)$",s)
    if !isnothing(matches)
        return addx, parse(Int,matches[1])
    end
end

function pass_cycle!(cycles::Int,cycles_completed::Int,x::Int,measure_at_cycle::Int,measures::Dict{Int,Int},crt::Vector{Int8})
    for _ in 1:cycles
        cycles_completed += 1
        if cycles_completed >= measure_at_cycle
            measures[measure_at_cycle] = measure_at_cycle * x
            measure_at_cycle += 40
        end
        if x-1 < cycles_completed % 40  < x+3
            crt[cycles_completed] = 1
        end
    end
    return cycles_completed, measure_at_cycle
end


function run_cpu(input::IOStream)
    x = 1
    cycles_completed = 0
    measure_at_cycle = 20
    measures = Dict{Int,Int}()
    crt = zeros(Int8,40*6)

    while true
        if eof(input)
            break
        end
        command_str = readline(input)
        command, arg = parse_command_string(command_str)
        if command == noop
            cycles_completed, measure_at_cycle = pass_cycle!(1,cycles_completed,x,measure_at_cycle,measures,crt)
        elseif command == addx
            cycles_completed, measure_at_cycle = pass_cycle!(2,cycles_completed,x,measure_at_cycle,measures,crt)
            x += arg
        end
    end
    return x,cycles_completed, measures,crt
end

x, cycles_completed, measures, crt = run_cpu(input)

println("x final val: ",x)
println("cpu ran for : ", cycles_completed," cycles")
println(measures)
println(sum(values(measures)))

crt = string(map(x -> x == 1 ? '#' : '.',crt)...)

for i in 1:6
    println(crt[1+(40*(i-1)):40+(40*(i-1))])
end
