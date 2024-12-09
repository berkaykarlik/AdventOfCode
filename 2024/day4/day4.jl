using LinearAlgebra
function parse_file_to_matrix(filepath::String)::Matrix{Char}
    input::Vector{String} = readlines(filepath)
    input2d::Vector{Vector{Char}} =  map(x->map(only,x),map(x -> split(x,""), input))
    imat =  mapreduce(permutedims, vcat, input2d)
    return imat
end

function count_string_in_matrix(mat::Matrix{Char},pattern::Regex=r"XMAS|SAMX")::Int
    row_counts = sum(map(row->length(collect(eachmatch(pattern, String(row),overlap=true))),eachrow(mat)))
    println("row counts: ", row_counts)
    col_counts = sum(map(col->length(collect(eachmatch(pattern, String(col),overlap=true))),eachcol(mat)))
    println("col counts: ", col_counts)
    diag_range =  -(mat.size[1]-1):(mat.size[2]-1)
    diag_counts = sum(map(d->length(collect(eachmatch(pattern, String(d),overlap=true))),map(x->diag(mat,x),diag_range)))
    println("diag_counts: ", diag_counts)
    orthagonal_diag_counts = sum(map(d->length(collect(eachmatch(pattern, String(d),overlap=true))),map(x->diag(mat[end:-1:1,:],x),diag_range)))

    println("orthagonal_diag_counts: ", orthagonal_diag_counts)

    return row_counts + col_counts + diag_counts + orthagonal_diag_counts
end

function count_x_mas(mat::Matrix{Char})::Int
    check_word(m) = m == "MAS" || m == "SAM"
    count = 0
    for i in 2:mat.size[1]-1
        for j in 2:mat.size[2]-1
            diag_check = check_word(String([mat[i-1,j-1],mat[i,j],mat[i+1,j+1]]))
            anti_diag_check = check_word(String([mat[i+1,j-1],mat[i,j],mat[i-1,j+1]]))
            count +=  diag_check & anti_diag_check ? 1  : 0
        end
    end
    return count
end

imat = parse_file_to_matrix("input.txt")
println(imat.size)
println("part1: ", count_string_in_matrix(imat))
println("part2: ", count_x_mas(imat))
