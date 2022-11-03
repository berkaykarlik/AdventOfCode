

function count_vowels(s::String)
    is_vowel(x) = x ∈ "aeiou"
    vowels = filter(is_vowel,s)
    return length(vowels)
end

function has_adjacent_duplicate(s::String)
    for (i,c) in enumerate(s[1:end-1])
        if s[i+1] == c
            return true
        end
    end
    return false
end

function has_forbidden_pair(s::String)
    forbidden_pairs = [ "ab", "cd", "pq", "xy"]
    for (i,c) in enumerate(s[1:end-1])
        if c* s[i+1] ∈ forbidden_pairs
            return true
        end
    end
    return false
end

function is_nice_string(s::String)
    vowel_count = count_vowels(s)
    if vowel_count < 3
        return 0
    end

    if has_adjacent_duplicate(s) == false
        return 0
    end

    if has_forbidden_pair(s) == false
        return 1
    end

    return 0
end

input = open("input.txt")

println(" nice string count ", mapreduce(is_nice_string,+,eachline(input)))

seekstart(input)


function is_truly_nice_sring(s::String)
    set = Set{Char}()
    first_rule = match(r"([a-z]{2}).*(\1)",s)
    # println("first rule",first_rule)
    if isnothing(first_rule)
        return false
    end
    second_rule = match(r"([a-z])\w(\1)",s)
    # println("second rule",second_rule)
    if isnothing(second_rule)
        return false
    end
    return true
end

# println(is_truly_nice_sring("ieodomkazucvgmuy"))

println(" nice string count ", mapreduce(is_truly_nice_sring,+,eachline(input)))
