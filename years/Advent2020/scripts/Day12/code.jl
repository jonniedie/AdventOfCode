module Day12

export get_inputs, get_solution1, get_solution2


## Input getting
function get_inputs()
    test_input1 = test_input2 = read_inputs("test_input1.txt")
    test_output1 = 25
    test_output2 = 286
    data = read_inputs("input.txt")
    return (; test_input1, test_input2, test_output1, test_output2, data)
end

function read_inputs(f_name)
    lines = readlines(joinpath(@__DIR__, f_name))
    return [Symbol(line[1])=>parse(Int, line[2:end]) for line in lines]
end


## Solution functions
# instruction => (trans, rot)
const move_dict = Dict(
    :N => ( im,   0),
    :S => (-im,   0),
    :E => (  1,   0),
    :W => ( -1,   0),
    :L => (  0,  im),
    :R => (  0, -im),
)

Base.@kwdef mutable struct Ship
    pos::Complex{Int} = 0
    dir::Complex{Int} = 1
    waypoint::Complex{Int} = 10+im
end

function get_solution(data, fun=move!)
    ship = Ship()
    for line in data
        fun(ship, line)
    end
    pos = ship.pos
    return abs(pos.re) + abs(pos.im)
end

# Part 1
function move!(ship, (instruction, amount))
    if instruction==:F
        ship.pos += amount * ship.dir
    else
        trans, rot = move_dict[instruction]
        ship.pos += amount * trans
        ship.dir *= rot ^ (amount ÷ 90)
    end
    return ship
end

get_solution1(data) = get_solution(data)

# Part 2
function move_with_waypoint!(ship, (instruction, amount))
    if instruction==:F
        ship.pos += ship.waypoint * amount
    else
        trans, rot = move_dict[instruction]
        ship.waypoint += amount * trans
        ship.waypoint *= rot ^ (amount ÷ 90)
    end
    return ship
end

get_solution2(data) = get_solution(data, move_with_waypoint!)

end