module Day17

export get_inputs, get_solution1, get_solution2

using OffsetArrays


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
# Allocate an OffsetArray for the space the active cells will grow into
function make_space(active_matrix, dims=3, steps=6)
    init_dim_size = (axes(active_matrix)..., ntuple(d->0, dims-2)...)
    dim_size = reduce((dims, _) -> grow(dims), 1:steps+1, init=init_dim_size)

    # This will make an OffsetArray with indices that reach back into the negatives
    space = zeros(Bool, dim_size...)
    for ij in CartesianIndices(active_matrix)
        space[Tuple(ij)..., ntuple(d->0, dims-2)...] = active_matrix[ij]
    end
    return space
end

# Adjacent indices of (0,0,0,...)
adj_inds(dims) = (
    Tuple(ijk)
    for ijk in CartesianIndices(ntuple(i->-1:1, dims))
    if !all(Tuple(ijk) .== 0)
)
# Get the adjacent cells
get_adjacent(data, idx) = (data[(adj_idx .+ idx)...] for adj_idx in adj_inds(ndims(data)))
get_adjacent(data, idx::CartesianIndex) = get_adjacent(data, idx.I)

# Step the simulation by iterating through the bounding_box axes
function step!(space, temp, bounding_box)
    for idx in CartesianIndices(bounding_box)
        count_adj = count(get_adjacent(space, idx))
        temp[idx] = if space[idx] == true
            count_adj==2 || count_adj==3
        else
            count_adj==3
        end
    end
    space .= temp
end

# Grow a bounding box of array axes
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
    return count(space)
end

# Part 2
get_solution2(data) = get_solution1(data, 4)

end