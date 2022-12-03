module Day2

using ..Advent2022: split_string_lines, read_input

export get_inputs, get_solution1, get_solution2


## Input getting
parse_line(str) = split(str, ' '; keepempty=false) |> Tuple .|> only

parse_lines(str) = split_string_lines(str) .|> parse_line

function get_inputs()
    test_input1 = """
        A Y
        B X
        C Z
        """ |> parse_lines
    test_output1 = 15
    test_input2 = test_input1
    test_output2 = 12
    data = read_input(2) |> parse_lines
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
@enum Shape ROCK=1 PAPER=2 SCISSORS=3

abc_to_shape(letter) = Shape(Int(letter) - 64)
xyz_to_shape(letter) = Shape(Int(letter) - 87)

const win_map = Dict(ROCK=>SCISSORS, PAPER=>ROCK, SCISSORS=>PAPER)

const lose_map = Dict(values(win_map) .=> keys(win_map))

function outcome_score(shapes...)
    return if ==(shapes...)
        (3, 3)
    elseif win_map[shapes[2]] == shapes[1]
        (0, 6)
    else
        (6, 0)
    end
end

shape_score(x) = Int(x)

function turn_score((p1, p2); strategy)
    p1 = abc_to_shape(p1)
    p2 = strategy(p1, p2)
    outcome_score(p1, p2)[2] + shape_score(p2)
end

total_score(data; strategy) = sum(x -> turn_score(x; strategy), data)

# Part 1
function get_solution1(data)
    strategy = (p1, p2) -> xyz_to_shape(p2)
    return total_score(data; strategy)
end

# Part 2
function get_solution2(data)
    strategy = function (p1, p2)
        if p2 == 'X'
            win_map[p1]
        elseif p2 == 'Y'
            p1
        elseif p2 == 'Z'
            lose_map[p1]
        end
    end
    return total_score(data; strategy)
end

end
