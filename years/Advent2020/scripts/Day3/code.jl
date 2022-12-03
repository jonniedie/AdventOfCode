module Day3

export get_inputs, get_solution1, get_solution2

## Input getting
is_tree(char) = char=='#'
is_tree(str::String) = [is_tree(char) for char in str]

parse_input(f_name) = readlines(joinpath(@__DIR__, f_name)) .|> is_tree

function get_inputs()
    test_input1 = test_input2 = parse_input("test_input1.txt")

    test_output1 = 7
    test_output2 = 336

    data = parse_input("input.txt")

    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Part 1
function get_solution1(data; slope=1//3)
    pos_right = 1
    pos_down = 1
    tree_count = 0
    period = length(data[1])

    while pos_down ≤ length(data)
        tree_count += data[pos_down][pos_right]
        pos_right = mod1(pos_right+slope.den, period)
        pos_down += slope.num
    end

    return tree_count
end

# Part 2
get_solution2(data) = prod(get_solution1(data; slope) for slope in [1//1, 1//3, 1//5, 1//7, 2//1])

end