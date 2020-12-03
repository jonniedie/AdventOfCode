# Taken from https://github.com/cmcaine/advent2020/blob/main/scripts/get-data.jl
aoc_cookie = try
    read(joinpath(@__DIR__, "cookie"), String)
catch
    println("No cookie provided for the AoC website. Save your cookie in a file called 'cookie' in the /src/EventUtils folder")
    nothing
end


function get_data(day)
    response = HTTP.get("https://adventofcode.com/2020/day/$day/input", cookies = Dict("session" => aoc_cookie))
    response.status != 200 && error(response)
    return response.body
end

function download_input(day)
    fname = joinpath("scripts", "Day$day", "input.txt")
    if !isfile(fname)
        data = get_data(day)
        write(fname, data)
    end
    return nothing
end