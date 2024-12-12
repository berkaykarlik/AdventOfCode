area:: Matrix{Char} = mapreduce(permutedims,vcat, map(x -> map(only,split(x,"")),split(read("input.txt",String),"\n")[1:end-1]))
guard_pos::CartesianIndex = findfirst(x -> x == '^', area)


function right_turn(dir::CartesianIndex)::CartesianIndex
    rotations::Dict{CartesianIndex,CartesianIndex}= Dict(CartesianIndex(-1,0)=>CartesianIndex(0,1),
                                                         CartesianIndex(0,1)=>CartesianIndex(1,0),
                                                         CartesianIndex(1,0)=>CartesianIndex(0,-1),
                                                         CartesianIndex(0,-1)=>CartesianIndex(-1,0)
                                                        )
    return rotations[dir]
end

function sim_and_count_until_leave(start::CartesianIndex,area::Matrix{Char})::Int
    count = 0
    dir_vector = CartesianIndex(-1,0)
    guard_pos = start

    pos = guard_pos
    while  (0 < pos[1] <= area.size[1] ) && (0 < pos[2] <= area.size[2])
        if area[pos] == '#'
            guard_pos = pos - dir_vector
            dir_vector = right_turn(dir_vector)
            pos = guard_pos
        elseif area[pos] != 'X'
            area[pos] = 'X'
            pos += dir_vector
            count += 1
        else
            pos += dir_vector
        end
    end
    return count
end

move_count = sim_and_count_until_leave(guard_pos, area)
println("part1 answer: ", move_count)
