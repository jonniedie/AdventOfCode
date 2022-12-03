module Day6

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_inputs("test_input1.txt")
    test_output1 = 11
    test_output2 = 6
    data = read_inputs("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

read_inputs(f_name) = parse_declaration.(split(read(joinpath(@__DIR__, f_name), String), r"\n\n|\r\n\r\n"))

parse_declaration(str) = split(str, r"\n|\r\n", keepempty=false)


## Solution functions
# Part 1
get_solution1(data) = sum(length.(reduce.(union, data)))

# Part 2
get_solution2(data) = sum(length.(reduce.(intersect, data)))

end