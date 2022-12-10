module Day9

using ..Advent2022: split_string_lines, read_input

export get_inputs, get_solution1, get_solution2

## Types
const DIRECTIONS = Dict(
    'L' => (-1,  0),
    'R' => ( 1,  0),
    'D' => ( 0, -1),
    'U' => ( 0,  1),
)

const Position = Tuple{Int, Int}
struct Motion
    direction::Position
    steps::Int
end

Base.@kwdef mutable struct RopeNode
    position::Position = (0, 0)
    next::Union{RopeNode, Nothing} = nothing
    visited_positions::Set{Position} = Set((position,))
end

function Rope(n_nodes)
    return reduce(RopeNode() for _ in 1:n_nodes) do tail, head
        head.next = tail
        head
    end
end


## Input getting
function parse_line(str)
    direction, steps = split(str, ' ')
    return Motion(
        DIRECTIONS[only(direction)],
        parse(Int, steps),
    )
end
parse_inputs(str) = split_string_lines(str) .|> parse_line

function get_inputs()
    test_input1 = """
        R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2
        """ |> parse_inputs
    test_output1 = 13
    test_input2 = """
        R 5
        U 8
        L 8
        D 3
        R 17
        D 10
        L 25
        U 20
        """ |> parse_inputs
    test_output2 = 36
    data = read_input(9) |> parse_inputs
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
move!(::Nothing, ::Tuple{Int, Int}) = nothing
function move!(head::RopeNode, direction::Tuple{Int, Int})
    head.position = head.position .+ direction
    push!(head.visited_positions, head.position)
    return head
end
function move!(head::RopeNode, motion::Motion)
    (; direction, steps) = motion
    tail = head.next
    for _ in 1:steps
        move!(head, direction)
        follow!(tail, head)
    end
    return head
end

follow!(::Nothing, head) = nothing
function follow!(tail, head)
    Δ = head.position .- tail.position
    if any(>(1), abs.(Δ))
        move!(tail, Motion(sign.(Δ), 1))
    end
    return tail
end

get_tail(head, ::Nothing) = head
get_tail(head, tail) = get_tail(tail, tail.next)
get_tail(head) = get_tail(head, head.next)

function get_solution(moves, n_nodes)
    rope = Rope(n_nodes)
    for move in moves
        move!(rope, move)
    end
    return length(get_tail(rope).visited_positions)
end

# Part 1
get_solution1(data) = get_solution(data, 2)

# Part 2
get_solution2(data) = get_solution(data, 10)

end
