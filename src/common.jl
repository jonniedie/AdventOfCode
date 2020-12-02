module Common

export zero_based, run_day

import ..Advent2020

using OffsetArrays: OffsetArray
using Test: @test, @testset
using UnPack: @unpack


"""
    zero_based(array)

Make an array that indexes from 0 instead of 1.
"""
zero_based(array) = OffsetArray(array, -1)


"""
    run_day(n; time=true)
    run_day(mod::Module; time=true)

Run day `n`'s puzzle and print outputs. If the `time` flag is set to `true`, it will also
print the time it took to run the solution. The positional argument can also be a Day module
directly.
"""
run_day(n; time=true) = run_day(eval(Meta.parse("Advent2020.Day$(n)")); time)

function run_day(mod::Module; time=true)
    @unpack get_solution1, get_solution2, test_input1, test_output1, test_input2, test_output2, data = mod
    # Do not pass if tests don't check out
    @testset "Input tests" begin
        @test get_solution1(test_input1) == test_output1
        @test get_solution2(test_input2) == test_output2
    end

    # Print and time solution 1
    println("Solution 1: $(get_solution1(data))")
    time && @time get_solution1(data)

    # Print and time solution 2
    println("Solution 2: $(get_solution2(data))")
    time && @time get_solution2(data)

    return nothing
end

end