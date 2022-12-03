# Advent of Code

To run any of these examples, use the `run_day` function.

Note: Input text files are .gitignored and must be first placed in their `/scripts/DayN` folder with the name `input.txt`.

```julia-repl
julia> using Advent2020

julia> run_day(1)
Test Summary: | Pass  Total
Input tests   |    2      2
Solution 1: [answer 1 (hidden here)]
  0.000002 seconds (1 allocation: 16 bytes)
Solution 2: [answer 2 (hidden here)]
  0.000037 seconds (1 allocation: 16 bytes)

julia> run_day(1, time=false)
Test Summary: | Pass  Total
Input tests   |    2      2
Solution 1: [answer 1 (hidden here)]
Solution 2: [answer 2 (hidden here)]

julia> run_day(1, test=false, time=false)
Solution 1: [answer 1 (hidden here)]
Solution 2: [answer 2 (hidden here)]
```

Each day is it's own module with exported functions
- `get_inputs`
- `get_solution1`
- `get_solution2`

Calling `get_inputs()` will return a `NamedTuple` with entries
- `test_input1`
- `test_input2`
- `test_output1`
- `test_output2`
- `data`

Before solving the problem, the `run_day` function first check that
```julia
inputs = get_inputs()
get_solution1(inputs.test_input1) == inputs.test_output1
get_solution2(inputs.test_input2) == inputs.test_output2
```


You can manually run any of the solutions like this:
```julia-repl
julia> using Advent2020.Day1

julia> get_solution1(get_inputs().data)
[answer 1 (hidden here)]
```