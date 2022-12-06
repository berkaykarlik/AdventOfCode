input = open("input.txt")
line = readline(input)

examples = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"


function process_line(signal::String,last_n::Int)

    last_four = map(only,split(signal[1:last_n],""))

    for (i,c) in enumerate(signal)
        push!(last_four,c)
        deleteat!(last_four,1)
        if length(last_four) == length(Set(last_four))
            return i
        end
    end
    return missing
end


println(process_line(line,4))
println(process_line(line,14))
