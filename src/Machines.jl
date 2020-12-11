module Machines

export Machine, run_tape, read_instructions

using ..Utils: zero_based


## Instruction file parsing
"""
    read_instructions(io)

Read instructions from `io` which can be either a filename or an IOBuffer.
"""
read_instructions(io) = zero_based(parse_line.(readlines(io)))

function parse_line(line)
    f, args = split(line, limit=2)
    f = Symbol(f)
    args = parse.(Int, split(args, keepempty=false))
    return f, (args...,)
end


## Types
"""
# Summary
    mutable struct Machine <: Any
    
# Constructors
    Machine(accumulator, current_line, lines_visited, track)

    Machine(;
        accumulator::Int = 0,
        current_line::Int = 0,
        lines_visited::Vector{Int} = Int[],
        track::Bool = false,
    )

Machine to run instruction tape. Sorta like an intcode machine, but not intcode.
"""
Base.@kwdef mutable struct Machine
    accumulator::Int = 0
    current_line::Int = 0
    lines_visited::Vector{Int} = Int[]
    track::Bool = false
end


# Package up invalid instructions into a nice little error
struct InstructionError{N} <: Exception
    pos::Int
    op::Symbol
    args::NTuple{N,Int}
end

function Base.showerror(io::IO, e::InstructionError)
    arg_str = join([arg<0 ? string(arg) : "+"*string(arg) for arg in e.args], ' ')
    print(io, "InstructionError: Invalid instruction `$(e.op) $arg_str` at position $(e.pos)")
end


## Operations
# Add to accumulator
function acc!(machine, val)
    machine.accumulator += val
    jmp!(machine, 1)
    return machine.accumulator
end

# Jump to relative position
function jmp!(machine, val)
    machine.track && push!(machine.lines_visited, machine.current_line)
    machine.current_line += val
    return -1
end

# No op (do nothing)
function nop!(machine, val)
    jmp!(machine, 1)
    return -1
end


## Actually run things
"""
    run_tape(tape[, machine=Machine(track=true); halt_condition=x->false])

Run instruction tape. Will create a new machine with instruction tracking turned on if no
machine is supplied. A halt condition can also be given with the `halt_condition` keyword.
"""
function run_tape(tape, machine=Machine(track=false); halt_condition=x->false)
    while machine.current_line<length(tape)
        if halt_condition(machine) return machine, true end

        f, args = tape[machine.current_line]
        if f == :acc
            acc!(machine, args...)
        elseif f == :jmp
            jmp!(machine, args...)
        elseif f == :nop
            nop!(machine, args...)
        else
            throw(InstructionError(machine.current_line, f, args))
        end
    end

    return machine, false
end

end