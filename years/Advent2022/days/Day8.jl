module Day8

using ..Advent2022: split_string_lines, read_input
using Base: Fix1
using Common: read_string_matrix
using ThreadsX

export get_inputs, get_solution1, get_solution2

## Input getting
parse_input(str) = str |> read_string_matrix .|> Fix1(parse, Int)

function get_inputs()
    test_input1 = """
        30373
        25512
        65332
        33549
        35390
        """ |> parse_input
    test_output1 = 21
    test_input2 = test_input1
    test_output2 = 8
    data = read_input(8) |> parse_input
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
get_tree_lines(trees, ij) = get_tree_lines(trees, Tuple(ij)...)
function get_tree_lines(trees, i, j)
    return @views (
        trees[i-1:-1:1, j],
        trees[i+1:end, j],
        trees[i, j-1:-1:1],
        trees[i, j+1:end],
    )
end

function score_trees(evaluator, reducer, trees)
    return ThreadsX.map(CartesianIndices(trees)) do i
        mapreduce(reducer, get_tree_lines(trees, i)) do line
            evaluator(trees[i], line)
        end
    end
end

is_visible(tree, line) = all(<(tree), line)

closest_tree(tree, line) = something(findfirst(≥(tree), line), length(line))

# Part 1
get_solution1(trees) = score_trees(is_visible, |, trees) |> sum

# Part 2
get_solution2(trees) = score_trees(closest_tree, *, trees) |> maximum

end
