module Day22

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_input(joinpath(@__DIR__, "test_input1.txt"))
    test_output1 = 306
    test_output2 = 291
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    str = read(io, String)
    decks = split(str, r"(\n\n|\r\n\r\n)*Player [1-2]:", keepempty=false)
    return [parse.(Int, split(deck, r"(\n|\r\n)", keepempty=false)) for deck in decks]
end


## Solution functions
function combat(deck1, deck2, recursive=false)
    previous_rounds = Vector{Int}[]
    while true
        if recursive
            deck1 in previous_rounds && return (; deck=deck1, id=1)
            push!(previous_rounds, copy(deck1))
        end

        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)

        if recursive && card1<=length(deck1) && card2<=length(deck2)
            out = combat(deck1[1:card1], deck2[1:card2], recursive)
            out.id==1 ? push!(deck1, card1, card2) : push!(deck2, card2, card1)
        elseif card1 > card2
            push!(deck1, card1, card2)
        else
            push!(deck2, card2, card1)
        end

        isempty(deck1) && return (deck=deck2, id=2)
        isempty(deck2) && return (deck=deck1, id=1)
    end
end

get_score(winning_deck) = winning_deck' * reverse(only(axes(winning_deck)))

get_solution(decks, recursive=false) = get_score(combat(deepcopy(decks)..., recursive).deck)


# Part 1
get_solution1(data) = get_solution(data)

# Part 2
get_solution2(data) = get_solution(data, true)

end