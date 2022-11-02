using MD5

md5__secret_key = "bgvyzdsv"

function part1(input::String)
    smallest_positive_int = 0

    while true
        hsh = bytes2hex(md5(input*string(smallest_positive_int)))
        if hsh[1:6] == "000000"
            println(hsh)
            break
        end
        smallest_positive_int += 1
    end
    return smallest_positive_int
end

smallest_positive_int = part1(md5__secret_key)
println("smallest_positive_int: ",smallest_positive_int)
