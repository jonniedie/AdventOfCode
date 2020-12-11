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
infinite_loop(machine) = machine.current_line in machine.lines_visited

get_solution1(tape) = run_tape(tape, Machine(track=true); halt_condition=infinite_loop)[1].accumulator


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

        machine, halted = run_tape(new_tape, Machine(track=true); halt_condition=infinite_loop)
        new_tape[i] = tape[i]

        if !halted
            return machine, i
        end
    end

    return Machine(), -1
end

get_solution2(tape) = run_until_valid(tape)[1].accumulator

end