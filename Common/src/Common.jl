module Common

using OffsetArrays

export split_string_lines, matrix_to_string, read_string_matrix, zero_based

split_string_lines(str; kwargs...) = split(str, '\n'; keepempty=false, kwargs...)

read_string_matrix(str) = (
    split_string_lines(str)
    .|> collect
    |> Base.Fix1(reduce, hcat)
    |> permutedims
)

function matrix_to_string(mat; replacer=string)
    return mapreduce(*, eachrow(mat)) do row
        mapreduce(replacer, *, row) * '\n'
    end
end

zero_based(array) = OffsetArray(array, -1)

end
