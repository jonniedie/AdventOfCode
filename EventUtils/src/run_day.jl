"""
    run_day(year, day; test=true, time=true)
    run_day(mod::Module; test=true, time=true)

Run `year` and `day`'s puzzle and print outputs. Solutions will only be run if test cases pass. To
turn off the test check, set the `test` flag to `false`. If the `time` flag is set to `true`,
it will also print the time it took to run the solution. The positional argument can also be
a Day module directly.
"""
run_day(year, day; kwargs...) = run_day(eval(Meta.parse("Advent$(year).Day$(day)")); kwargs...)
function run_day(mod::Module; test=true, time=true)
    (; get_inputs, get_solution1, get_solution2) = mod
    (; test_input1, test_output1, test_input2, test_output2, data) = get_inputs()

    # Do not pass if tests don't check out
    test && @testset "Input tests" begin
        @testset "Part 1" begin @test get_solution1(test_input1) == test_output1 end
        @testset "Part 2" begin @test get_solution2(test_input2) == test_output2 end
    end

    # Print and time solution 1
    println("Solution 1: $(get_solution1(data))")
    time && @time get_solution1(data)

    # Print and time solution 2
    println("Solution 2: $(get_solution2(data))")
    time && @time get_solution2(data)

    return nothing
end