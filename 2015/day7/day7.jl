
# each wire has an identifier

# can carry 16 bit signal

# signal provided by gate, wire or value

# single signal input -> wire -> multi signal output
function check_str2(a)
    return tryparse(Float64, a) !== nothing
end

function get_instr(s::String)
    #direct assignment
    matches = match(r"^(\w+)\s->\s(\w+)$",s)
    if isnothing(matches) == false
        return ("ASSIGN",matches[1],matches[2])
    end
    #not
    matches = match(r"^NOT\s(\w+)\s->\s(\w+)$",s)
    if isnothing(matches) == false
        return ("NOT",matches[1],matches[2])
    end
    # and | or | lshift | rshift
    matches = match(r"^(\w+)\s(AND|OR|LSHIFT|RSHIFT)\s(\w+)\s->\s(\w+)$",s)
    if isnothing(matches) == false
        return (matches[2],matches[1],matches[3],matches[4])
    end
    println("non matched ",s)
end

function apply_instr(v::Vector)
    wires = Dict{String,Integer}()

    while isempty(v) == false
        index_to_delete = []
        for (index,instr) in enumerate(v)
            if instr[1] == "ASSIGN"
                if check_str2(instr[2])
                    wires[instr[3]] = parse(Int,instr[2])
                    push!(index_to_delete,index)
                elseif haskey(wires,instr[2])
                    wires[instr[3]] = wires[instr[2]]
                    push!(index_to_delete,index)
                end
            elseif instr[1] == "NOT"
                if haskey(wires,instr[2])
                    wires[instr[3]] = ~wires[instr[2]]
                    push!(index_to_delete,index)
                end
            elseif instr[1] == "AND" || instr[1] == "OR"
                op1 = isa(instr[2], Number) ? parse(Int,instr[2]) : get(wires,instr[2],nothing)
                op2 = isa(instr[3], Number) ? parse(Int,instr[3]) : get(wires,instr[3],nothing)
                if isnothing(op1) == false && isnothing(op2) == false
                    wires[instr[4]] =  instr[1] == "AND" ? op1 & op2 : op1 | op2
                    push!(index_to_delete,index)
                end
            elseif instr[1] == "LSHIFT" ||instr[1] == "RSHIFT"
                if haskey(wires,instr[2])
                    wires[instr[4]] =  instr[1] == "LSHIFT" ? wires[instr[2]] << parse(Int,instr[3]) : wires[instr[2]] >> parse(Int,instr[3])
                    push!(index_to_delete,index)
                end
            end
        end
        println("index to del", index_to_delete)
        v = deleteat!(v,index_to_delete)
        index_to_delete = []
        println("remained ",length(v))
    end
    return wires
end


lines = open("input.txt")
list_of_instr = readlines(lines)
instr = map(get_instr,list_of_instr)
instr= apply_instr(instr)
println(instr["a"])
