"""
    load_day(n)

Load day `n`'s code.
"""
load_day(n) = include(joinpath("Day"*string(n), "src", "code.jl"))


"""
    read_csv(f_name)

Read a CSV file.
"""
read_csv(f_name) = open(f->readdlm(f, ',', Int), f_name)


"""
    read_simple(f_name)

Simple data reading function.
"""
read_simple(T, f_name) = open(readlines, parse.(T, f_name))


"""
    read_big(f_name)

Read in single big integer
"""
read_big(f_name) = open(f->readlines(f)[1], f_name)
