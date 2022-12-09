module Common

export split_string_lines

split_string_lines(str; kwargs...) = split(str, '\n'; keepempty=false, kwargs...)

read_string_matrix(str) = (
    split_string_lines(str)
    .|> collect
    |> Base.Fix1(reduce, hcat)
    |> permutedims
)

end
