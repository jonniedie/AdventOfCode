module FileIO

export read_csv, read_simple, read_big

import ..Advent2020

"""
    load_day(n)

Load day `n`'s code.
"""
load_day(n) = Advent2020.include(joinpath("..", "scripts", "Day"*string(n), "code.jl"))


"""
    read_csv(f_name)

Read a CSV file.
"""
read_csv(f_name) = open(f->readdlm(f, ',', Int), f_name)


"""
    read_simple(f_name)

Simple data reading function.
"""
read_simple(f_name, T=Int) = parse.(T, open(readlines, f_name))


"""
    read_big(f_name)

Read in single big integer
"""
read_big(f_name) = open(f->readlines(f)[1], f_name)


end