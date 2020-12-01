module Day1

using ..Advent2020
using InvertedIndices: Not


function solution1(data)
    for i in eachindex(data)
        for j in i+1:length(data)
            these_data = (data[i], data[j])
            if sum(these_data)==2020
                return prod(these_data)
            end
        end
    end
end

function solution2(data)
    for i in eachindex(data)
        for j in i+1:length(data)
            for k in j+1:length(data)
                these_data = (data[i], data[j], data[k])
                if sum(these_data)==2020
                    return prod(these_data)
                end
            end
        end
    end
end

export solution1, solution2

end


