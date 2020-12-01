module DayN

## Setup
using Advent2020


## Inputs (change these)
const test_input = nothing
const test_output1 = nothing
const test_output2 = nothing

const data = nothing


## Solution functions (change these)
# Part 1
function get_solution1(data)
    return nothing
end

# Part 2
function get_solution2(data)
    return nothing
end


## Outputs (don't change these)
function run(time=true)
    # Do not pass if tests don't check out
    @assert get_solution1(test_input) == test_output1
    @assert get_solution2(test_input) == test_output2

    println("Solution 1: $(get_solution1(data))")
    time && @time get_solution1(data)

    println("Solution 2: $(get_solution2(data))")
    time && @time get_solution2(data)

    return nothing
end

end