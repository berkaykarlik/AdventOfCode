

to_int64(x) = parse(Int64,x)
line_to_lwh(s::String)::Vector{Int64} = map(to_int64,split(s,'x'))

function get_areas(list::Vector{Int64})::Int
    l,w,h = list
    s1 = l * w
    s2 = w * h
    s3 = h * l
    return (2 * s1) + (2 * s2) + (2 * s3) + min(s1,s2,s3)
end

input = open("input.txt")

total_sum = mapreduce(get_areas,+,map(line_to_lwh,eachline(input)))

println("wrapping paper required: $(total_sum) feet")

# part2
seekstart(input)

get_volume(list::Vector{Int64})::Int = reduce(*,list)

function get_smallest_perim(list::Vector{Int64})::Int
    l,w,h = list
    p1 = 2 * (l + w)
    p2 = 2 * (l + h)
    p3 = 2 * (w + h)
    return min(p1,p2,p3)
end

get_total_ribbon(list::Vector{Int64})::Int = get_volume(list) + get_smallest_perim(list)

total_ribbon = mapreduce(get_total_ribbon,+,map(line_to_lwh,eachline(input)))

println("total ribbon required: $(total_ribbon) feet")
