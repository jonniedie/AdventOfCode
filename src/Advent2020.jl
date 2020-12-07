module Advent2020

using Dates: day, today
using Reexport: @reexport

include("FileIO.jl")
using .FileIO

include("Utils.jl")
using .Utils

include(joinpath("EventUtils", "EventUtils.jl"))
@reexport using .EventUtils

for i in 1:7
    dir = joinpath(@__DIR__, "..", "scripts", "Day"*string(i))
    if isdir(dir)
        include(joinpath(dir, "code.jl"))
    else
        make_my_day(i)
    end
end

end
