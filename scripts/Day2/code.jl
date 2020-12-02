module Day2

## Input getting
# Functions
function parse_line(str)
    policy, password = split(str, ": ")
    lohi, letter = split(policy, " ")
    letter = only(letter)
    lo, hi = parse.(Int, split(lohi, "-"))
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
validator1(line) = line.lo ≤ count(c->c==line.letter, line.password) ≤ line.hi
function validator2(line)
    lo = line.password[line.lo]
    hi = line.password[line.hi]
    letter = line.letter
    return (lo==letter && !(hi==letter)) || (!(lo==letter) && hi==letter)
end

# Solution-getting closure
get_solution_with(password_validator) = data -> sum(password_validator.(data))

# Part 1
get_solution1 = get_solution_with(validator1)

# Part 2
get_solution2 = get_solution_with(validator2)

end