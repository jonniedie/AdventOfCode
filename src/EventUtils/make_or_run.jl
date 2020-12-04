
function make_my_day(n=day(today()))
    dir = joinpath("scripts", "Day"*string(n))
    code_file = joinpath(dir, "code.jl")
    template_file = joinpath("template", "code.jl")

    try
        mkdir(dir)
    catch e
        throw(e)
    end

    (tmp_path, tmp_f) = mktemp()

    !isfile(code_file) && open(template_file, read=true, write=true) do f
        for (line_num, line) in enumerate(eachline(f, keep=true))
            if line_num==1
                write(tmp_f, "module Day"*string(n))
            else
                write(tmp_f, line)
            end
        end
        close(tmp_f)
        mv(tmp_path, code_file)
    end

    n ≤ day(today()) && download_input(n)

    edit(code_file)

    return nothing
end



"""
    run_day(n; test=true, time=true)
    run_day(mod::Module; test=true, time=true)

Run day `n`'s puzzle and print outputs. Solutions will only be run if test cases pass. To
turn off the test check, set the `test` flag to `false`. If the `time` flag is set to `true`,
it will also print the time it took to run the solution. The positional argument can also be
a Day module directly.
"""
run_day(n; kwargs...) = run_day(eval(Meta.parse("Advent2020.Day$(n)")); kwargs...)

function run_day(mod::Module; test=true, time=true)
    @unpack get_inputs, get_solution1, get_solution2 = mod
    @unpack test_input1, test_output1, test_input2, test_output2, data = get_inputs()

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