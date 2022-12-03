module Advent2022

using EventUtils: EventUtils, day, today, run_day

export run_day

function download_input(day=day(today()))
    inputs_dir = joinpath(@__DIR__, "..", "inputs")
    return EventUtils.download_input(inputs_dir, 2022, day)
end

split_string_lines(str; kwargs...) = split(str, '\n'; keepempty=false,)

function read_input(day)
    file = joinpath(@__DIR__, "..", "inputs", "Day$day.txt")
    if isfile(file)
        return read(file, String)
    else
       @warn "Inputs for day $day not found. Use `EventUtils.download_input` to get the day's inputs"
       return ""
    end
end

for i in 1:25
    include(joinpath("..", "days", "Day$i.jl"))
end

end

