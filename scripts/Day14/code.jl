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
    test_output2 = 208
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

mask_replace(mask, x='0') = parse(Int, replace(mask, 'X'=>x), base=2)

apply_mask(value, mask) = (value | mask_replace(mask, '0')) & mask_replace(mask, '1')


# Part 1
function get_solution1(data)
    memory = initialize_memory(data)
    for chunk in data, pair in chunk.mem
        address, value = pair
        memory[address] = apply_mask(value, chunk.mask)
    end
    return sum(memory)
end

# Part 2
function get_solution2(data)
    memory = initialize_memory(data)
    for line in data
        mask = replace(line.mask, 'X'=>'C')
        mask = replace(mask, '0'=>'X')
        C_positions = first.(findall("C", mask)) .- 1
        max_size = length(first.(findall("C", reverse(mask))))
        mask = zero_based(collect(mask))
        for short_mask in 0:(2^max_size-1)
            short_mask = bitstring(short_mask)[(end-max_size+1):end]
            mask[C_positions] = zero_based(collect(short_mask))
            for pair in line.mem
                idx = apply_mask(first(pair), String(mask))
                memory[idx] = last(pair)
            end
        end
    end
    return sum(memory)
end

end