module Day16

export get_inputs, get_solution1, get_solution2

using UnPack: @unpack
using InvertedIndices: Not


## Struct definitions
# Ticket rule
struct Rule
    field::String
    ranges::Vector{UnitRange}
end
function Rule(str)
    field, ranges = split(str, ':')
    ranges = parse_range.(split(ranges, " or "))
    return Rule(field, ranges)
end


## Input getting
function get_inputs()
    test_input1 = read_input("test_input1.txt")
    test_output1 = 71
    test_input2 = (read_input("test_input2.txt"), "")
    test_output2 = 12 * 11 * 13
    data = read_input("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


function read_input(f_name)
    input = read(joinpath(@__DIR__, f_name), String)
    rules, my_ticket, nearby_tickets = split(input, r"\n\n|\r\n\r\n", keepempty=false)
    rules = Rule.(split(rules, r"\n|\r\n"))
    my_ticket = parse_ticket(split(my_ticket, r"\n|\r\n", limit=2)[2])
    nearby_tickets = parse_ticket.(split(nearby_tickets, r"\n|\r\n", keepempty=false)[2:end])
    return (; rules, my_ticket, nearby_tickets)
end

parse_range(str) = UnitRange(parse.(Int, split(str, '-'))...)

parse_ticket(str) = parse.(Int, split(str, ','))


## Solution functions
is_valid_under(number, rule) = any(number .∈ rule.ranges)
is_valid_under(ticket::AbstractArray, rules) = all(any(is_valid_under.(number, rules)) for number in ticket)

drop_apply(f, x; dims) = dropdims(f(x; dims); dims)


# Part 1
function get_solution1(data)
    @unpack rules, nearby_tickets = data
    sum_invalids = 0
    for ticket in nearby_tickets, number in ticket
        if !any(is_valid_under.(number, rules))
            sum_invalids += number
        end
    end
    return sum_invalids
end

# Part 2
get_solution2(input::Tuple) = get_solution2(input...)

function get_solution2(data, word="departure")
    @unpack rules, my_ticket, nearby_tickets = data

    valid_tickets = [ticket for ticket in nearby_tickets if is_valid_under(ticket, rules)]
    pushfirst!(valid_tickets, my_ticket)

    valid_matrix = [
        all(is_valid_under(ticket[i], rule) for ticket in valid_tickets)
        for rule in rules, i in eachindex(my_ticket)
    ]
    for i in sortperm(drop_apply(count, valid_matrix, dims=1))
        i_r = findfirst(valid_matrix[:,i])
        valid_matrix[i_r, Not(i)] .= false
    end
    rule_indices = findfirst.(eachcol(valid_matrix))

    return  prod(my_ticket[i] for (i, i_r) in enumerate(rule_indices) if occursin(word, rules[i_r].field))
end


end