module Day25

export get_inputs, get_solution1, get_solution2
export transform, find_loop_size


## Input getting
function get_inputs()
    test_input1 = [5764801, 17807724]
    test_output1 = 14897079
    test_input2 = nothing
    test_output2 = nothing
    data = parse.(Int, readlines(joinpath(@__DIR__, "input.txt")))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function transform(subject_number, loop_size)
    value = 1
    for i in 1:loop_size
        value = rem(value * subject_number, 20201227)
    end
    return value
end

function find_loop_size(subject_number, public_key)
    value = 1
    loop_size = 0
    while value != public_key
        value = rem(value * subject_number, 20201227)
        loop_size += 1
    end
    return loop_size
end


# Part 1
function get_solution1(data)
    card_public_key, door_public_key = data
    card_loop_size, door_loop_size = find_loop_size.(7, data)
    return transform(door_public_key, card_loop_size)
end

# Part 2
function get_solution2(data)
    return nothing
end

end