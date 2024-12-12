using OrderedCollections

function create_order_dict(order_pairs::Vector{Tuple{Int,Int}})::Dict{Int,Vector{Int}}
    order_dict= Dict{Int,Union{Int,Vector{Int}}}()
    for (k,v) in order_pairs
        if haskey(order_dict,k)
            push!(order_dict[k],v)
        else
            order_dict[k] = [v]
        end
    end
    return order_dict
end

function read_parse_input()::Tuple{Vector{Tuple{Int64, Int64}},Vector{Vector{Int}}}
    orders, prints = split(read("input.txt",String),"\n\n")

    order_lines = split((orders), "\n")
    splitted_lines = map(s-> split(s,"|"), order_lines)
    order_pairs = map(x-> (parse(Int, x[1]),parse(Int, x[2])), splitted_lines)

    prints = split(prints,"\n")[1:end-1]
    prints = map(p-> split(p,","), prints)
    prints =  map(p -> map(x-> parse(Int,x),p),prints)
    return order_pairs, prints
end


function get_mid_sum_of_correct_prints(prints::Vector{Vector{Int}},
                                       rules::Dict{Int,Vector{Int}}
                                      )::Tuple{Int, Vector{Vector{Int}}}
    sum = 0
    incorrect_prints = Vector{Vector{Int}}()
    for p in prints
        correct = true
        elements = Set(p)
        for e in p[end:-1:1]
            delete!(elements,e)
            if haskey(rules,e)
                if any(map(x -> x in elements, rules[e])) && correct==true
                    correct = false
                    push!(incorrect_prints,p)
                end
            end
        end
        if correct
            mid_index = Int(ceil(length(p) / 2))
            sum += p[mid_index]
        end
    end
    return sum, incorrect_prints
end

function fix_order_and_sum(wrong_prints::Vector{Vector{Int}},
                   order_dict::Dict{Int,Vector{Int}}
                   )

    function toposort(v,g,s,visited)
        visited[v] = true
        for i in g[v]
            if !visited[i]
                toposort(i,g,s,visited)
            end
        end
        push!(s,v)
    end

    function fix_single_order(p)
        g  = OrderedDict()
        visited = Dict()

        for e in p
            if !haskey(order_dict,e) && !haskey(g,e)
                g[e] = []
                visited[e] = false
            elseif !haskey(g,e)
                g[e] = filter(x -> x in p, order_dict[e])
                visited[e] = false
            end
        end

        s = []
        for (node, isvisited) in visited
            if !isvisited
                toposort(node, g, s, visited)
            end
        end
        return reverse(s)
    end

    sum = 0
    for p in wrong_prints
        corrected_print = fix_single_order(p)
        mid_index = Int(ceil(length(corrected_print) / 2))
        sum += corrected_print[mid_index]
    end
    return sum
end


order_pairs, prints = read_parse_input()
order_dict = create_order_dict(order_pairs)
sum, incorrect_prints = get_mid_sum_of_correct_prints(prints,order_dict)
println("part1: ", sum)
sum = fix_order_and_sum(incorrect_prints,order_dict)
println("part2: ", sum)
