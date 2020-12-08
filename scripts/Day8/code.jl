module Day8

export get_inputs, get_solution1, get_solution2

using ..Machines: read_instructions, run_tape, Machine


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_instructions(IOBuffer("""
        nop +0
        acc +1
        jmp +4
        acc +3
        jmp -3
        acc -99
        acc +1
        jmp -4
        acc +6
    """))
    test_output1 = 5
    test_output2 = 8
    data = read_instructions(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Part 1
infinitely_looping(machine) = machine.current_line in machine.lines_visited

get_solution1(tape) = run_tape(tape, halt_condition=infinitely_looping)[1].accumulator


# Part 2
function run_until_valid(tape)
    new_tape = copy(tape)

    for i in eachindex(tape)
        f, args = new_tape[i]

        if f == :nop
            new_tape[i] = (:jmp, args)
        elseif f == :jmp
            new_tape[i] = (:nop, args)
        end

        machine, halted = run_tape(new_tape, halt_condition=infinitely_looping)
        new_tape[i] = tape[i]

        !halted && return machine, i
    end

    return Machine(), -99
end

get_solution2(tape) = run_until_valid(tape)[1].accumulator

end

#=
Test Summary: | Pass  Total
Input tests   |    2      2
Solution 1: 2051
  0.000032 seconds (10 allocations: 4.328 KiB)
Solution 2: 2304
  0.003705 seconds (2.88 k allocations: 1.332 MiB)
=#