input = open("input.txt")
lines = readlines(input)


lines = map(x-> map(y -> parse(Int,y),split(x,"")),lines)
forest = hcat(lines...)
forest_width, forest_height = size(forest)

is_visible_from_left = Matrix{Int64}(undef,forest_width, forest_height)
is_visible_from_right = Matrix{Int64}(undef,forest_width, forest_height)
is_visible_from_top =  Matrix{Int64}(undef,forest_width, forest_height)
is_visible_from_bottom = Matrix{Int64}(undef,forest_width, forest_height)

function mark_visible(line::Vector{Int64})
    res = zeros(length(line))
    max = -1
    for (i,tree) in enumerate(line)
        if tree > max
            res[i] = true
            max = tree
        end
    end
    return res
end

for i in 1:forest_width
    line = forest[:,i]
    rev_line =reverse(line)
    is_visible_from_left[i,:] = mark_visible(line)
    is_visible_from_right[i,:] = reverse(mark_visible(rev_line))
end

for i in 1:forest_height
    line = forest[i,:]
    rev_line =reverse(line)
    is_visible_from_top[:,i] = mark_visible(line)
    is_visible_from_bottom[:,i] = reverse(mark_visible(rev_line))
end


is_visible = is_visible_from_left .|  is_visible_from_right .| is_visible_from_top .| is_visible_from_bottom
is_visible[1,:] .= 1
is_visible[end,:] .= 1
is_visible[:,1] .= 1
is_visible[:,end] .= 1

println("visible $(sum(is_visible)) trees")


function calculate_scene_point(v::Vector{Int})
    origin = v[1]
    scene_point = 0
    for i in v[2:end]
        scene_point += 1
        if i >= origin
            break
        end
    end
    return scene_point
end

function find_highest_scene_point()
    highest_scene_score = 0
    for i in 1:forest_width
        for j in 1:forest_height
            top_view = forest[i,j:-1:1]
            bottom_view = forest[i,j:end]
            left_view = forest[i:end,j]
            right_view = forest[i:-1:1,j]
            top_point = calculate_scene_point(top_view)
            bottom_point = calculate_scene_point(bottom_view)
            left_point = calculate_scene_point(left_view)
            right_point = calculate_scene_point(right_view)
            total_point = top_point * bottom_point * right_point * left_point
            if total_point > highest_scene_score
                highest_scene_score = total_point
            end
        end
    end
    return highest_scene_score
end

highest_scene_score = find_highest_scene_point()
println(highest_scene_score)