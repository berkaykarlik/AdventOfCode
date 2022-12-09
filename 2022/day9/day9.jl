input = open("input.txt")
lines = readlines(input)

mutable struct Point
    x::Int
    y::Int
end

snake = [Point(0,0),Point(0,0), Point(0,0),Point(0,0),Point(0,0),Point(0,0),Point(0,0),Point(0,0),Point(0,0),Point(0,0)]

Base.:-(a::Point,b::Point) = a.x - b.x , a.y - b.y
is_touching(dist::Tuple{Int,Int}) = all(abs.(dist) .< 2)

function move_point_once!(p::Point,dir::Char)
    if dir == 'U'
        p.y += 1
    elseif dir == 'D'
        p.y -= 1
    elseif dir == 'R'
        p.x += 1
    elseif dir == 'L'
        p.x -= 1
    end
end

function move_rope_n_times(moves::Vector{String})
    tail_visited = Set([(snake[end].x,snake[end].y)])

    for m in moves
        dir, step = m[1] , parse(Int,m[3:end])
        for _ in 1:step
            move_point_once!(snake[1],dir)
            for s in 1:(length(snake)-1)
                segment = snake[s]
                prev_segment = snake[s+1]
                dist = segment - prev_segment
                if !is_touching(dist)
                    if dist[1] == 2 && dist[2] == 0
                        prev_segment.x += 1
                    elseif dist[1] == -2 && dist[2] == 0
                        prev_segment.x -= 1
                    elseif dist[2] == 2 && dist[1] == 0
                        prev_segment.y += 1
                    elseif dist[2] == -2 && dist[1] == 0
                        prev_segment.y -= 1
                    elseif dist[1] > 0 && dist[2] > 0
                        prev_segment.x += 1
                        prev_segment.y += 1
                    elseif dist[1] < 0 && dist[2] > 0
                        prev_segment.x -= 1
                        prev_segment.y += 1
                    elseif dist[1] < 0 && dist[2]  < 0
                        prev_segment.x -= 1
                        prev_segment.y -= 1
                    elseif dist[1] > 0  && dist[2]  < 0
                        prev_segment.x += 1
                        prev_segment.y -= 1
                    end
                end
            end
            push!(tail_visited,(snake[end].x,snake[end].y))
        end
    end
    return length(tail_visited)
end

println(move_rope_n_times(lines))
