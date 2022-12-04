module Common

export split_string_lines

split_string_lines(str; kwargs...) = split(str, '\n'; keepempty=false, kwargs...)

end
