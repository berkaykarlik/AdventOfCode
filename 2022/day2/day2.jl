# OPPONENT , ME , MEANING
#    A     , X  , rock
#    B     , Y  , paper
#    C     , Z  , scissors

opp_to_me =  Dict("A" => "X", "B" => "Y", "C" => "Z")
strong_against = Dict( "X" => "Z" , "Y" => "X" , "Z" => "Y" )
weak_against = Dict( "Z" => "X" , "X" => "Y" , "Y" => "Z" )
shape_point =  Dict( "X" => 1, "Y" => 2, "Z" => 3 )
loss = 0
draw = 3
won = 6

input = readlines(open("input.txt"))

function play(s::String)
    opponent, me = split(s," ")
    opponent = opp_to_me[opponent]
    if opponent == me
        return draw + shape_point[me]
    elseif strong_against[me] == opponent
        return won  + shape_point[me]
    else
        return loss + shape_point[me]
    end
end

println("total score ", sum(map(play,input)))



function play_b(s::String)
    opponent, ending = split(s," ")
    opponent = opp_to_me[opponent]
    if ending == "X"
        return loss + shape_point[strong_against[opponent]]
    elseif ending == "Y"
        return draw + shape_point[opponent]
    else
        return won + shape_point[weak_against[opponent]]
    end
end

println("total score ", sum(map(play_b,input)))
