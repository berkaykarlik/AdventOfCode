using DataStructures



input = open("input.txt")
lines = readlines(input)

example = [
"    [D]    ",
"[N] [C]    ",
"[Z] [M] [P]",
" 1   2   3 ",
"\n",
"move 1 from 2 to 1",
"move 3 from 1 to 3",
"move 2 from 2 to 1",
"move 1 from 1 to 2"
]

function get_number_line(line::String)
    create_line = split(line," ")
    filter!(x -> x != "", create_line)
    try
        create_line = map(x-> parse(Int,x),create_line)
        return create_line
    catch
        return nothing
    end
end

function process_lines(lines::Vector{String})
    stack_lines = Stack{String}()
    move_lines = Vector{String}()
    number_of_lines = -1

    for line in lines
        create_line = get_number_line(line)
        if number_of_lines == -1
            if isnothing(create_line)
                push!(stack_lines,line)
            else
                number_of_lines = create_line[end]
            end
        else
            push!(move_lines,line)
        end
    end

    return number_of_lines,stack_lines,move_lines[2:end]
end


function process_stack(number_of_lines::Int,stack_lines::Stack{String})
    crates = [ Stack{Char}() for i in 1:number_of_lines]
    for line in stack_lines
        for (i,c) in enumerate(line[2:4:end-1])
            if c != ' '
                push!(crates[i],c)
            end
        end
    end
    return crates
end

function process_moves(v::Vector{String})
    moves = Vector{Tuple}()
    for m in v
        matches = match(r"^move\s(\d+)\sfrom\s(\d+)\sto\s(\d+)$",m)
        tuple = Tuple(matches)
        tuple = map(x-> parse(Int,x),tuple)
        push!(moves,tuple)
    end
    return moves
end

function apply_move9000!(crates:: Vector{Stack{Char}}, move::Tuple)
    amount_to_move, source, target = move
    for i in 1:amount_to_move
        push!(crates[target],pop!(crates[source]))
    end
end

function apply_move9001!(crates:: Vector{Stack{Char}}, amount_to_move::Int, source::Int, target::Int)
    if amount_to_move == 0
        return
    end
    amount_to_move -=1
    c = pop!(crates[source])
    apply_move9001!(crates,amount_to_move, source, target)
    push!(crates[target],c)
end

number_of_lines,stack_lines,move_lines = process_lines(lines)
crates = process_stack(number_of_lines,stack_lines)
crates_nd = deepcopy(crates)
moves = process_moves(move_lines)

for m in moves
    apply_move9000!(crates,m)
end

println(String([first(c) for c in crates]))

for m in moves
    apply_move9001!(crates_nd,m...)
end

println(String([first(c) for c in crates_nd]))
