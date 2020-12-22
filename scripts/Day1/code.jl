module Day1

export get_inputs, get_solution1, get_solution2


## Setup
using ..FileIO: read_simple


## Inputs (change these)
function get_inputs()
    test_input1 = test_input2 = [
        1721
        979
        366
        299
        675
        1456
    ]
    test_output1 = 514579
    test_output2 = 241861950

    data = read_simple(joinpath(@__DIR__, "input.txt")) #|> sort

    return (; test_input1, test_input2, test_output1, test_output2, data)
end


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

end