module EventUtils

export run_day, make_my_day, download_input

using Dates: day, today
using InteractiveUtils: edit
using Test: @test, @testset
using UnPack: @unpack

import ..Advent2020
import HTTP

include("download_data.jl")
include("make_or_run.jl")

end