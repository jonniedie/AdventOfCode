module Advent2020


using Reexport: @reexport

include("fileIO.jl")
@reexport using .FileIO

include("common.jl")
@reexport using .Common

include("download_data/download_data.jl")
export download_input

for i in 1:3
    try
        include(joinpath("..", "scripts", "Day"*string(i), "code.jl"))
    catch
        println("There is no input file for  $i. Run `download_input($i)` to download the input for day $i")
    end
end

end
