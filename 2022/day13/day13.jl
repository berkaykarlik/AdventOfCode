using Base.Iterators
using JSON

packets = JSON.parse.(filter(x -> length(x) > 0, readlines("input.txt")))

function compare_pairs(p1::Vector,p2::Vector)

    for (l,r) in zip(p1,p2)
        if (typeof(l) == Int) && (typeof(r) == Int)
            if l < r
                return 1
            elseif l > r
                return -1
            end
        elseif typeof(l) == Int
            l = [l]
        elseif typeof(r) == Int
            r = [r]
        end

        if typeof(l) <: Vector && typeof(r) <: Vector
            res = compare_pairs(l,r)
            if res == 0
                continue
            else
                return res
            end
        end
    end

    if length(p1) < length(p2)
        return 1
    elseif length(p1) > length(p2)
        return -1
    else
        return 0
    end

end

is_lesss(p1::Vector,p2::Vector) =  compare_pairs(p1,p2) == 1

function process(packets)
    ind_sum = 0
    for (i,pair) in enumerate(partition(packets,2))
        if 1 == compare_pairs(pair...)
            ind_sum += i
        end
    end
    return ind_sum
end

println(process(packets))

push!(packets,[[2]])
push!(packets,[[6]])

packets = sort!(packets,lt=is_lesss)

two_pkg = findfirst(x -> x == [[2]],packets)
six_pkg = findfirst(x -> x == [[6]],packets)

println(two_pkg," ",six_pkg)
println(two_pkg*six_pkg)
