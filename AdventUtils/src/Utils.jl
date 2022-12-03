module Utils

export zero_based

import ..Advent2020

using OffsetArrays: OffsetArray


"""
    zero_based(array)

Make an array that indexes from 0 instead of 1.
"""
zero_based(array) = OffsetArray(array, -1)


end