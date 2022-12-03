module Day1

export get_inputs, get_solution1, get_solution2


## Input getting
parse_elf(str) = parse.(Int, split(str, "\n"; keepempty=false))

function parse_inputs(input_str)
    return parse_elf.(split(input_str, "\n\n"; keepempty=false))
end

function get_inputs()
    test_input1 = """
    1000
    2000
    3000

    4000

    5000
    6000

    7000
    8000
    9000

    10000
    """ |> parse_inputs
    test_output1 = 24000
    test_input2 = test_input1
    test_output2 = 45000
    data = read(joinpath(@__DIR__, "..", "inputs", "Day1.txt"), String) |> parse_inputs
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Part 1
get_solution1(data) = maximum(sum.(data))

# Part 2
get_solution2(data) = sum(sort(sum.(data), rev=true)[1:3])

end
