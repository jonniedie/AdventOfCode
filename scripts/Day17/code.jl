module Day17

export get_inputs, get_solution1, get_solution2

using DataStructures: DefaultDict


## Input getting
function get_inputs()
    test_input1 = read_input(IOBuffer(
        """
        .#.
        ..#
        ###
        """
    ))
    test_output1 = 112
    test_input2 = nothing
    test_output2 = nothing
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    space = DefaultDict{NTuple{3, Int}, Bool}(false)
    char_matrix = permutedims(reduce(hcat, collect.(readlines(io))), (2,1))
    active_matrix = char_matrix .== '#'
    for ij in CartesianIndices(active_matrix)
        space[Tuple(ij)..., 0] = active_matrix[ij]
    end
    return space
end

## Solution functions
const adj_inds = [
    Tuple(ijk)
    for ijk in CartesianIndices(ntuple(i->-1:1, 3))
    if !all(Tuple(ijk) .== 0)
]

get_adjacent(data, idx_tuple) = (data[(i .+ idx_tuple)...] for i in adj_inds)

function step!(space, temp)
    for ijk in keys(space)
        adjacents = get_adjacent(space, ijk)
        count_adj = count(adjacents)
        if space[ijk] == true
            temp[ijk] = count_adj==2 || count_adj==3
        else
            temp[ijk] = count_adj==3
        end
    end
    foreach(ijk -> space[ijk] = temp[ijk], keys(space))
end

# Part 1
function get_solution1(data)
    space = copy(data)
    temp = copy(data)
    foreach(_ -> step!(space, temp), 1:6)
    return count(values(space))
end

# Part 2
function get_solution2(data)
    return nothing
end

end