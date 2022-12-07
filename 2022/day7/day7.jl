input = open("input.txt")
lines = readlines(input)

TOTAL_DISK_AVAILABLE = 70000000
NEEDED_SPACE = 30000000

mutable struct Node
    name::String
    value::Int
    parent:: Union{Node,Nothing}
    children::Vector
    Node(name::String,value::Int) = new(name,value,nothing,Vector{Node}())
    Node(name::String,value::Int,parent::Node) = new(name,value,parent,Vector{Node}())
end

head_node = Node("/",0)
current_node = nothing

function find_child(n::Node,name::SubString)
    return only(filter(x -> x.name == name, n.children))
end

function visualize_tree(node::Node,i=1)
    println(" "^((i-1)*5),"|","-"^(4),node.name,"(size=",node.value,")")
    for child in node.children
        visualize_tree(child, i+1)
    end
end

function parse_command(s::String)
    global current_node
    cmd = match(r"^(cd|ls)(?:\s(\S*))?$",s)
    if cmd[1] == "cd"
        if cmd[2] == "/"
            current_node = head_node
        elseif cmd[2] == ".."
            current_node = current_node.parent
        else
            current_node = find_child(current_node,cmd[2])
        end
        return "cd"
    else
        return "ls"
    end
end

function parse_ls_entry(s::String)
    dir_entry = match(r"^(dir) (\S+)$",s)
    if !isnothing(dir_entry)
        return dir_entry
    end
    file_entry = match(r"^(\d+)\s(\S+)$",s)
    if !isnothing(file_entry)
        return file_entry
    end
end

function add2tree(name::String,value::Int)
    new_node = Node(name,value,current_node)
    push!(current_node.children,new_node)
end

function parse_terminal(lines::Vector{String})
    ls_mode = false
    for line in lines
        cmd = ""
        if line[1] == '$'
            ls_mode = false
            cmd = parse_command(line[3:end])
        end
        if ls_mode
            entry = parse_ls_entry(line)
            if entry[1] == "dir"
                add2tree(String(entry[2]),0)
            else
                add2tree(String(entry[2]),parse(Int,entry[1]))
            end
        end
        if cmd == "ls"
            ls_mode = true
        end
    end
end

function traverse_n_tree(n::Node)
    if n.value != 0
        return n.value, 0, []
    end

    total_sum = 0
    dirs = [n]
    for child in n.children
        value, res_sum, res_dirs= traverse_n_tree(child)
        total_sum += res_sum
        n.value += value
        append!(dirs,res_dirs)
    end
    if n.value < 100000
        total_sum += n.value
    end
    return n.value , total_sum, dirs
end

parse_terminal(lines)
total_space_in_use , dir_sum, dirs = traverse_n_tree(head_node)
# visualize_tree(head_node) #uncomment to see primitive visualization
println("size sum of dir with sizes less than 100000 is: ", dir_sum)
AVAILABLE_SPACE = TOTAL_DISK_AVAILABLE - total_space_in_use
AT_LEAST_DELETE_THIS_MUCH = NEEDED_SPACE - AVAILABLE_SPACE
dirs_with_required_space = filter(x -> x.value >= AT_LEAST_DELETE_THIS_MUCH ,dirs)
dirs_with_required_space = sort(dirs_with_required_space,by= x -> x.value)
dir_to_delete = dirs_with_required_space[1]
println("dir to delete $(dir_to_delete.name) its size: $(dir_to_delete.value)")
