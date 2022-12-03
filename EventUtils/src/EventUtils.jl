module EventUtils

using Dates: year, day, today
using InteractiveUtils: edit
using Test: @test, @testset

import HTTP
import Pkg

include("initialize_year.jl")
export initialize_year

include("download_data.jl")
export download_input

include("run_day.jl")
export run_day

end