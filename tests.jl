include("tmp.jl")

import .Tmp
using Test

p00 = Tmp.Poly(0)
pEmpty = Tmp.Poly(Vector{Int32}([]))
p0 = Tmp.Poly(1)
p1 = Tmp.Poly([0,1//1])  # passing rational here yields weird behaviour
p2 = Tmp.Poly([0,0, 1])
p3 = Tmp.Poly([1,1,1])
p4 = Tmp.Poly([1.0, 1])
p5 = Tmp.Poly([0,0,0,0,2,1])

@testset "defining polynomials" begin
    @test Tmp.Poly(1) == Tmp.Poly([1])
    @test Tmp.Poly(Int32(1)) == Tmp.Poly([1])
    @test Tmp.Poly(Int32(1)) == Tmp.Poly(Int64[1]) # as [1] == [1.0]
    @test Tmp.Poly(1) == Tmp.Poly([1, 0, 0, 0])
    @test Tmp.Poly([1.0, 2, 3]) == Tmp.Poly([1, 2, 3])
    @test Tmp.Poly{Int32}([1.0]) == Tmp.Poly(1)
end
@testset "polynomial evaluation" begin
    pEmpty = Tmp.Poly(Vector{Int32}([]))
    p0 = Tmp.Poly(1)
    p1 = Tmp.Poly([0,1//1])
    p2 = Tmp.Poly([0,0,1])
    p3 = Tmp.Poly([1,1,1])
    p4 = Tmp.Poly([1,1])
    p5 = Tmp.Poly([0,0,0,0,2,1])

    @test Tmp.peval(p0, 0) == 1
    @test Tmp.peval(p0, 2) == 1
    @test Tmp.peval(p1, 0) == 0
    @test Tmp.peval(p1, 1//1) == 1
    @test Tmp.peval(p1, 2) == 2
    @test Tmp.peval(p1, 3) == 3
    @test Tmp.peval(p2, 0) == 0
    @test Tmp.peval(p2, 1) == 1
    @test Tmp.peval(p2, 2) == 4
    @test Tmp.peval(p2, √2) ≈ 2
    @test Tmp.peval(p2, 3.0) == 9
    @test Tmp.peval(p3, 0) == 1
    @test Tmp.peval(p3, 1.0) == 3
    @test Tmp.peval(p3, 2) == 7
    @test Tmp.peval(p3, 3) == 13
    @test Tmp.peval(p4, -1) == 0
    @test Tmp.peval(p5, -1) == 1
    @test Tmp.peval(p5, 1) == 3
    @test Tmp.peval(p5, 2) == 64
    @test Tmp.peval(p5, -2.0) == 0
    @test Tmp.peval(pEmpty, -1) == 0
    @test Tmp.peval(pEmpty, 4) == 0
    @test Tmp.peval(pEmpty, 2//4) == 0
end
@testset "polynomial addition" begin
    @testset "poly + number" begin
        @test pEmpty + 1 == Tmp.Poly(1)
        @test p0 + 1 == Tmp.Poly(2)
        @test p1 + 1 == Tmp.Poly([1,1])
        @test p2 + 1 == Tmp.Poly([1,0,1])
        @test p3 + 1 == Tmp.Poly([2,1,1])
        @test p4 + 24.1 == Tmp.Poly([25.1, 1])
        @test p5 + 3//4 == Tmp.Poly([3//4, 0,0,0,2,1])
    end
    @testset "number + poly" begin
        @test 1 + pEmpty == Tmp.Poly(1)
        @test 1 + p0 == Tmp.Poly(2)
        @test 2 + p1 == Tmp.Poly([2,1])
        @test 1 + p2 == Tmp.Poly([1,0,1])
        @test 1 + p3 == Tmp.Poly([2,1,1])
        @test 24.1 + p4 == Tmp.Poly([25.1, 1])
        @test 3//4 + p5 == Tmp.Poly([3//4, 0,0,0,2,1])
    end
    @testset "poly + poly" begin
        @test pEmpty+p0 == Tmp.Poly(1)
        @test p0+p1 == Tmp.Poly([1,1])
        @test p1+p2 == Tmp.Poly([0,1,1])
        @test p2+p3 == Tmp.Poly([1,1,2])
        @test p3+p4 == Tmp.Poly([2,2,1])
        @test p4+p5 == Tmp.Poly([1,1,0,0,2,1])
    end
end
@testset "polynomial subtraction" begin
    @testset "-poly" begin
        @test -p00 == p00
        @test -pEmpty == Tmp.Poly(Vector{Int32}([]))
        @test -p0 == Tmp.Poly(-1)
        @test -p1 == Tmp.Poly([0,-1])
        @test -p2 == Tmp.Poly([-0,0,-1])
        @test -p3 == Tmp.Poly([-1,-1,-1])
        @test -p4 == Tmp.Poly([-1.0,-1])
        @test -p5 == Tmp.Poly([-0,0,0,0,-2,-1])
    end
    @testset "poly - numb" begin
        @test pEmpty - 1 == Tmp.Poly(-1)
        @test p0 - 1 == Tmp.Poly(0)
        @test p1 - 1 == Tmp.Poly([-1,1])
        @test p2 - 1 == Tmp.Poly([-1,0,1])
        @test p3 - 1 == Tmp.Poly([0,1,1])
        @test p4 - 24.1 == Tmp.Poly([-23.1, 1])
        @test p5 - 3//4 == Tmp.Poly([-3//4, 0,0,0,2,1])
    end
    @testset "number + poly" begin
        @test 1 - pEmpty == Tmp.Poly(1)
        @test 1 - p0 == Tmp.Poly(0)
        @test 2 - p1 == Tmp.Poly([2,-1])
        @test 1 - p2 == Tmp.Poly([1,0,-1])
        @test 1 - p3 == Tmp.Poly([0,-1,-1])
        @test 24.1 - p4 == Tmp.Poly([23.1, -1])
        @test 3//4 - p5 == Tmp.Poly([3//4, 0,0,0,-2,-1])
    end
    @testset "poly + poly" begin
        @test pEmpty-p0 == Tmp.Poly(-1)
        @test -p0-p1 == Tmp.Poly([-1,-1])
        @test p1-p2 == Tmp.Poly([0,1,-1])
        @test p2-p3 == Tmp.Poly([-1,-1,0])
        @test p3-p4 == Tmp.Poly([0,0,1])
        @test p4-p5 == Tmp.Poly([1,1,0,0,-2,-1])
        @test -p1-p2 == Tmp.Poly([0,-1,-1])
    end
end