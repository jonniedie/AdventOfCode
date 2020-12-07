module Day7

export get_inputs, get_solution1, get_solution2

using ConcreteStructs, Memoize


## Input getting
function get_inputs()
    test_input1 = readlines(joinpath(@__DIR__, "test_input1.txt"))
    test_input2 = readlines(joinpath(@__DIR__, "test_input2.txt"))
    test_output1 = 4
    test_output2 = 126
    data = readlines(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

# Statement type for easy parsing of rules
@concrete terse struct Statement
    num
    desc
end
function Statement(str)
    if str=="no other"
        return Statement(0, "")
    else
        words = split(str, " ")
        return Statement(parse(Int, words[1]), join(words[2:end], " "))
    end
end

const NO_OTHER = Statement(0, "")

num_bags(statement) = statement.num
description(statement) = statement.desc


## Helper structs and functions
# Parse a single line of the rules
function parse_rule(line)
    line = split(line, r" bags contain | bag contains |, | bags| bag", keepempty=false)
    return String(line[1])=>Statement.(line[2:end-1])
end

# Make the rule dict
make_the_rules(lines) = Dict(parse_rule.(lines))


## Solution functions
# Part 1
@memoize function contains_bag(dict, outer, inner)
    statements = dict[outer]
    if statements[1]==NO_OTHER
        return false
    elseif inner in description.(statements)
        return true
    else
        return any(contains_bag(dict, description(statement), inner) for statement in statements)
    end
end

function get_solution1(data; bag="shiny gold")
    rules = make_the_rules(data)
    return sum(contains_bag(rules, head, bag) for head in keys(rules))
end


# Part 2
@memoize function count_bags(dict, bag)
    statements = dict[bag]
    if statements[1]==NO_OTHER
        return 0
    else
        top_level = sum(num_bags.(statements))
        return top_level + sum(num_bags(st) * count_bags(dict, description(st)) for st in statements)
    end
end


function get_solution2(data; bag="shiny gold")
    rules = make_the_rules(data)
    return count_bags(rules, bag)
end

end