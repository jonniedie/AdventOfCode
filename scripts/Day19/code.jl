module Day19

export get_inputs, get_solution1, get_solution2

using Memoize, InvertedIndices


## Input getting
function get_inputs()
    test_input1 = read_input("test_input1.txt")
    test_output1 = 2
    test_input2 = read_input("test_input2.txt")
    test_output2 = 12
    data = read_input("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(f_name)
    input = read(joinpath(@__DIR__, f_name), String)
    rules, messages = split(input, r"\n\n|\r\n\r\n", keepempty=false)
    rules = Dict(parse_rule.(split(rules, r"\n|\r\n")))
    messages = split(messages, r"\n|\r\n", keepempty=false)
    return (; rules, messages)
end

function parse_rule(str)
    index, patterns = split(str, ": ")
    patterns = split(patterns, " | ", keepempty=false)
    patterns = parse_pattern.(patterns)
    return index => patterns
end

parse_pattern(str) = split(str, r" |\"", keepempty=false)


## Solution functions
@memoize function _regex_string(rule_dict, key)
    rules = rule_dict[key]
    if isletter(rules[1][1][1])
        rstr = string(only(only(only(rules))))
    else
        new_rule = String[]
        for (i, rule) in enumerate(rules)
            new_rules = String[]
            for (j, inner_rule) in enumerate(rule)
                push!(new_rules, join(_regex_string.(Ref(rule_dict), inner_rule)))
            end
            push!(new_rule, join(new_rules))
        end
        rstr = "(" * join(new_rule, "|") * ")"
    end
    return rstr
end

regex_string(rule_dict, key) = Regex(_regex_string(rule_dict, key))

# function get_solution1(data)
#     counter = 0
#     for message in data.messages
#         m = match(regex_string(data.rules, "0"), message)
#         if m !== nothing && length(m[1]) == length(message)
#             counter += 1
#         end
#     end
#     return counter
# end

# Part 1
function get_solution1(data)
    counter = 0
    for message in data.messages
        m = match(regex_string(data.rules, "0"), message)
        if m !== nothing && length(m[1]) == length(message)
            counter += 1
        end
    end
    return counter
end

# Part 2
function seq_run(ranges, start_idx=1)
    runs = Vector{Int}[]
    if isempty(ranges)
        return runs
    end
    # valid_ranges = filter(range->first(range)==start_idx, ranges)
    for (i, range) in enumerate(ranges)
        if first(range)==start_idx+1
            last_idx = last(range)
            println(runs)
            append!.(runs, seq_run(ranges[Not(i)], last_idx))
        end
    end
    return pushfirst!.(runs, start_idx)
end

function rev_first_nonsequential(ranges)
    if isempty(ranges)
        return 1
    end
    first_idx = first(ranges[1])
    for i in 2:length(ranges)
        if last_idx != first(ranges[i])
            return last_idx
        end
        last_idx = last(ranges[i]) + 1
    end
    return last_idx
end

function get_solution2(data)
    rules = data.rules
    rule_42 = regex_string(rules, "42").pattern
    rule_31 = regex_string(rules, "31").pattern
    reg = Regex(rule_42 * "*(" * rule_42 * "*" * "(?1)?" * rule_31 * ") ")
    
    counter = 0
    for message in data.messages

        m = match(reg, message * " ")
        if m !== nothing && m.match == message * " "
            counter += 1
            println(message)
            println(m.match)
            println()
        end
    end
    # for message in data.messages
    #     inds_42 = findall(rule_42, message, overlap=false)
    #     start = first_nonsequential(inds_42)
    #     inds_31 = findall(rule_31, message[start:end], overlap=false)
        
    #     if start+first_nonsequential(inds_31)-2 == length(message) &&
    #        length(inds_31) < length(inds_42) &&
    #        length(inds_31) > 0
            
    #         counter += 1
    #     end
    # end
    return counter
end

end