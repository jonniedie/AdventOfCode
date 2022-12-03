module EventUtils

export run_day, make_my_day, download_input

using Dates: year, day, today
using InteractiveUtils: edit
using Test: @test, @testset

import HTTP
import Pkg

include("initialize_year.jl")
include("download_data.jl")
include("make_or_run.jl")

end