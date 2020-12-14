module Day14

export get_inputs, get_solution1, get_solution2

using ..Advent2020.Utils
using SparseArrays

## Input getting
function get_inputs()
    test_input1 = read_input(IOBuffer(
        """
        mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
        mem[8] = 11
        mem[7] = 101
        mem[8] = 0
        """
    ))
    test_output1 = 165
    test_input2 = read_input(IOBuffer(
        """
        mask = 000000000000000000000000000000X1001X
        mem[42] = 100
        mask = 00000000000000000000000000000000X0XX
        mem[26] = 1
        """
    ))
    test_output2 = nothing
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    data = read(io, String)
    chunks = split(data, "mask = ", keepempty=false)
    return parse_chunk.(chunks)
end

function parse_chunk(chunk)
    lines = split(chunk, r"mask = |\n|\r\n", keepempty=false)
    mask = lines[1]
    mem = parse_mem.(lines[2:end])
    return (; mask, mem)
end

function parse_mem(mem)
    address, value = parse.(Int, split(mem, r"mem\[|\] = ", keepempty=false))
    return address => value
end


## Solution functions
initialize_memory(data) = spzeros(Int, typemax(Int))

mask_replace(value, mask, x='0') = parse(Int, replace(mask, 'X'=>x), base=2)

overwrite!(memory, pair, mask, fun=apply_mask1) = (memory[first(pair)] = fun(last(pair), mask))

overwrite_chunk!(memory, chunk, fun=apply_mask1) = foreach(pair -> overwrite!(memory, pair, chunk.mask, fun), chunk.mem)

# Part 1
function apply_mask1(value, mask)
    ones_mask = parse(Int, replace(mask, 'X'=>'0'), base=2)
    zeros_mask = parse(Int, replace(mask, 'X'=>'1'), base=2)
    return (last(value) | ones_mask) & zeros_mask
end

function get_solution1(data)
    memory = initialize_memory(data)
    foreach(chunk -> overwrite_chunk!(memory, chunk), data)
    return sum(memory)
end

# Part 2
function apply_mask2(value, mask)
    ones_mask = parse(Int, replace(mask, 'X'=>'0'), base=2)
    return last(value) | ones_mask
end

function get_solution2(data)
    memory = initialize_memory(data)
    for line in data
        
    end
    count("X", data.mask)
    return nothing
end

end