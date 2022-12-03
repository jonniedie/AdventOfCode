# Taken from https://github.com/cmcaine/advent2020/blob/main/scripts/get-data.jl
get_cookie() = try
    read(joinpath(@__DIR__, "..", "cookie"), String)
catch
    println("No cookie provided for the AoC website. Save your cookie in a file called 'cookie' in the /src/EventUtils folder")
    nothing
end


function get_data(year=year(today()), day=day(today()))
    cookies = Dict("session" => get_cookie())
    response = HTTP.get("https://adventofcode.com/$year/day/$day/input", cookies=cookies)
    response.status != 200 && error(response)
    return response.body
end

function download_input(data_dir, year=year(today()), day=day(today()))
    fname = joinpath(data_dir, "Day$day.txt")
    if !isfile(fname)
        data = get_data(year, day)
        write(fname, data)
    end
    return nothing
end