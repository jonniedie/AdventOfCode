module Day4

using ..Advent2022: split_string_lines, read_input
using Base: splat

export get_inputs, get_solution1, get_solution2

## Input getting
parse_sections(str) = (parse.(Int, split(str, '-'))...,)

parse_line(str) = Tuple(parse_sections.(split(str, ',')))

function get_inputs()
    test_input1 = """
        2-4,6-8
        2-3,4-5
        5-7,7-9
        2-8,3-7
        6-6,4-6
        2-6,4-8
        """ |> split_string_lines .|> parse_line
    test_output1 = 2
    test_input2 = test_input1
    test_output2 = 4
    data = read_input(4) |> split_string_lines .|> parse_line
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function fully_contains(sections)
    (a1, b1), (a2, b2) = extrema.(sections)
    return (a1<=a2 && b1>=b2) || (a2<=a1 && b2>=b1)
end

function overlaps(sections)
    (a1, b1), (a2, b2) = extrema.(sections)
    return (b1>=a2 && a1<=a2) || (b2>=a1 && a2<=a1)
end

# Part 1
get_solution1(data) = count(fully_contains, data)

# Part 2
get_solution2(data) = count(overlaps, data)

end
