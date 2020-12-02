module Day2

## Setup
using Advent2020

function parse_line(str)
    lohi, letter, password = split(str, " ")
    lo, hi = parse.(Int, split(lohi, "-"))
    letter = string(letter[1])
    return (; lo, hi, letter, password)
end

read_input(io) = parse_line.(readlines(io))

valid_password1(line) = line.lo ≤ count(string(line.letter), line.password) ≤ line.hi

valid_password2(line) =
    string(line.password[line.lo])==line.letter && !(string(line.password[line.hi])==line.letter) ||
    !(string(line.password[line.lo])==line.letter) && string(line.password[line.hi])==line.letter

## Inputs (change these)
const test_input = read_input(
    IOBuffer(
        """
        1-3 a: abcde
        1-3 b: cdefg
        2-9 c: ccccccccc
        """
    )
)
const test_output1 = 2
const test_output2 = 1

const data = read_input(joinpath(@__DIR__, "input.txt"))


## Solution functions (change these)
# Part 1
get_solution1(data) = sum(valid_password1.(data))

# Part 2
get_solution2(data) = sum(valid_password2.(data))


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