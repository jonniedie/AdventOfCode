using Test, Advent2020
using Advent2020.Day1

test_data = [1721, 979, 366, 299, 675, 1456]

@testset "Test data" begin 
    @test solution1(test_data) == 514579
    @test solution2(test_data) == 241861950
end