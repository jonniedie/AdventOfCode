module Advent2020

using Reexport: @reexport

include("fileIO.jl")
@reexport using .FileIO

include("common.jl")
@reexport using .Common


for i in 1:2
    include(joinpath("..", "scripts", "Day"*string(i), "code.jl"))
end

end
