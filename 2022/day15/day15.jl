using OffsetArrays

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
    if in(beacon,impossible_points)
        delete!(impossible_points,beacon)
    end
end

impossible_points =  Set{Tuple{Int, Int}}()

pairs = get_sensor_beacon_pairs(lines)

for (sensor, beacon) in pairs
    check_row(sensor, beacon, 2000000, impossible_points)
end

println(length(impossible_points))