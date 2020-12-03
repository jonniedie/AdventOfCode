module Day3

## Setup
using Advent2020

## Inputs (change these)
to_bool(str) = [char=='#' for char in str]

const test_input1 = test_input2 = readlines(joinpath(@__DIR__, "test_input1.txt")) .|> to_bool

const test_output1 = 7
const test_output2 = 336

const data = readlines(joinpath(@__DIR__, "input.txt")) .|> to_bool


## Solution functions (change these)
# Part 1
function get_solution1(data; slope=1//3)
    idx_lr = 1
    idx_ud = 1
    tree_count = 0
    period = length(data[1])
    while idx_ud ≤ length(data)
        line = data[idx_ud]
        tree_count += line[idx_lr]
        idx_lr = mod1(idx_lr+slope.den, period)
        idx_ud += slope.num
    end
    return tree_count
end

# Part 2
function get_solution2(data)
    slopes = [1//1, 1//3, 1//5, 1//7, 2//1]
    return prod(get_solution1(data; slope) for slope in slopes)
end


end