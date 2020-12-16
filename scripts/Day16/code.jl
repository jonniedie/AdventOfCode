module Day16

export get_inputs, get_solution1, get_solution2

using UnPack: @unpack


## Struct definitions
# Ticket rule
struct Rule
    field::String
    ranges::Tuple{UnitRange, UnitRange}
end
function Rule(str)
    field, ranges = split(str, ':')
    ranges = parse_range.(split(ranges, " or "))
    return Rule(field, ntuple(i->ranges[i], 2))
end


## Input getting
function get_inputs()
    test_input1 = read_input("test_input1.txt")
    test_output1 = 71
    test_input2 = read_input("test_input2.txt")
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


# Part 1
function get_solution1(data)
    @unpack rules, nearby_tickets = data
    invalids = Int[]
    for ticket in nearby_tickets, number in ticket
        if !any(is_valid_under.(number, rules))
            push!(invalids, number)
        end
    end
    return sum(invalids)
end

# Part 2
function get_solution2(data)
    @unpack rules, my_ticket, nearby_tickets = data
    valid_tickets = [ticket for ticket in nearby_tickets if is_valid_under(ticket, rules)]
    pushfirst!(valid_tickets, my_ticket)
    accum = 1
    for rule in rules
        for i in eachindex(my_ticket)
            if all(is_valid_under(ticket[i], rule) for ticket in valid_tickets)
                # if occursin("departure", rule.field)
                #     accum *= my_ticket[i]
                # end
                accum *= my_ticket[i]
                break
            end
        end
    end

    return accum
end

end