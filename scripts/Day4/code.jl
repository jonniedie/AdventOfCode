module Day4
export get_inputs, get_solution1, get_solution2

using DataFrames
using UnPack

## Input getting
maybe_parse(T, x) = x
maybe_parse(T, str::AbstractString) = parse(T, str)

fill_columns(arr_pair) = fill_columns(; arr_pair...)
function fill_columns(;
               byr=missing,
               iyr=missing,
               eyr=missing,
               hgt=missing,
               hcl=missing,
               ecl=missing,
               pid=missing,
               cid=missing)
    return (;
        byr = maybe_parse(Int, byr),
        iyr = maybe_parse(Int, iyr),
        eyr = maybe_parse(Int, eyr),
        hgt,
        hcl,
        ecl = ismissing(ecl) ? missing : Symbol(ecl),
        pid,
        cid
    )
end

parse_passport(str) = split.(split(str), ":") .|> (x->Symbol(x[1])=>x[2])

function read_input(f_name)
    passports = split(read(f_name, String), "\n\n") .|> parse_passport .|> fill_columns
    return DataFrame(passports)
end

function get_inputs()
    test_input1 = read_input(joinpath(@__DIR__, "test_input1.txt"))
    test_input2 = read_input(joinpath(@__DIR__, "test_input2.txt"))
    test_output1 = 2
    test_output2 = 4
    data = read_input(joinpath(@__DIR__, "input.txt"))
    return (; test_input1, test_input2, test_output1, test_output2, data)
end


## Solution functions
# Part 1
is_valid1(passport) = all(.!ismissing.(getproperty.(Ref(passport), (:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid))))

get_solution1(data) = count(is_valid1, eachrow(data))

# Part 2
function is_valid2(passport)
    @unpack byr, iyr, eyr, hgt, hcl, ecl, pid, cid = passport

    !is_valid1(passport) && return false

    hgt = if contains(hgt, "cm")
        (num=parse(Int, String(hgt[1:end-2])), unit="cm")
    elseif contains(hgt, "in")
        (num=parse(Int, String(hgt[1:end-2])), unit="in")
    else
        return false
    end
    
    return (
        ndigits(byr)==4 && 1920≤byr≤2002 &&
        ndigits(iyr)==4 && 2010≤iyr≤2020 &&
        ndigits(eyr)==4 && 2020≤eyr≤2030 &&
        ((hgt.unit=="cm" && 150≤hgt.num≤193) || (hgt.unit=="in" && 59≤hgt.num≤76)) &&
        hcl[1]=='#' && length(hcl)==7 && all((islowercase(x)||isnumeric(x)) && ('0'≤x≤'9' || 'a'≤x≤'f') for x in hcl[2:end]) && 
        any(ecl .== (:amb, :blu, :brn, :gry, :grn, :hzl, :oth)) &&
        length(pid)==9
    )
end

get_solution2(data) = count(is_valid2, eachrow(data))

end