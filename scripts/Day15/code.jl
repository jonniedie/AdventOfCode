module Day15

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_csv(IOBuffer("0,3,6"))
    test_output1 = 436
    test_output2 = 175594
    data = read_csv(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

read_csv(io) = parse.(Int, split(read(io, String), r",|\n|\r\n"; keepempty=false))


## Solution functions
# Part 1
function get_solution1(data, n=2020)
    called_nums = Dict(num => turn for (turn, num) in enumerate(data))
    last_num = last(data)
    num = 0

    for i in (length(data)+1):n
        num = haskey(called_nums, last_num) ? i-1 - called_nums[last_num] : 0
        called_nums[last_num] = i-1
        last_num = num
    end
    
    return num
end

# Part 2
get_solution2(data) = get_solution1(data, 30000000)

end