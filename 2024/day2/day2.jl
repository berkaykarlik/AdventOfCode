input = read(open("input.txt"),String)[1:end-1]
reports = map(x-> map(y -> parse(Int,y),split(x," ")),split(input,"\n"))

get_diff(r::Vector{Int}) = r[1:end-1] - r[2:end]

all_minus(r::Vector{Int}) = all(i-> i < 0, r)
all_plus(r::Vector{Int}) = all(i-> i > 0, r)
in_range(r::Vector{Int}) = all(i ->  1 <=  abs(i) <= 3, r)
is_safe(r::Vector{Int}) = (all_minus(r) || all_plus(r)) && in_range(r)

safes = filter(is_safe, map(get_diff, reports))
println("PART 1 | number of safes: ",length(safes))


safes = []
for report in reports
    if is_safe(get_diff(report))
        push!(safes,report)
        continue
    end

    for i in 1:length(report)
        tmp_report = vcat(report[1:i-1],report[i+1:end])
        diff = get_diff(tmp_report)
        if is_safe(diff)
            push!(safes,tmp_report)
            break
        end
    end
end

println("PART 2 | number of safes: ",length(safes))
