module Day22

export get_inputs, get_solution1, get_solution2

# using DataStructures: Deque


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
get_score(winning_deck) = winning_deck' * reverse(only(axes(winning_deck)))

get_solution(game, decks) = get_score(game(deepcopy(decks)...).deck)


# Part 1
function combat(deck1, deck2)
    winning_deck = deck1

    while true
        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)

        card1 > card2 ? push!(deck1, card1, card2) : push!(deck2, card2, card1)

        isempty(deck1) && return (deck=deck2, id=2)
        isempty(deck2) && return (deck=deck1, id=1)
    end
end

get_solution1(data) = get_solution(combat, data)

# Part 2
function recursive_combat(deck1, deck2)
    winning_deck = deck1

    previous_rounds = Vector{Int}[]
    while true
        deck1 in previous_rounds && return (; deck=winning_deck, id=1)
        
        push!(previous_rounds, copy(deck1))

        card1 = popfirst!(deck1)
        card2 = popfirst!(deck2)

        if card1<=length(deck1) && card2<=length(deck2)
            out = recursive_combat(deck1[1:card1], deck2[1:card2])
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

get_solution2(data) = get_solution(recursive_combat, data)
end