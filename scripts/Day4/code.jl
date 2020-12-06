module Day4

export get_inputs, get_solution1, get_solution2

using UnPack: @unpack


## Input getting
maybe_parse(T, x) = x
maybe_parse(T, str::AbstractString) = parse(T, str)

fill_missing(pair_array) = fill_missing(; pair_array...)
function fill_missing(; byr=missing,
                        iyr=missing,
                        eyr=missing,
                        hgt=missing,
                        hcl=missing,
                        ecl=missing,
                        pid=missing,
                        cid=missing)
    
    byr, iyr, eyr = maybe_parse.(Int, (byr, iyr, eyr))
    ecl = ismissing(ecl) ? missing : Symbol(ecl)
    
    return (; byr, iyr, eyr, hgt, hcl, ecl, pid, cid)
end

parse_passport(str) = split(str) .|>
    Base.Fix2(split, ":") .|>
    (x -> Symbol(x[1]) => x[2]) |>
    fill_missing

read_input(f_name) = read(joinpath(@__DIR__, f_name), String) |>
    Base.Fix2(split, r"\n\n|\r\n\r\n") .|>
    parse_passport

get_inputs() = (;
    test_input1 = read_input("test_input1.txt"),
    test_input2 = read_input("test_input2.txt"),
    test_output1 = 2,
    test_output2 = 4,
    data = read_input("input.txt"),
)


## Solution functions
# Part 1
is_valid1(passport) = all(.!ismissing.(getproperty.(Ref(passport), (:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid))))

get_solution1(data) = count(is_valid1, data)

# Part 2
function is_valid2(passport)
    @unpack byr, iyr, eyr, hgt, hcl, ecl, pid = passport

    return (
        is_valid1(passport) &&
        ndigits(byr)==4 && 1920≤byr≤2002 &&
        ndigits(iyr)==4 && 2010≤iyr≤2020 &&
        ndigits(eyr)==4 && 2020≤eyr≤2030 &&
        (
            (contains(hgt, "cm") && 150 ≤ parse(Int, String(hgt[1:end-2])) ≤ 193) ||
            (contains(hgt, "in") &&  59 ≤ parse(Int, String(hgt[1:end-2])) ≤  76)
        ) &&
        (
            hcl[1]=='#' &&
            length(hcl)==7 &&
            all(('0'≤x≤'9' || 'a'≤x≤'f') for x in hcl[2:end])
        ) && 
        ecl in (:amb, :blu, :brn, :gry, :grn, :hzl, :oth) &&
        length(pid)==9
    )
end

get_solution2(data) = count(is_valid2, data)

end