module Day5
export get_inputs, get_solution1, get_solution2

using ..Advent2020.Utils: zero_based

## Input getting
function get_inputs()
    test_input1 = [
        "FBFBBFFRLR"
        "BFFFBBFRRR"
        "FFFBBBFRRR"
        "BBFFBBFRLL"
    ]
    test_input2 = nothing
    test_output1 = maximum([357, 70*8+7, 14*8+7, 102*8+4])
    test_output2 = nothing
    data = readlines(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
replace_n(str, pairs...) = String(replace(collect(str), pairs...))

binary_string(str; zero='0', one='1') = parse(Int, replace_n(str, zero=>'0', one=>'1'), base=2)

function parse_boarding_pass(pass)
    row = binary_string(pass[1:7], zero='F', one='B')
    col = binary_string(pass[8:10], zero='L', one='R')
    seat = row*8 + col
    return row, col, seat
end

# Part 1
function get_solution1(data)
    seats = last.(parse_boarding_pass.(data))
    return maximum(seats)
end

# Part 2
get_solution2(::Nothing) = nothing
function get_solution2(data)
    seats = sort(last.(parse_boarding_pass.(data)))
    seat_2 = false
    seat_1 = false
    for seat in minimum(seats)+1:maximum(seats)
        is_seat = seat in seats
        if seat_2 && !seat_1 && is_seat
            return seat - 1
        end
        seat_2 = seat_1
        seat_1 = is_seat
    end
    return nothing
end

end
