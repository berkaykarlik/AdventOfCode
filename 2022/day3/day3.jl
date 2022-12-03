example =   ["vJrwpWtwJgWrhcsFMMfFFhFp",
            "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
            "PmmdzqPrVvPwwTWBwg",
            "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
            "ttgJtRGJQctTZtZT",
            "CrZsJsPPZsGzwwsLwLmpwMDw"
            ]

input = open("input.txt")
lines = readlines(input)

find_mutual(s::String) = Set(s[1:length(s)÷2]) ∩ Set(s[length(s)÷2+1:end])
get_priority(c::Char) = c in 'a':'z' ? Int(c) - 96 : Int(c) - 38

println(sum(map(get_priority,map(only,map(find_mutual,lines)))))
println(sum(map(group -> get_priority(only(intersect(map(Set,map(x -> split(x,""),group))...))[1]),Iterators.partition(lines,3))))

