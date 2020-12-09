module Day9

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = (parse.(Int, readlines(joinpath(@__DIR__, "test_input1.txt"))), 5)
    test_output1 = 127
    test_output2 = 62
    data = (parse.(Int, readlines(joinpath(@__DIR__, "input.txt"))), 25)
    return (; test_input1, test_output1, test_input2, test_output2, data)
end


## Solution functions
function is_valid(number, preamble)
    for i in preamble, j in preamble
        i+j==number && return true
    end
    return false
end

# Part 1
function get_solution1((data, preamble_length))
    i = 1
    while true
        j = i + preamble_length
        preamble = @view data[i:j-1]
        val = data[j]
        !is_valid(val, preamble) && return val
        i += 1
    end
    return nothing
end

# Part 2
function get_solution2((data, preamble_length))
    sol1 = get_solution1((data, preamble_length))
    i = 1
    while true
        val = 0
        for j in i:length(data)
            val += data[j]
            if val==sol1
                this_range = @view data[i:j]
                return minimum(this_range) + maximum(this_range)
            elseif val > sol1
                break
            end
        end
        i += 1
    end
    return nothing
end

end