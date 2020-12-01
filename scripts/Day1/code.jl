module Day1

## Setup
using Advent2020: read_simple


## Inputs (change these)
const test_input = [
    1721
    979
    366
    299
    675
    1456
]
const test_output1 = 514579
const test_output2 = 241861950

const data = read_simple(joinpath(@__DIR__, "input.txt"))


## Solution functions (change these)
# Part 1
function get_solution1(data)
    for i in eachindex(data)
        for j in i+1:length(data)
            these_data = (data[i], data[j])
            if sum(these_data)==2020
                return prod(these_data)
            end
        end
    end
end

# Part 2
function get_solution2(data)
    for i in eachindex(data)
        for j in i+1:length(data)
            for k in j+1:length(data)
                these_data = (data[i], data[j], data[k])
                if sum(these_data)==2020
                    return prod(these_data)
                end
            end
        end
    end
end


## Outputs (don't change these)
function run(; time=true)
    # Do not pass if tests don't check out
    @assert get_solution1(test_input) == test_output1
    @assert get_solution2(test_input) == test_output2

    # Print and time solution 1
    println("Solution 1: $(get_solution1(data))")
    time && @time get_solution1(data)

    # Print and time solution 2
    println("Solution 2: $(get_solution2(data))")
    time && @time get_solution2(data)

    return nothing
end

end