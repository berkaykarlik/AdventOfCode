input = read(open("input.txt"),String)[1:end-1]
elves = map(x-> map(y -> parse(Int,y),split(x,"\n")),split(input,"\n\n"))
calorie_per_elf = sort!(map(sum,elves))
println("highest calorie: $(calorie_per_elf[end])\nhighest top 3 calorie $(sum(calorie_per_elf[end-2:end]))")