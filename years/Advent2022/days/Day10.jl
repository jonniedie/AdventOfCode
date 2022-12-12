module Day10

using ..Advent2022: split_string_lines, read_input
using Base: Fix1
using Common: matrix_to_string

export get_inputs, get_solution1, get_solution2


## Types
struct Instruction
    op::String
    args::Vector{Int}
end

Base.@kwdef mutable struct CPU
    instructions::Vector{Instruction} = []
    current_instruction::Instruction = Instruction("noop", Int[])
    cycle::Int = 0
    cycles_remaining::Int = 1
    register::Int = 1
end
CPU(instructions::Vector{Instruction}) = CPU(; instructions=deepcopy(instructions))

Base.@kwdef mutable struct CRT
    cpu::CPU = CPU()
    screen::BitMatrix = falses(40, 6)
end
CRT(instructions::Vector{Instruction}) = CRT(; cpu=CPU(instructions))

const CYCLE_TIME = Dict(
    "noop" => 1,
    "addx" => 2,
)


## Input getting
function parse_line(str)
    op, args... = split(str, ' '; keepempty=false)
    return Instruction(op, parse.(Int, args))
end
parse_inputs(str) = split_string_lines(str) .|> parse_line

function get_inputs()
    test_input1 = read_input("10_test1") |> parse_inputs
    test_output1 = 13140
    test_input2 = test_input1
    test_output2 = """
        ##..##..##..##..##..##..##..##..##..##..
        ###...###...###...###...###...###...###.
        ####....####....####....####....####....
        #####.....#####.....#####.....#####.....
        ######......######......######......####
        #######.......#######.......#######.....
        """
    data = read_input(10) |> parse_inputs
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
function load_instruction!(cpu)
    keep_going = true
    if isempty(cpu.instructions)
        keep_going = false
    else
        cpu.current_instruction = popfirst!(cpu.instructions)
        cpu.cycles_remaining = CYCLE_TIME[cpu.current_instruction.op]
    end
    return keep_going
end

function step!(cpu::CPU)
    # Increment cycle count
    cpu.cycle += 1
    cpu.cycles_remaining -= 1

    # If we're at last cycle of an instruction, execute the instruction and
    # load a new one
    keep_going = true
    if cpu.cycles_remaining == 0
        (; op, args) = cpu.current_instruction
        if op == "addx"
            cpu.register += only(args)
        end
        keep_going = load_instruction!(cpu)
    end
    return keep_going
end
function step!(crt::CRT)
    (; cpu, screen) = crt
    (; cycle, register) = cpu

    # If the sprite is on the current column, turn pixel on
    if mod1(cycle, 40) in register .+ (0:2)
        screen[cycle] = true
    end

    # Step the CPU
    keep_going = step!(cpu)
    return keep_going
end

function show_screen(crt::CRT; pretty=false)
    replacer = if pretty
        Dict(true => '█', false => ' ')
    else
        Dict(true => '#', false => '.')
    end
    return matrix_to_string(crt.screen'; replacer=Fix1(getindex, replacer))

end

Base.show(io::IO, crt::CRT) = println(io, show_screen(crt; pretty=true))

function run!(cpu::CPU)
    signal_strength = 0
    keep_going = true
    while keep_going
        keep_going = step!(cpu)
        if cpu.cycle in 20:40:220
            signal_strength += cpu.cycle * cpu.register
        end
    end
    return signal_strength
end
function run!(crt::CRT)
    keep_going = true
    while keep_going
        keep_going = step!(crt)
    end
    return show_screen(crt)
end

# Part 1
get_solution1(instructions) =  CPU(instructions) |> run!

# Part 2
get_solution2(instructions) = CRT(instructions) |> run!

end
