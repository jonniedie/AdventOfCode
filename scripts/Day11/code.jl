module Day11

export get_inputs, get_solution1, get_solution2

using OffsetArrays


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_inputs("test_input1.txt")
    test_output1 = 37
    test_output2 = 26
    data = read_inputs("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_inputs(f_name)
    lines = collect.(readlines(joinpath(@__DIR__, f_name)))
    mat = permutedims(reduce(hcat, lines), [2,1])
    return pad_matrix(mat)
end


## Solution functions
function pad_matrix(M, default='.')
    P = OffsetArray(similar(M, (size(M).+2)...), -1, -1)
    P .= default
    for i in CartesianIndices(M)
        P[i] = M[i]
    end
    return P
end

const adj_inds = [(i, j) for i in -1:1, j in -1:1 if (i!=0 || j!=0)]

get_adjacent(data, ci_tuple, sz) = (data[(ij .+ ci_tuple)...] for ij in adj_inds)

get_seen(data, ci_tuple, sz) = Base.Generator(adj_inds) do direction
    idx = ci_tuple
    elem = '.'
    while all(idx .∈ sz) && elem=='.'
        idx = idx .+ direction
        elem = data[idx...]
    end
    elem
end

function update_seats!(data, temp=copy(data), see_func=get_adjacent, occ_tolerance=4)
    temp .= data
    sz = ntuple(n -> 1:lastindex(data, n)-1, 2)
    for ci in CartesianIndices(sz)
        ci_tuple = Tuple(ci)
        seen = see_func(data, ci_tuple, sz)
        occupied = (x == '#' for x in seen)
        if data[ci] == 'L'
            if !any(occupied)
                temp[ci] = '#'
            end
        elseif data[ci] == '#'
            if count(occupied) >= occ_tolerance
                temp[ci] = 'L'
            end
        end
    end
    data .= temp
    return data
end

function get_solution(data, see_func=get_adjacent, occ_tolerance=4)
    data = copy(data)
    temp = similar(data)
    new_data = update_seats!(copy(data), temp, see_func, occ_tolerance)
    while new_data != data
        data .= new_data
        update_seats!(new_data, temp, see_func, occ_tolerance)
    end
    return count(x == '#' for x in new_data)
end


# Part 1
get_solution1(data) = get_solution(data)


# Part 2
get_solution2(data) = get_solution(data, get_seen, 5)

end