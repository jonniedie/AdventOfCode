module Day10

export get_inputs, get_solution1, get_solution2

## Input getting
function read_input(f_name)
    sorted = sort(parse.(Int, readlines(joinpath(@__DIR__, f_name))))
    return join(string.(diff([0; sorted; sorted[end]+3])))
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
get_solution1(data) = count(==('1'), data) * count(==('3'), data)

# Part 2
# Geez. This took me so long to figure out.
# Since diffs are either 1 or 3, we can count the length of each run of 1-diffs by splitting by the number 3
get_solution2(data::Tuple) = get_solution2.(data)
get_solution2(data) = prod(binomial.(length.(split(data, '3', keepempty=false)), 2) .+ 1)

end