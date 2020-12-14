module Day13

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_input(IOBuffer(
        """
        939
        7,13,x,x,59,x,31,19
        """
    ))
    test_output1 = 295
    test_output2 = 1068781
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_input(io)
    timestamp, ids = readlines(io)
    return parse(Int, timestamp), split(ids, ',')
end


## Solution functions
# Part 1
parse_input1(ids) = parse.(Int, filter(id -> id != "x", ids))

function get_solution1(data)
    ts, ids = data[1], parse_input1(data[2])
    times = ids .- rem.(ts, ids)
    i = argmin(times)
    return times[i] * ids[i]
end

# Part 2
function parse_input2(input)
    ids = Int[]
    offsets = Int[]
    for (i, val) in enumerate(input)
        if val!="x"
            push!(ids, parse(Int, val))
            push!(offsets, i-1)
        end
    end
    return ids .=> offsets
end

function blah(t, id1, id2, offset)
    id1 % id2 == 0 && return t
    next = (((t ÷ id2) + 1) * id2)
    niters = 0
    while next - t != offset
        t += id1
        next = (((t ÷ id2) + 1) * id2)
        # niters += 1
        # niters > 1000000000 && error("ahhhh! t = $t, id1 = $id1, id2 = $id2")
    end
    return t
end

function get_solution2(data)
    input = data[2]
    outs = parse_input2(input)
    println(outs)
    t = 0
    id1, _ = outs[1]
    for i in 2:length(outs)
        id, offset = outs[i]
        println("$t, $id1, $id, $offset")
        t = blah(t, id1, id, offset)
        id1 = lcm(id1, id)
    end
    return t
end

end