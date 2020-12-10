module Day10

export get_inputs, get_solution1, get_solution2

## Input getting
function read_input(f_name)
    sorted = sort(parse.(Int, readlines(joinpath(@__DIR__, f_name))))
    return push!(pushfirst!(sorted, 0), sorted[end]+3)
end

function get_inputs()
    test_input1 = test_input2 = read_input.(("test_input11.txt", "test_input12.txt"))
    test_output1 = (5*7, 22*10)
    test_output2 = (8, 19208)
    data = read_input("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Part 1
get_solution1(data::Tuple) = get_solution1.(data)
function get_solution1(data)
    diffed = diff(data)
    return count(==(1), diffed) * count(==(3), diffed)
end

# Part 2
# Geez. This took me so long to figure out.
get_solution2(data::Tuple) = get_solution2.(data)
function get_solution2(data)
    diffed = diff(data)

    # Since diffs are either 1 or 3, we can count the length of each run of 1-diffs by splitting by the number 3
    ones_runs = filter(>(1), length.(split(join(string.(diffed)), '3', keepempty=false)))


    # Geez. This took me so long to figure out.
    return prod(binomial.(ones_runs, 2) .+ 1)
end

end