module Advent2020

using DelimitedFiles: readdlm
using OffsetArrays: OffsetArray
using Reexport

include("fileIO.jl")
@reexport using .FileIO

include("common.jl")
@reexport using .Common

for i in 1:2
    FileIO.load_day(i)
end

end
