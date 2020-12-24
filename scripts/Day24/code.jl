module Day24

export get_inputs, get_solution1, get_solution2

using StaticArrays, OffsetArrays


## Input getting
function get_inputs()
    test_input1 = test_input2 = readlines(joinpath(@__DIR__, "test_input1.txt"))
    test_output1 = 10
    test_output2 = 2208
    data = readlines(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

const DIRECTION_MAP = Dict(
    "ne" => ( 0,  1),
    "nw" => (-1,  1),
    "sw" => ( 0, -1),
    "se" => ( 1, -1),
    "w"  => (-1,  0),
    "e"  => ( 1,  0),
)

function parse_directions(directions)
    directions = getindex.(directions, findall(r"(ne|nw|sw|se|w|e)", directions))
    return [DIRECTION_MAP[direction] for direction in directions]
end


## Solution functions
const BLACK = true
const WHITE = false

function initialize_tiles(directions, n)
    flip_tiles = [(sum(first.(direction)), sum(last.(direction)))
        for direction in parse_directions.(directions)
    ]
    # flip_tiles = sum.(parse_directions.(directions))
    black_tiles = Set(flip_tiles)
    positions = [tile for tile in black_tiles if isodd(count(==(tile), flip_tiles))]
    bounding_box = ((:)(extrema(first(positions))...), (:)(extrema(first(positions))...))
    bounding_box = grow(bounding_box, n+1)
    tiles = zeros(Bool, bounding_box...)
    tiles[CartesianIndex.(positions)] .= true
    return (; tiles, bounding_box)
end

grow(bounding_box, n=1) = map(range -> first(range)-n:last(range)+n, bounding_box)


# Part 1
get_solution1(data) = initialize_tiles(data, 10).tiles |> count

# Part 2
function get_solution2(data)
    tile_colors, bounding_box = initialize_tiles(data, 100)
    temp = copy(tile_colors)
    adj_inds = values(DIRECTION_MAP)

    for turn in 1:100
        temp .= tile_colors

        for pos in CartesianIndices(tile_colors)
            count_black = 0
            for adj_pos in (Tuple(pos) .+ i for i in adj_inds)
                !checkbounds(Bool, tile_colors, adj_pos...) && break
                if tile_colors[adj_pos...] == BLACK
                    count_black += 1
                end
            end
            
            color = tile_colors[pos]
            if color==BLACK && (count_black==0 || count_black>2)
                temp[pos] = WHITE
            elseif color==WHITE && count_black==2
                temp[pos] = BLACK
            end
        end

        tile_colors .= temp
    end

    return count(values(tile_colors))
end

end