function create_day_module(dir, year, day)
    template = """
    module Day$day

    using ..Advent$year: split_string_lines, read_input

    export get_inputs, get_solution1, get_solution2

    ## Input getting
    function get_inputs()
        test_input1 = nothing
        test_output1 = nothing
        test_input2 = nothing
        test_output2 = nothing
        data = read_input($day)
        return (; test_input1, test_input2, test_output1, test_output2, data)
    end


    ## Solution functions
    # Part 1
    function get_solution1(data)
        return nothing
    end

    # Part 2
    function get_solution2(data)
        return nothing
    end

    end
    """

    write(joinpath(dir, "Day$day.jl"), template)
    return nothing
end

function create_year_module(dir, year)
    template = """
    module Advent$year

    using Common: split_string_lines
    using EventUtils: EventUtils, day, today, run_day
    
    export run_day
    
    function download_input(day=day(today()))
        inputs_dir = joinpath(@__DIR__, "..", "inputs")
        return EventUtils.download_input(inputs_dir, 2022, day)
    end
    
    function read_input(day)
        file = joinpath(@__DIR__, "..", "inputs", "Day\$day.txt")
        if isfile(file)
            return read(file, String)
        else
           @warn "Inputs for day \$day not found. Use `EventUtils.download_input` to get the day's inputs"
           return ""
        end
    end
    
    for i in 1:25
        include(joinpath("..", "days", "Day\$i.jl"))
    
        Meta.parse("export Day\$i") |> eval
    end
    
    end
    
    """
    write(joinpath(dir, "src", "Advent$year.jl"), template)
    return nothing
end

function initialize_year(root_dir, year=year(today()))
    # Create the year's package if one isn't there
    year_dir = joinpath(root_dir, "years", "Advent$year")
    if !isdir(year_dir)
        Pkg.generate(year_dir)
        Pkg.activate(year_dir)
        Pkg.develop(path=joinpath(@__DIR__, ".."))
        Pkg.develop(path=joinpath(root_dir, "Common"))

        # Create the `days` directory and each `Day{i}.jl` file
        days_dir = joinpath(year_dir, "days")
        mkdir(days_dir)
        for day in 1:25
            create_day_module(days_dir, year, day)
        end

        # Create the module file
        create_year_module(year_dir, year)

        # Create the inputs directory
        input_dir = joinpath(year_dir, "inputs")
        mkdir(input_dir)
    else
        @warn "Directory already exists at `years/Advent$year`"
    end

    return nothing
end

function initialize_day()

end