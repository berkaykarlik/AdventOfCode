input = open("input.txt")
lines = readlines(input)

example =   [
                "2-4,6-8",
                "2-3,4-5",
                "5-7,7-9",
                "2-8,3-7",
                "6-6,4-6",
                "2-6,4-8"
            ]


function string_to_range(s::String)
    st_start, st_end, nd_start, nd_end =  map(x -> parse(Int,x),match(r"^(\d+)-(\d+),(\d+)-(\d+)$",s))
    return st_start:st_end,nd_start:nd_end
end

pair_ranges = map(string_to_range,lines)


subset_pair_count = length(filter(x -> x[1] ⊆ x[2] || x[2] ⊆ x[1], pair_ranges))

println("number of pairs whehere one section is subset of another: ", subset_pair_count)

overlapping_pair_count =  length(filter(x -> !isempty(Set(x[1]) ∩ Set(x[2])) , pair_ranges))

println("number of pairs with overlapping sections: ", overlapping_pair_count)
