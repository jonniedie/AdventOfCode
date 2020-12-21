module Day20

export get_inputs, get_solution1, get_solution2

using UnPack: @unpack


## Input getting
function get_inputs()
    test_input1 = read_input("test_input1.txt")
    test_output1 = 20899048083289
    test_input2 = nothing
    test_output2 = nothing
    data = read_input("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    str = read(joinpath(@__DIR__, io), String)
    tile_strs = split(str, r"\n\n|\r\n\r\n", keepempty=false)
    return Dict(Tile.(tile_strs))
end


## Struct definitions
const Maybe{X} = Union{X, Nothing}
const PlainIndex = Union{Int, <:AbstractVector}

Base.@kwdef mutable struct Tile <: AbstractMatrix{Bool}
    image::BitMatrix
    rotation::Int = 0
    flipx::Bool = false
    R::Maybe{Tile} = nothing
    U::Maybe{Tile} = nothing
    L::Maybe{Tile} = nothing
    D::Maybe{Tile} = nothing
end

function Tile(str::AbstractString)
    lines = split(str, r"\n|\r\n", keepempty=false)
    tile_num = parse(Int, only(match(r"Tile.([0-9]+)\:", lines[1]).captures))
    image = BitArray(permutedims(reduce(hcat, collect.(lines[2:end])), [2,1]) .== '#')
    return tile_num => Tile(; image)
end

Base.size(tile::Tile) = size(tile.image)

Base.getindex(tile::Tile, ij::CartesianIndex) = getindex(tile, ij.I...)
Base.getindex(tile::Tile, ::Colon, j::PlainIndex) = getindex(tile, axes(tile, 1), j)
Base.getindex(tile::Tile, i::PlainIndex, ::Colon) = getindex(tile, i, axes(tile, 2))
Base.getindex(tile::Tile, ::Colon, ::Colon) = getindex(tile, axes(tile)...)
function Base.getindex(tile::Tile, i::PlainIndex, j::PlainIndex)
    sz_i, sz_j = size(tile) .+ 1

    rot = tile.rotation
    if rot == 1
        i, j = sz_j.-j, i
    elseif rot == 2
        i, j = sz_i.-i, sz_j.-j
    elseif rot == 3
        i, j = j, sz_i.-i
    end

    flipx = tile.flipx
    if flipx
        j = sz_j .- j
    end

    return tile.image[i, j]
end

Base.@inline Base.getproperty(tile::Tile, ::Val{B}) where B = getfield(tile, B)
Base.@inline Base.setproperty!(tile::Tile, ::Val{B}, x) where B = setfield!(tile, B, x)

get_border(tile, dir) = get_border(tile, Val(dir))
get_border(tile, ::Val{:R}) = @view tile[:, end]
get_border(tile, ::Val{:U}) = @view tile[begin, :]
get_border(tile, ::Val{:L}) = @view tile[:, begin]
get_border(tile, ::Val{:D}) = @view tile[end, :]

const BORDERS = Val.((:R, :U, :L, :D))

opposite(::Val{:R}) = Val(:L)
opposite(::Val{:U}) = Val(:D)
opposite(::Val{:L}) = Val(:R)
opposite(::Val{:D}) = Val(:U)

# Apply clockwise rotation to a tile and update all tiles attached to it
rotate!(::Nothing, rot=1) = nothing
function rotate!(tile, rot=1)
    @unpack R, U, L, D = tile
    tile.rotation = mod(tile.rotation + rot, 4)
    tile.R = rotate!(U, rot)
    tile.U = rotate!(L, rot)
    tile.L = rotate!(D, rot)
    tile.D = rotate!(R, rot)
    return tile
end

flipx!(::Nothing) = nothing
function flipx!(tile)
    @unpack R, U, L, D = tile
    tile.flipx = !tile.flipx
    tile.R = flipx!(L)
    tile.L = flipx!(R)
end

Base.@inline function connect!(tile, other_tile, B)
    setproperty!(tile, B, other_tile)
    setproperty!(other_tile, opposite(B), tile)
    return tile
end


## Solution functions
function set_matches!(tile_set, unused_tiles=copy(tile_set))
    connected_tiles = Dict(pop!(unused_tiles))
    while !isempty(unused_tiles)
        for (this_id, this_tile) in connected_tiles
            for b in BORDERS
                getproperty(this_tile, b) !== nothing && continue
                this_border = get_border(this_tile, b)
                opp_b = opposite(b)
                for (id, tile) in unused_tiles
                    connected = false
                    for rot in 1:4
                        rotate!(tile)
                        for flip in 1:2
                            flipx!(tile)
                            getproperty(tile, opp_b) !== nothing && continue
                            if get_border(tile, opp_b) == this_border
                                connect!(this_tile, tile, b)
                                delete!(unused_tiles, id)
                                push!(connected_tiles, id=>tile)
                                connected = true
                                break
                            end
                        end
                        connected && break
                    end
                    connected && break
                end
            end
        end
    end
    return connected_tiles
end

function layout_image(tiles)
    idx = (0, 0)
    image = Dict{Tuple{Int, Int}, Pair{Int, Tile}}()
    for tile in tiles
    end
end

# Part 1
function get_solution1(data)
    out = set_matches!(data)
    corners = filter(x->count(getproperty.(Ref(last(x)), BORDERS) .=== nothing) !== 2, out)
    return prod(keys(corners))
end

# Part 2
function get_solution2(data)
    return nothing
end

end