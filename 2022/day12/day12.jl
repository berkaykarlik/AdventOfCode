using DataStructures
input = open("input.txt")
lines = readlines(input)

area = vcat(map(x-> map(y-> only(y),split(x,"")),lines))
area = permutedims(hcat(area...))
h, w = size(area)

starting_p = findfirst(x-> x == 'S', area)
end_p = findfirst(x-> x == 'E', area)
println("starting point: ",starting_p)
println("ending_point:",end_p)
area[starting_p] = 'a'
area[end_p] = 'z'


function djikstra(part2::Bool=false)
    dist = fill(Inf, h, w)
    prev =  fill(CartesianIndex(0,0), h, w)

    dist[starting_p] = 0
    println(starting_p)

    pq = PriorityQueue{CartesianIndex, Float64}()

    for i in CartesianIndices(area)
        pq[i] = dist[i]
    end

    while !isempty(pq)
        u = dequeue!(pq)

        up = CartesianIndex(u[1]-1,u[2])
        down = CartesianIndex(u[1]+1,u[2])
        right = CartesianIndex(u[1],u[2]+1)
        left = CartesianIndex(u[1],u[2]-1)

        for v in [up,down,right,left]
            if 1 <= v[1] <= h && 1 <= v[2] <= w
                diff =   part2 == false  ? area[v] - area[u] : area[u] - area[v]
                if diff < 2
                    alt = dist[u] + 1
                    if alt < dist[v]
                        dist[v] = alt
                        prev[v] = u
                        pq[v] = alt
                    end
                end
            end
        end
    end

    return dist,prev
end


dist,prev = djikstra()
println(dist[end_p])

all_destinations = findall(x -> x == 'a', area)

starting_p = end_p

dist,prev = djikstra(true)

path_len = dist[all_destinations]

println(findmin(path_len))