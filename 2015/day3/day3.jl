
struct Point
    x::Int16
    y::Int16
end

^(a::Point) = Point(a.x,a.y+1)
v(a::Point) = Point(a.x,a.y+-1)
>(a::Point) = Point(a.x+1,a.y)
<(a::Point) = Point(a.x-1,a.y)


input = readline(open("input.txt"))

function visit(directions::String)
    visited = Set{Point}()
    current_point = Point(0,0)
    push!(visited,current_point)

    for c in directions
        op = getfield(Main, Symbol(c))
        current_point = op(current_point)
        push!(visited,current_point)
    end
    return visited
end

delivered = visit(input)

println("$(length(delivered)) house received at least one present")

# part2

team_visit_len = length(visit(input[1:2:end]) ∪ visit(input[2:2:end]))
println("santa and robo santa gave $(team_visit_len) homes at least one present")