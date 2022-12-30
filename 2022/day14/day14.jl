using OffsetArrays


function build_map()
    abyss = OffsetArray(fill('.',(201,401)), 0:200, 300:700)
    abyss_limit = 0
    order_pair(a,b) =(a<b) ? (a,b) : (b,a)

    for line in eachline(open("input.txt"))
        object = map.(x-> parse(Int,x),split.(split(line,"->"),','))
        for i in 1:(length(object)-1)
            x1,y1 = object[i]
            x2,y2 = object[i+1]
            y1,y2 = order_pair(y1,y2)
            x1,x2 = order_pair(x1,x2)
            abyss[y1:y2,x1:x2] .= '#'
            abyss_limit = max(y2,y1,abyss_limit)
        end
    end

    return abyss, abyss_limit
end

function send_sand!(map::OffsetArray)
    sand_p = (0,500)

    while true
        if  sand_p[1] >= 200
            return false
        end
        down = (sand_p[1]+1,sand_p[2])
        down_left = (sand_p[1]+1,sand_p[2]-1)
        down_right = (sand_p[1]+1,sand_p[2]+1)
        if map[down...] == '.'
            sand_p = down
        elseif map[down_left...] == '.'
            sand_p = down_left
        elseif map[down_right...] == '.'
            sand_p = down_right
        else
            map[sand_p...] = 'o'
            return true
        end
    end
end


function send_sand2!(map::OffsetArray)
    sand_p = (0,500)

    while true
        down = (sand_p[1]+1,sand_p[2])
        down_left = (sand_p[1]+1,sand_p[2]-1)
        down_right = (sand_p[1]+1,sand_p[2]+1)
        if map[down...] == '.'
            sand_p = down
        elseif map[down_left...] == '.'
            sand_p = down_left
        elseif map[down_right...] == '.'
            sand_p = down_right
        else
            map[sand_p...] = 'o'
            if sand_p == (0,500)
                return false
            else
                return true
            end
        end
    end
end

abyss, abyss_limit= build_map()
sand_count = 0
while send_sand!(abyss)
    global sand_count += 1
end

println("--------PART1------------")
println("sand_count ", sand_count)

println("--------PART2------------")
abyss_limit += 2
println("abyss_limit ", abyss_limit)

abyss[abyss_limit,:] .= '#'

while send_sand2!(abyss)
    global sand_count += 1
end

# display(abyss[0:11,489:508])


println("sand_count ", sand_count+1)
