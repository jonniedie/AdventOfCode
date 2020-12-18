module Day18

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = readlines(IOBuffer(
        """
        1 + 2 * 3 + 4 * 5 + 6
        1 + (2 * 3) + (4 * (5 + 6))
        2 * 3 + (4 * 5)
        5 + (8 * 3 + 9 + 3 * 4 * 3)
        5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
        ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
        """))
    test_output1 = 71 + 51 + 26 + 437 + 12240 + 13632
    test_output2 = 231 + 51 + 46 + 1445 + 669060 + 23340
    data = readlines(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Define new addition operator from same precedence pool as *
const ⊠ = +

# And new multiplication operator from same precence pool as +
const ⊞ = *

# Replace the desired operation rules and parse as an Expr object to be evaled
parse_expr(str, rules...) = Meta.parse(reduce(replace, rules, init=str))

# Create expressions and eval them
get_solution(data, rules...) = sum(eval.(parse_expr.(data, rules...)))


# Part 1
get_solution1(data) = get_solution(data, '+'=>'⊠')

# Part 2
get_solution2(data) = get_solution(data, '+'=>'⊠', '*'=>'⊞')

end