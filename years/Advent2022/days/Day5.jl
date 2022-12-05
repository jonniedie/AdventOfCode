module Day5

using ..Advent2022: split_string_lines, read_input

export get_inputs, get_solution1, get_solution2

## Input getting
parse_state_line(str) = collect(str)[2:4:end]

filter_empties!(chars) = filter!(!=(' '), chars)

function parse_state(str)
    lines = parse_state_line.(split_string_lines(str))[1:end-1]
    return reduce.(vcat, zip(lines...)) .|> reverse .|> filter_empties!
end

function parse_instruction(str)
    schema = r"move (\d+) from (\d+) to (\d+)"
    return parse.(Int, match(schema, str).captures)
end

function parse_input(str)
    state_str, instruction_str = split(str, "\n\n"; keepempty=false)
    instruction_strs = split_string_lines(instruction_str)
    return (
        state = parse_state(state_str),
        instructions = parse_instruction.(instruction_strs),
    )
end

function get_inputs()
    test_input1 = """
            [D]    
        [N] [C]    
        [Z] [M] [P]
         1   2   3 
        
        move 1 from 2 to 1
        move 3 from 1 to 3
        move 2 from 2 to 1
        move 1 from 1 to 2
        
        """ |> parse_input
    test_output1 = "CMZ"
    test_input2 = test_input1
    test_output2 = "MCD"
    data = read_input(5) |> parse_input
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function move!(state, instruction; reverse_fun=reverse!)
    n, from, to = instruction
    col = state[from]
    items = splice!(col, length(col)-n+1:length(col))
    append!(state[to], reverse_fun(items))
    return state
end

function move_crates(data; kwargs...)
    (; state, instructions) = data
    f = (args...) -> move!(args...; kwargs...)
    reduce(f, instructions; init = state)
    return mapreduce(last, string, state)
end

# Part 1
get_solution1(data) = move_crates(data)

# Part 2
get_solution2(data) = move_crates(data; reverse_fun=identity)

end
