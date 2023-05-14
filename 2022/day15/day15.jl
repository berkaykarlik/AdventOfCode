using ProgressMeter

input = open("input.txt")
lines = readlines(input)

get_manhattan_distance(x1::Int,y1::Int,x2::Int,y2::Int) = abs(y2 - y1) + abs(x2 - x1)

function get_sensor_beacon_pairs(lines::Vector{String})::Dict
    sensor_beacon_dict = Dict()
    for line in lines
        pairs = match(r"^Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)$", line)
        pairs = map( a -> parse(Int, a),pairs)
        sensor_beacon_dict[(pairs[1],pairs[2])] = (pairs[3],pairs[4])
    end
    return sensor_beacon_dict
end

function check_row(sensor, beacon, row, impossible_points)
    d = get_manhattan_distance(sensor...,beacon...)
    hd = d - abs(row - sensor[2])
    point_on_row = (sensor[1],row)
    for i in -hd:hd
        push!(impossible_points, (i+point_on_row[1],point_on_row[2]))
    end
end

# impossible_points =  Set{Tuple{Int, Int}}()

pairs = get_sensor_beacon_pairs(lines)

# part 1

# for (sensor, beacon) in pairs
#     check_row(sensor, beacon, 2000000, impossible_points)
#     if in(beacon,impossible_points)
#         delete!(impossible_points,beacon)
#     end
# end

# println("impossible points on row: ",length(impossible_points))

# part2

lim = 4000000

function get_perimeter_points(c, r)
    r = r + 1 # for perimeter
    top = c[1], c[2] + r
    bottom = c[1], c[2] - r
    right= c[1] + r , c[2]
    left = c[1] - r , c[2]

    points_on_perimeter = Vector{Tuple}()

    curr = top
    push!(points_on_perimeter,curr)
    while curr != right
        curr = curr[1] + 1, curr[2] - 1
        push!(points_on_perimeter,curr)
    end
    while curr != bottom
        curr = curr[1] - 1, curr[2] - 1
        push!(points_on_perimeter,curr)
    end
    while curr != left
        curr = curr[1] - 1, curr[2] + 1
        push!(points_on_perimeter,curr)
    end
    while curr != top
        curr = curr[1] + 1, curr[2] + 1
        push!(points_on_perimeter,curr)
    end
    return points_on_perimeter
end

# println(impossible_points)
possible_points = vcat([get_perimeter_points(point[1],get_manhattan_distance(point[1]...,point[2]...)) for point in pairs]...)
is_point_in_lim(p) =  0 <= p[1] <= lim && 0 <= p[2] <= lim
possible_points = filter(is_point_in_lim,possible_points)


function find_point(possible_points,pairs)
    index_to_remove = Vector{Int}()
    @showprogress for (i,p) in enumerate(possible_points)
        for (sensor, beacon) in pairs
            if p == beacon
                push!(index_to_remove,i)
                break
            end
            r = get_manhattan_distance(sensor..., beacon...)
            d = get_manhattan_distance(sensor..., p...)
            if d <= r
                push!(index_to_remove,i)
                break
            end
        end
    end
    splice!(possible_points,index_to_remove)
    return possible_points
end
println("found $(length(possible_points)) possible_points)")
candidates = find_point(possible_points, pairs)
unique_candidates = unique(candidates)
only_possible_point= unique_candidates[1]
println("possible point: $(only_possible_point) freq: $(only_possible_point[1]*lim + only_possible_point[2])")

