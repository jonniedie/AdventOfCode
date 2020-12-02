module Day2

## Setup

## Inputs (change these)
# Functions
function parse_line(str)
    lohi, letter, password = split(str, " ")
    lo, hi = parse.(Int, split(lohi, "-"))
    letter = string(letter[1])
    return (; lo, hi, letter, password)
end

read_input(io) = parse_line.(readlines(io))

# Inputs
const test_input1 = test_input2 = read_input(
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
# Password validators
validator1(line) = line.lo ≤ count(string(line.letter), line.password) ≤ line.hi
validator2(line) =
    string(line.password[line.lo])==line.letter && !(string(line.password[line.hi])==line.letter) ||
    !(string(line.password[line.lo])==line.letter) && string(line.password[line.hi])==line.letter

# Solution-getting closure
get_solution_with(password_validator) = data -> sum(password_validator.(data))

# Part 1
get_solution1 = get_solution_with(validator1)

# Part 2
get_solution2 = get_solution_with(validator2)

end