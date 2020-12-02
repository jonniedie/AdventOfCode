# Advent of Code 2020

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
```

Each day is it's own module with exported functions
- `get_solution1`
- `get_solution2`

and variables
- `test_input1`
- `test_input2`
- `test_output1`
- `test_output2`
- `data`

You can manually run any of the solutions like this:
```julia-repl
julia> using Advent2020.Day1

julia> Day1.get_solution(Day1.data)
[answer 1 (hidden here)]
```