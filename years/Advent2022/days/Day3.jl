module Day3

using ..Advent2022: split_string_lines, read_input
using Base: splat


## Input getting
function get_inputs()
    test_input1 = """
        vJrwpWtwJgWrhcsFMMfFFhFp
        jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
        PmmdzqPrVvPwwTWBwg
        wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
        ttgJtRGJQctTZtZT
        CrZsJsPPZsGzwwsLwLmpwMDw
        """ |> split_string_lines
    test_output1 = 157
    test_input2 = test_input1
    test_output2 = 70
    data = read_input(3) |> split_string_lines
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function split_sack(sack)
    n = length(sack) ÷ 2
    return (sack[begin:n], sack[n+1:end])
end

priority(item) = isuppercase(item) ? Int(item) - 38 : Int(item) - 96

function group_by_three(elves)
    return map(1:length(elves)÷3) do i
        j = (i-1)*3
        elves[j+1:j+3]
    end
end

broadcaster(f) = x -> f.(x)

find_shared_item(collections) = mapreduce(broadcaster(unique), intersect, collections) |> only

# Part 1
get_solution1(data) = sum(priority ∘ find_shared_item ∘ split_sack, data)

# Part 2
get_solution2(data) = sum(priority ∘ find_shared_item, group_by_three(data))

end
