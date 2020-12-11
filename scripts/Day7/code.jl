module Day7

export get_inputs, get_solution1, get_solution2

using ConcreteStructs, Memoize


## Input getting
read_inputs(f_name) = make_the_rules(readlines(joinpath(@__DIR__, f_name)))

function get_inputs()
    test_input1 = read_inputs("test_input1.txt")
    test_input2 = read_inputs("test_input2.txt")
    test_output1 = 4
    test_output2 = 126
    data = read_inputs("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

# Statement type for easy parsing of rules
struct Statement
    num::Int
    desc::String
end

const NO_OTHER = Statement(0, "no other")

function Statement(str)
    if str=="no other"
        return NO_OTHER
    else
        num, desc = split(str, " ", limit=2)
        num = parse(Int, num)
        return Statement(num, desc)
    end
end

num_bags(statement) = statement.num
description(statement) = statement.desc


## Helper functions
# Parse a single line of the rules
function parse_rule(line)
    head, body = split(line, r" bags contain ")
    body = split(body, r" (bag|bags)(, |\.)", keepempty=false)
    return String(head) => Statement.(body)
end

# Make the rule dict
make_the_rules(lines) = Dict(parse_rule.(lines))


## Solution functions
# Part 1
@memoize function contains_bag(rules, outer, inner)
    statements = rules[outer]
    if statements[1]==NO_OTHER
        return false
    elseif inner in description.(statements)
        return true
    else
        return any(contains_bag(rules, description(statement), inner) for statement in statements)
    end
end

get_solution1(rules; bag="shiny gold") = count(contains_bag(rules, head, bag) for head in keys(rules))


# Part 2
@memoize function count_bags(rules, bag)
    statements = rules[bag]
    if statements[1]==NO_OTHER
        return 0
    else
        return sum(num_bags(s) * (1 + count_bags(rules, description(s))) for s in statements)
    end
end

get_solution2(rules; bag="shiny gold") = count_bags(rules, bag)


## Bonus
# Pretty print bag structure
function show_bag(rules, bag="shiny gold", pre="", first=true)
    first && println(bag)
    statements = rules[bag]
    # statements = sort(rules[bag], by=x->count_bags(rules, x.desc), rev=true)
    if statements[1] == NO_OTHER
        return nothing
    end
    for i in 1:length(statements)-1
        statement = statements[i]
        println(pre * " ├╴ $(statement.desc) × $(statement.num)")
        show_bag(rules, statement.desc, pre * " │  ", false)
    end
    println(pre * " ╰╴ $(statements[end].desc) × $(statements[end].num)")
    show_bag(rules, statements[end].desc, pre * "    ", false)
end

end