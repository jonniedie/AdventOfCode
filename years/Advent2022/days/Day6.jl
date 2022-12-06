module Day6

using ..Advent2022: split_string_lines, read_input

export get_inputs, get_solution1, get_solution2

## Input getting
function get_inputs()
    test_input1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"
    test_output1 = 7
    test_input2 = test_input1
    test_output2 = 19
    data = read_input(6)
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function get_solution(data, n)
    for i in eachindex(data)
        sub_data = @view data[i:i+n-1]
        if length(Set(sub_data)) == n
            return i+n-1
        end
    end
    return 0
end

# Part 1
get_solution1(data) = get_solution(data, 4)

# Part 2
get_solution2(data) = get_solution(data, 14)

end
