module Advent2020

using DelimitedFiles: readdlm
using OffsetArrays: OffsetArray

include("fileIO.jl")
include("common.jl")

for i in 1:1
    load_day(i)
end

export zero_based

end
