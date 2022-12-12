module Day11

using ..Advent2022: split_string_lines, read_input
using FunctionWrappers: FunctionWrapper
using Common: zero_based
# using ProgressMeter: @showprogress

export get_inputs, get_solution1, get_solution2


## Types
const Item = Int

Base.@kwdef struct Test
    divisible_by::Int
    if_true::Int
    if_false::Int
end
(t::Test)(x) = x % t.divisible_by == 0 ? t.if_true : t.if_false

function Base.show(io::IO, test::Test)
    (; divisible_by, if_true, if_false) = test
    print(io, "worry_level -> worry_level % $divisible_by == 0 ? $if_true : $if_false")
end

Base.@kwdef mutable struct Monkey
    held_items::Vector{Item}
    operation::FunctionWrapper{Item, Tuple{Item}}
    test::Test
    items_inspected::Int = 0
    _operation_string::String
end

function Base.show(io::IO, monkey::Monkey)
    (; held_items, items_inspected, _operation_string, test) = monkey
    println(io, "Monkey")
    println(io, "  held_items: $held_items")
    println(io, "  items_inspected: $items_inspected")
    println(io, "  operation: $_operation_string")
    println(io, "  test: $test")
end


## Input getting
function parse_chunk(str)
    lines = split(str, '\n')
    operation_string = replace("old -> $(lines[3][20:end])", "old" => "worry_level")
    return Monkey(;
        held_items = parse.(Item, split(lines[2][19:end], ", ")),
        operation = (
            operation_string
            |> Meta.parse
            |> eval
            |> FunctionWrapper{Item, Tuple{Item}}
        ),
        _operation_string = operation_string,
        test = Test(
            divisible_by = parse(Int, lines[4][22:end]),
            if_true = parse(Int, lines[5][30:end]),
            if_false = parse(Int, lines[6][31:end]),
        ),
    )
end

function parse_inputs(str)
    split(str, "\n\n"; keepempty=false) .|> parse_chunk |> zero_based
end

function get_inputs()
    test_input1 = read_input("11_test1") |> parse_inputs
    test_output1 = 10605
    test_input2 = test_input1
    test_output2 = 2713310158
    data = read_input(11) |> parse_inputs
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function inspect_first_item!(monkey; lcm, worry_reducer = x -> x ÷ 3)
    (; test, operation, held_items) = monkey
    worry_level = popfirst!(held_items) |> operation
    worry_level = worry_reducer(worry_level) % lcm
    next_monkey = test(worry_level)
    monkey.items_inspected += 1
    return next_monkey, worry_level
end

function throw_items!(monkeys; kwargs...)
    for monkey in monkeys
        while !isempty(monkey.held_items)
            next_monkey, worry_level = inspect_first_item!(monkey; kwargs...)
            push!(monkeys[next_monkey].held_items, worry_level)
        end
    end
    return monkeys
end

get_lcm_of_divisibles(monkeys) = lcm([monkey.test.divisible_by for monkey in monkeys])

function monkey_buisiness(monkeys)
    items_inspected = sort!([monkey.items_inspected for monkey in monkeys])
    return prod(items_inspected[end-1:end])
end

function get_solution(monkeys, n_rounds; kwargs...)
    for _ in 1:n_rounds
        throw_items!(monkeys; lcm=get_lcm_of_divisibles(monkeys), kwargs...)
    end
    return monkey_buisiness(monkeys)
end

# Part 1
get_solution1(data) = get_solution(data, 20; worry_reducer = x -> x ÷ 3)

# Part 2
get_solution2(data) = get_solution(data, 10_000; worry_reducer=identity)

end
