module Day17

export get_inputs, get_solution1, get_solution2

using DataStructures: DefaultDict
using OffsetArrays: OffsetArray


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_input(IOBuffer(
        """
        .#.
        ..#
        ###
        """
    ))
    test_output1 = 112
    test_output2 = 848
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    char_matrix = permutedims(reduce(hcat, collect.(readlines(io))), (2,1))
    active_matrix = char_matrix .== '#'
    return active_matrix
end


## Solution functions
function make_space(active_matrix, dims=3)
    init_dim_size = (axes(active_matrix)..., ntuple(d->0, dims-2)...)
    dim_size = reduce((dims, _) -> grow(dims), 1:7, init=init_dim_size)
    space = OffsetArray(zeros(Bool, dim_size...), dim_size...)
    for ij in CartesianIndices(active_matrix)
        space[Tuple(ij)..., ntuple(d->0, dims-2)...] = active_matrix[ij]
    end
    return space
end

adj_inds(dims) = (
    Tuple(ijk)
    for ijk in CartesianIndices(ntuple(i->-1:1, dims))
    if !all(Tuple(ijk) .== 0)
)

get_adjacent(data, idx_tuple) = (data[(i .+ idx_tuple)...] for i in adj_inds(ndims(data)))

function step!(space, temp, bounding_box)
    for ijk in CartesianIndices(bounding_box)
        adjacents = get_adjacent(space, Tuple(ijk))
        count_adj = count(adjacents)
        if space[ijk] == true
            temp[ijk] = count_adj==2 || count_adj==3
        else
            temp[ijk] = count_adj==3
        end
    end
    space .= temp
end

grow(box) = map(range -> first(range)-1:last(range)+1, box)


# Part 1
function get_solution1(data, dims=3)
    space = make_space(data, dims)
    temp = copy(space)
    bounding_box = grow((axes(data)..., ntuple(d->0, dims-2)...))
    for _ in 1:6
        step!(space, temp, bounding_box)
        bounding_box = grow(bounding_box)
    end
    return count(values(space))
end

# Part 2
get_solution2(data) = get_solution1(data, 4)

end