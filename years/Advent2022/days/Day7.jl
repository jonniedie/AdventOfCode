module Day7

using ..Advent2022: split_string_lines, read_input

export get_inputs, get_solution1, get_solution2

## Input getting
struct Command
    head::String
    args::Vector{String}
end

struct TerminalSlug
    command::Command
    outputs::Vector{String}
end

abstract type FileSystemObject end
Base.@kwdef mutable struct Directory <: FileSystemObject
    name::String = "/"
    parent::Any = nothing
    children::Dict{String, Any} = Dict()
    total_size::Int = 0
end
struct File <: FileSystemObject
    name::String
    parent::Directory
    size::Int
end

function _show(io, dir::Directory, prefix="- ")
    println(io, prefix, nameof(dir), " (dir)")
    for key in keys(dir.children)
        _show(io, dir.children[key], "  "*prefix)
    end
end
function _show(io, file::File, prefix)
    println(io, prefix, nameof(file), " (file, size=$(file.size))")
end

function Base.show(io::IO, dir::Directory)
    _show(io, dir)
end

Base.nameof(item::FileSystemObject) = item.name

Base.parent(item::FileSystemObject) = item.parent

Base.getindex(dir::Directory, name::String) = dir.children[name]

function Base.setindex!(dir::Directory, value, name::AbstractString)
    return setindex!(dir.children, value, name)
end

Base.keys(dir::Directory) = keys(dir.children)

Base.haskey(dir::Directory, key) = haskey(dir.children, key)

Base.delete!(dir::Directory, item) = delete!(dir.children, item)

function interpret_slug!(dir, slug)
    (; command, outputs) = slug
    (; head, args) = command
    return if head == "cd"
        cd!(dir, only(args))
    elseif head == "ls"
        ls!(dir, outputs)
    else
        error("how did you get here?")
    end
end

function parse_terminal_slug(str)
    input, outputs... = split_string_lines(str)
    head, args... = split(input, ' '; keepempty=false)
    command = Command(head, args)
    return TerminalSlug(command, outputs)
end

function create_file_system(slugs)
    home_dir = Directory()
    dir = reduce(interpret_slug!, slugs; init=Directory())
    home_dir = go_home(dir)
end

function parse_inputs(str)
    return split(str, raw"$ "; keepempty=false) .|>
        parse_terminal_slug |>
        create_file_system
end

function get_inputs()
    test_input1 = raw"""
        $ cd /
        $ ls
        dir a
        14848514 b.txt
        8504156 c.dat
        dir d
        $ cd a
        $ ls
        dir e
        29116 f
        2557 g
        62596 h.lst
        $ cd e
        $ ls
        584 i
        $ cd ..
        $ cd ..
        $ cd d
        $ ls
        4060174 j
        8033020 d.log
        5626152 d.ext
        7214296 k
        """ |> parse_inputs
    test_output1 = 95437
    test_input2 = test_input1
    test_output2 = 24933642
    data = read_input(7) |> parse_inputs
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
go_home(dir) = _go_home(dir, dir.parent)
_go_home(dir, parent::Nothing) = dir
_go_home(dir, parent::Directory) = _go_home(parent, parent.parent)

Base.pwd(item::FileSystemObject) = _pwd(item, parent(item))
_pwd(item, parent::Nothing) = "/"
_pwd(item, parent::FileSystemObject) = vcat(_pwd(parent, parent.parent), nameof(item))

function cd!(dir, cd_arg)
    return if cd_arg == "/"
        go_home(dir)
    elseif cd_arg == ".."
        dir.parent
    else
        if haskey(dir.children, cd_arg)
            dir[cd_arg] = Directory(name=cd_arg, parent = dir)
        end
        dir[cd_arg]
    end
end

function pass_up_size!(dir::Directory, sz)
    dir.total_size += sz
    pass_up_size!(dir.parent, sz)
    return nothing
end
pass_up_size!(dir::Nothing, sz) = nothing

function ls!(dir, outputs)
    for output in outputs
        args = split(output, ' '; keepempty=false)
        if args[1] == "dir"
            name = args[2]
            if !haskey(dir, name)
                dir[name] = Directory(name=name, parent=dir)
            end
        else
            sz, name = args
            sz = parse(Int, sz)
            dir[name] = File(name, dir, sz)
            pass_up_size!(dir, sz)
        end
    end
    return dir
end

Base.sizeof(file::File) = file.size
function Base.sizeof(dir::Directory)
    current_size = 0
    for key in keys(dir)
        current_size += sizeof(dir[key])
    end
    return current_size
end

function rm!(dir, item_name)
    item = dir[item_name]
    delete!(dir, item_name)
    pass_up_size!(dir, -sizeof(item))
    return nothing
end


# Part 1
function total_score(dir::Directory)
    score = 0
    for child in values(dir.children)
        if child isa Directory && child.total_size <= 100_000
            score += child.total_size
        end
        score += total_score(child)
    end
    return score
end
total_score(file::File) = 0

get_solution1(data) = total_score(data)

# Part 2
const AVAILABLE_SPACE = 70_000_000
const SPACE_TO_FREE = 30_000_000
const UNUSED_SPACE = AVAILABLE_SPACE - sizeof(get_inputs().data)

find_directory_to_delete(file::File, best_size) = best_size
function find_directory_to_delete(dir::Directory, best_size=typemax(Int))
    sz = sizeof(dir)
    if SPACE_TO_FREE - UNUSED_SPACE ≤ sz < best_size
        best_size = sz
    end
    children_best_size = reduce(values(dir.children); init=best_size) do best_size, child
        find_directory_to_delete(child, best_size)
    end
    return min(best_size, children_best_size)
end

function get_solution2(data)
    return find_directory_to_delete(data)
end

end
