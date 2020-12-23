module Day23

export get_inputs, get_solution1, get_solution2

using CircularArrays: CircularArray
using ProgressMeter: @showprogress


## Input getting
function get_inputs()
    val = read_input(389125467)
    test_input1 = [(val, 10), (val, 100)]
    test_output1 = [92658374, 67384529]
    test_input2 = val
    test_output2 = nothing
    data = (read_input(joinpath(@__DIR__, "input.txt")), 100)
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

read_input(n::Number) = n |> digits |> reverse!
read_input(io) = parse(Int, only(readlines(io))) |> read_input


## Solution functions
function permutation_indices!(perm_vector, cups)
    for (i, cup) in enumerate(cups)
        perm_vector[cup] = i
    end
    return perm_vector
end

function insertall!(a, i, vals)
    for val in reverse!(vals)
        insert!(a, i, val)
    end
    return a
end

function play_game(cups, nturns)
    cups = CircularArray(copy(cups))
    ncups = length(cups)
    indices = collect(only(axes(cups)))
    last_cup = last(cups)
    pickup_cups = zeros(Int, 3)
    last_index = 0

    for turn in 1:nturns
        println("-- move $turn --")
        println("cups: $cups")
        # last_index = findfirst(==(last_cup), cups)

        current_cup = cups[last_index+1]

        pickup_indices = last_index+2:last_index+4
        pickup_index = first(pickup_indices)
        pickup_cups .= @view cups[pickup_indices]

        destination_cup = current_cup
        for i in 1:4
            d = mod1(destination_cup-i, ncups)
            if d ∉ pickup_cups
                destination_cup = d
                break
            end
        end

        println("pick up: $pickup_cups")
        println("destination: $destination_cup\n")

        destination_index = findfirst(==(destination_cup), cups)
        # destination_index = indices[destination_cup]
        if destination_index < pickup_index
            destination_index += ncups
        end

        replace_indices = pickup_index:destination_index-1
        @inbounds for index in replace_indices
            if index > ncups
                index = mod1(index, ncups)
            end
            cup = cups[index+3]
            cups.data[index] = cup

            if cup > ncups
                cup = mod1(cup, ncups)
            end
            indices[cup] = index
        end
        # cups[pickup_index:destination_index-1] .= @view cups[pickup_index+3:destination_index+2]
        
        putdown_indices = destination_index-2:destination_index
        cups[putdown_indices] .= pickup_cups
        indices[pickup_cups] .= putdown_indices

        last_cup = current_cup
        last_index = findfirst(==(last_cup), cups)
        # last_index = indices[mod1(last_cup, ncups)]
        # last_index += 1
        # if (last_index+1) in (pickup_index:destination_index+3)
        #     last_index -= 3
        # end
    end

    return cups
end

# function play_game(cups, turns, ncups=9)
#     cups = copy(cups)
#     perm_vector = similar(cups)
#     permutation_indices!(perm_vector, cups)
#     last_cup = last(cups)
    
#     for turn in 1:turns
#         last_i = findfirst(==(last_cup), cups)+1
#         # println("-- move $turn --")
#         # println("cups: $cups")
#         i = mod1.(last_i:last_i+3, ncups)
#         current_cup = cups[i[1]]
#         last_cup = current_cup
#         three_inds = i[2:4]
#         three_cups = cups[three_inds]
#         foreach(idx-> deleteat!(cups, idx), sort!(three_inds, rev=true))
#         destination_cup = current_cup
#         for i in 1:4
#             destination_cup = mod1(destination_cup-1, ncups)
#             destination_cup ∉ three_cups && break
#         end
#         # println("pick up: $three_cups")
#         # println("destination: $destination_cup\n")
#         permutation_indices!(perm_vector, cups)
#         i_dest = perm_vector[destination_cup]
#         # i_dest = findfirst(==(destination_cup), cups)
#         insertall!(cups, mod1(i_dest+1, ncups), three_cups)
#         # permutation_indices!(perm_vector, cups)
#     end

#     return cups
# end

function get_solution(cups, nturns)
    cups = play_game(cups, nturns)
    i_one = findfirst(==(1), cups)
    inds = mod1.(i_one+1:i_one+8, length(cups))
    return parse(Int, join(cups[inds]))
end

# Part 1
get_solution1(data::Vector{<:Tuple}) = get_solution1.(data)
get_solution1(data::Tuple) = get_solution1(data...)
get_solution1(cups, turns) = get_solution(cups, turns)

# Part 2
get_solution2(data::Tuple) = get_solution2(data[1])
function get_solution2(cups)
    cups = [cups; (length(cups)+1):1_000_000]
    cups = play_game(cups, 10_000_000)
    i = findfirst(==(1), cups)
    return prod(cups[i+1:i+2])
end

end