# Advent of Code
## Organization
Each year is implemented as a separate module inside the [years](/years) directory. Each day's code is a separate module inside the `days` directory of the year. There are a few common utility modules as well:
- [EventUtils](/EventUtils): Contains all infrastructure-related functions
- [Common](/Common): Contains any utilities that are shared across all years

## Setup
### Adding a new year
To set up a new year, use the `EventUtils.initialize_year(parent_directory[, year])` function. Point this to the [years](/years) directory as the `parent_directory` and specify the year to create as an integer (if none is given, the current year will be chosen).

### Setting cookie file for data download
If you want to automatically download data from the AOC website instead of manually entering it, in the [EventUtils](/EventUtils) directory save your AOC cookie in a file called `cookie`.

## Usage
### Downloading data
Use the `download_input()` function from the year's module to download the current day's input into the `inputs` directory for that year. To download a different day's input, pass in the day number as an integer.

```julia
using Advent2020

Advent2020.download_input() # download today's input
Advent2020.download_input(3) # download the input for day 3
```

### Running your code
To run a day's code, use the `run_day` function on the module of the day you want to run.

```julia
julia> run_day(Advent2020.Day1)
Test Summary: | Pass  Total
Input tests   |    2      2
Solution 1: [answer 1 (hidden here)]
  0.000002 seconds (1 allocation: 16 bytes)
Solution 2: [answer 2 (hidden here)]
  0.000037 seconds (1 allocation: 16 bytes)
  
julia> run_day(Advent2020.Day1, time=false)
Test Summary: | Pass  Total
Input tests   |    2      2
Solution 1: [answer 1 (hidden here)]
Solution 2: [answer 2 (hidden here)]

julia> run_day(Advent2020.Day1, test=false, time=false)
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

Before solving the problem, the `run_day` function will first check that
```julia
inputs = get_inputs()
get_solution1(inputs.test_input1) == inputs.test_output1
get_solution2(inputs.test_input2) == inputs.test_output2
```

You can also manually run any of the solutions like this:
```julia
julia> using Advent2020.Day1

julia> get_solution1(get_inputs().data)
[answer 1 (hidden here)]
```
