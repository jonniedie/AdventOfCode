module Day20

export get_inputs, get_solution1, get_solution2
export Tile, rotate!, flipy!, layout_image, concatenate_image

using UnPack: @unpack
using OffsetArrays: OffsetArray


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_input("test_input1.txt")
    test_output1 = 20899048083289
    test_output2 = 273
    data = read_input("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    str = read(joinpath(@__DIR__, io), String)
    tile_strs = split(str, r"\n\n|\r\n\r\n", keepempty=false)
    tiles = Tile.(tile_strs)
    return Dict(tile.id => tile for tile in tiles)
end

lines_to_image(lines) = BitArray(permutedims(reduce(hcat, collect.(lines)), [2,1]) .== '#')


## Struct definitions
const Maybe{X} = Union{X, Nothing}
const PlainIndex = Union{Int, <:AbstractVector}


mutable struct Connections{T}
    R::Maybe{T}
    U::Maybe{T}
    L::Maybe{T}
    D::Maybe{T}
end

Base.@inline Base.getproperty(c::Connections, ::Val{B}) where B = getfield(c, B)
Base.@inline Base.setproperty!(c::Connections, ::Val{B}, x) where B = setfield!(c, B, x)


Base.@kwdef mutable struct Tile <: AbstractMatrix{Bool}
    id::Int = 0
    image::Matrix{Bool}
    rotation::Int = 0
    flipy::Bool = false
    parent_connections::Connections = Connections()
    child_connections::Connections = Connections()
end

Tile(image::AbstractMatrix) = Tile(; image)

function Tile(str::AbstractString)
    lines = split(str, r"\n|\r\n", keepempty=false)
    id = parse(Int, only(match(r"Tile.([0-9]+)\:", lines[1]).captures))
    image = lines_to_image(lines[2:end])
    return Tile(; id, image)
end

Connections(; R=nothing, U=nothing, L=nothing, D=nothing) = Connections{Tile}(R, U, L, D)


# Base.show(io::IO, tile::Tile) = show(io, MIME("text/plain"), tile)
function Base.show(io::IO, mime::MIME"text/plain", tile::Tile)
    println("Tile $(tile.id):")
    for line in eachrow(tile)
        for char in line
            print(char ? '#' : '.')
        end
        print('\n')
    end
end

Base.size(tile::Tile) = size(tile.image)

Base.getindex(tile::Tile, ij::CartesianIndex) = getindex(tile, ij.I...)
Base.getindex(tile::Tile, ::Colon, j::PlainIndex) = getindex(tile, axes(tile.image, 1), j)
Base.getindex(tile::Tile, i::PlainIndex, ::Colon) = getindex(tile, i, axes(tile.image, 2))
Base.getindex(tile::Tile, ::Colon, ::Colon) = getindex(tile, axes(tile)...)
function Base.getindex(tile::Tile, i::PlainIndex, j::PlainIndex)
    # rot = tile.rotation
    # ax_i, ax_j = axes(tile.image)
    # if rot == 1
    #     i, j = reverse(ax_j)[j], i
    # elseif rot == 2
    #     i, j = reverse(ax_i)[i], reverse(ax_j)[j]
    # elseif rot == 3
    #     i, j = j, reverse(ax_i)[i]
    # end

    # flipy = tile.flipy
    # if flipy
    #     i = reverse(ax_i)[i]
    # end

    return tile.image[i, j]
end

# Base.@inline Base.getproperty(tile::Tile, ::Val{B}) where B = getfield(tile, B)
# Base.@inline Base.setproperty!(tile::Tile, ::Val{B}, x) where B = setfield!(tile, B, x)

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
function rotate!(tile::Tile, rot=1)
    children = tile.child_connections
    @unpack R, U, L, D = children

    for r in 1:rot
        tile_image = copy(tile.image)
        for i in 1:size(tile.image, 1), (j, j_inv) in enumerate(size(tile.image, 2):-1:1)
            tile.image[i, j] = tile_image[j_inv, i]
        end
    end

    tile.rotation = mod(tile.rotation + rot, 4)
    children.R = rotate!(U, rot)
    children.U = rotate!(L, rot)
    children.L = rotate!(D, rot)
    children.D = rotate!(R, rot)

    return tile
end

flipy!(::Nothing) = nothing
function flipy!(tile::Tile)
    children = tile.child_connections
    @unpack R, U, L, D = children

    tile_image = copy(tile.image)
    for (i, i_inv) in enumerate(size(tile.image, 1):-1:1), j in 1:size(tile.image, 2)
        tile.image[i, j] = tile_image[i_inv, j]
    end

    tile.flipy = !tile.flipy
    children.R = flipy!(L)
    children.L = flipy!(R)

    return tile
end

Base.@inline function connect!(tile, other_tile, B)
    setproperty!(tile.child_connections, B, other_tile)
    setproperty!(other_tile.parent_connections, opposite(B), tile)
    return tile
end


## Solution functions
function set_matches!(tile_set, unused_tiles=copy(tile_set))
    connected_tiles = Dict(pop!(unused_tiles))
    while !isempty(unused_tiles)
        for (this_id, this_tile) in connected_tiles
            for b in BORDERS
                getproperty(this_tile.child_connections, b) !== nothing && continue
                this_border = get_border(this_tile, b)
                opp_b = opposite(b)
                for (id, tile) in unused_tiles
                    connected = false
                    for rot in 1:4
                        rotate!(tile)
                        for flip in 1:2
                            flipy!(tile)
                            getproperty(tile.child_connections, opp_b) !== nothing && continue
                            if get_border(tile, opp_b) == this_border
                                # println("Connecting $id to $this_id")
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

const x̂ = (0, 1)
const ŷ = (1, 0)

_layout_image!(image, ::Nothing, idx) = nothing

function _layout_image!(image, tile, idx=(0, 0))
    tile in values(image) && return image
    push!(image, idx=>tile)

    @unpack L, R, U, D = tile.child_connections
    _layout_image!(image, R, idx .+ x̂)
    _layout_image!(image, L, idx .- x̂)
    _layout_image!(image, U, idx .- ŷ)
    _layout_image!(image, D, idx .+ ŷ)

    return image
end

layout_image(tiles) = _layout_image!(Dict{Tuple{Int, Int}, Tile}(), first(values(tiles)))

function concatenate_image(layout; keep_borders=false)
    sz_i, sz_j = size(last(first(layout)).image) .- 2
    inds = keys(layout)
    min_i, max_i = extrema(first.(inds))
    min_j, max_j = extrema(last.(inds))
    ax = axes(layout[1,1].image)
    ax = keep_borders ? ax : (ax[1][2:end-1], ax[2][2:end-1])

    block_image = [layout[i, j][ax...] for i in min_i:max_i, j in min_j:max_j]
    cols = reduce.(vcat, eachcol(block_image))
    image = reduce(hcat, cols)

    # image = falses(sz_i*(max_i-min_i+1), sz_j*(max_j-min_j+1))
    # for (i, j) in inds
    #     i_range = (i-min_i)*sz_i .+ (1:sz_i)
    #     j_range = (j-min_j)*sz_j .+ (1:sz_j)
    #     image[i_range, j_range] .= layout[i, j][2:end-1, 2:end-1]
    # end

    
    return Tile(; image)
end

# Part 1
function get_solution1(data)
    tiles = set_matches!(deepcopy(data))
    image = layout_image(tiles)
    inds = keys(image)
    return prod(image[i, j].id for i in extrema(first.(inds)), j in extrema(last.(inds)))
end

# Part 2
function sea_monster_image()
    str = """
                      # 
    #    ##    ##    ###
     #  #  #  #  #  #   
    """
    image = lines_to_image(split(str, r"\n|\r\n", keepempty=false)) |> collect
end

function get_solution2(data)
    tiles = set_matches!(deepcopy(data))
    image = concatenate_image(layout_image(tiles))
    sea_monster = sea_monster_image()
    sz_sm_i, sz_sm_j = size(sea_monster)
    sz_im_i, sz_im_j = size(image)
    count_sea_monster = count(sea_monster)
    last_i = sz_im_i - sz_sm_i + 1
    last_j = sz_im_j - sz_sm_j + 1
    num_waters = Int[]
    this_image = falses(size(image)...)
    num_sea_monsters = 0
    for rot in 1:4
        rotate!(image)
        for flip in 1:2
            flipy!(image)
            this_image .= image
            for j in 1:last_j, i in 1:last_i
                i_range = i:i+sz_sm_i-1
                j_range = j:j+sz_sm_j-1
                this_sub_image = @view this_image[i_range, j_range]
                this_num_waters = count(this_sub_image .& sea_monster)
                # println("($i_range, $j_range)")
                if (i, j) == (17, 2)
                    # println("rot=$(mod(rot, 4)), flip=$(mod(flip, 2))")
                    # show(stdout, MIME("text/plain"), Tile(; id=0, image=this_image[i_range, :]))
                end
                if this_num_waters == count_sea_monster
                    # println("($i_range, $j_range)")
                    # show(stdout, MIME("text/plain"), image)
                    num_sea_monsters += 1
                end
            end
        end
    end
    return count(image) - num_sea_monsters*count_sea_monster
end

# 303 too low

end