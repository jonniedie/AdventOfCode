module Day9

export get_inputs, get_solution1, get_solution2


## Input getting
read_input(f_name) = parse.(Int, readlines(joinpath(@__DIR__, f_name)))

function get_inputs()
    test_input1 = test_input2 = (read_input("test_input1.txt"), 5)
    test_output1 = 127
    test_output2 = 62
    data = (read_input("input.txt"), 25)
    return (; test_input1, test_output1, test_input2, test_output2, data)
end


## Solution functions
function is_valid(number, preamble)
    for i in eachindex(preamble), j in i:length(preamble)
        if preamble[i] + preamble[j] == number return true end
    end
    return false
end

# Part 1
function get_solution1((data, preamble_length))
    for i in eachindex(data)
        j = i + preamble_length
        preamble = @view data[i:j-1]
        val = data[j]
        if !is_valid(val, preamble) return val end
    end
    return -1
end

# Part 2
function get_solution2((data, preamble_length))
    sol1 = get_solution1((data, preamble_length))
    for i in eachindex(data)
        val = 0
        for j in i:length(data)
            val += data[j]
            if val==sol1
                this_range = @view data[i:j]
                return sum(extrema(this_range))
            elseif val > sol1
                break
            end
        end
    end
    return -1
end

end