
input = open("input.txt")


function part1(s::IOStream)
    grid = falses(1000,1000)
    for instr in eachline(s)
        matches = match(r"(turn on|toggle|turn off) ([0-9]*),([0-9]*) through ([0-9]*),([0-9]*)",instr)
        command = matches[1]
        x1 = parse(UInt16,matches[2]) + 1
        y1 = parse(UInt16,matches[3]) + 1
        x2 = parse(UInt16,matches[4]) + 1
        y2 = parse(UInt16,matches[5]) + 1

        if command == "turn on"
            grid[x1:x2,y1:y2] .= 1
        elseif command == "toggle"
            grid[x1:x2,y1:y2] = .~grid[x1:x2,y1:y2]
        elseif command == "turn off"
            grid[x1:x2,y1:y2] .= 0
        end
    end

    return sum(grid)
end

lit = part1(input)
println("part1: $(lit) lights lit")


#part 2

seekstart(input)


function part2(s::IOStream)
    grid = zeros(UInt16,1000,1000)
    for instr in eachline(s)
        matches = match(r"(turn on|toggle|turn off) ([0-9]*),([0-9]*) through ([0-9]*),([0-9]*)",instr)
        turn_off(x) = max(x-1,0)
        command = matches[1]
        x1 = parse(UInt16,matches[2]) + 1
        y1 = parse(UInt16,matches[3]) + 1
        x2 = parse(UInt16,matches[4]) + 1
        y2 = parse(UInt16,matches[5]) + 1

        if command == "turn on"
            grid[x1:x2,y1:y2] .+=1
        elseif command == "turn off"
            grid[x1:x2,y1:y2] = turn_off.(grid[x1:x2,y1:y2])
        elseif command == "toggle"
            grid[x1:x2,y1:y2] .+=2
        end
    end
    return sum(grid)
end


total_brightness = part2(input)
println("part2: total  brightness $(total_brightness)")





