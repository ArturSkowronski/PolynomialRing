include("tmp.jl")

using .Tmp
using Test

pEmpty = Poly(Vector{Int32}([]))
p00 = Poly(0)
p0 = Poly(1)
p1 = Poly([0,1//1])  # passing rational here yields weird behaviour (not anymore)
p2 = Poly([0,0, 1])
p3 = Poly([1,1,1])
p4 = Poly([1.0, 1])
p5 = Poly([0,0,0,0,2,1])
p6 = Poly([1,2,1])
p7 = Poly([1,-2,1])
p8 = Poly([3,2,6,7,5])
p9 = Poly([1,2,3])

@testset "defining polynomials" begin
    @test Poly(0) == Poly([0])
    @test Poly(1) == Poly([1])
    @test Poly(Int32(1)) == Poly([1])
    @test Poly(Int32(1)) == Poly(Int64[1]) # as [1] == [1.0]
    @test Poly(1) == Poly([1, 0, 0, 0])
    @test Poly([1.0, 2, 3]) == Poly([1, 2, 3])
    @test Poly{Int32}([1.0]) == Poly(1)
end
@testset "polynomial evaluation" begin
    @test peval(p0, 0) == 1
    @test peval(p0, 2) == 1
    @test peval(p1, 0) == 0
    @test peval(p1, 1//1) == 1
    @test peval(p1, 2) == 2
    @test peval(p1, 3) == 3
    @test peval(p2, 0) == 0
    @test peval(p2, 1) == 1
    @test peval(p2, 2) == 4
    @test peval(p2, √2) ≈ 2
    @test peval(p2, 3.0) == 9
    @test peval(p3, 0) == 1
    @test peval(p3, 1.0) == 3
    @test peval(p3, 2) == 7
    @test peval(p3, 3) == 13
    @test peval(p4, -1) == 0
    @test peval(p5, -1) == 1
    @test peval(p5, 1) == 3
    @test peval(p5, 2) == 64
    @test peval(p5, -2.0) == 0
    @test peval(pEmpty, -1) == 0
    @test peval(pEmpty, 4) == 0
    @test peval(pEmpty, 2//4) == 0
end
@testset "polynomial addition" begin
    @testset "poly + number" begin
        @test pEmpty + 1 == Poly(1)
        @test p0 + 1 == Poly(2)
        @test p1 + 1 == Poly([1,1])
        @test p2 + 1 == Poly([1,0,1])
        @test p3 + 1 == Poly([2,1,1])
        @test p4 + 24.1 == Poly([25.1, 1])
        @test p5 + 3//4 == Poly([3//4, 0,0,0,2,1])
    end
    @testset "number + poly" begin
        @test 1 + pEmpty == Poly(1)
        @test 1 + p0 == Poly(2)
        @test 2 + p1 == Poly([2,1])
        @test 1 + p2 == Poly([1,0,1])
        @test 1 + p3 == Poly([2,1,1])
        @test 24.1 + p4 == Poly([25.1, 1])
        @test 3//4 + p5 == Poly([3//4, 0,0,0,2,1])
    end
    @testset "poly + poly" begin
        @test pEmpty+p0 == Poly(1)
        @test p0+p1 == Poly([1,1])
        @test p1+p2 == Poly([0,1,1])
        @test p2+p3 == Poly([1,1,2])
        @test p3+p4 == Poly([2,2,1])
        @test p4+p5 == Poly([1,1,0,0,2,1])
    end
end
@testset "polynomial subtraction" begin
    @testset "-poly" begin
        @test -p00 == p00
        @test -pEmpty == Poly(Vector{Int32}([]))
        @test -p0 == Poly(-1)
        @test -p1 == Poly([0,-1])
        @test -p2 == Poly([-0,0,-1])
        @test -p3 == Poly([-1,-1,-1])
        @test -p4 == Poly([-1.0,-1])
        @test -p5 == Poly([-0,0,0,0,-2,-1])
    end
    @testset "poly - numb" begin
        @test pEmpty - 1 == Poly(-1)
        @test p0 - 1 == Poly(0)
        @test p1 - 1 == Poly([-1,1])
        @test p2 - 1 == Poly([-1,0,1])
        @test p3 - 1 == Poly([0,1,1])
        @test p4 - 24.1 == Poly([-23.1, 1])
        @test p5 - 3//4 == Poly([-3//4, 0,0,0,2,1])
    end
    @testset "number + poly" begin
        @test 1 - pEmpty == Poly(1)
        @test 1 - p0 == Poly(0)
        @test 2 - p1 == Poly([2,-1])
        @test 1 - p2 == Poly([1,0,-1])
        @test 1 - p3 == Poly([0,-1,-1])
        @test 24.1 - p4 == Poly([23.1, -1])
        @test 3//4 - p5 == Poly([3//4, 0,0,0,-2,-1])
    end
    @testset "poly + poly" begin
        @test pEmpty-p0 == Poly(-1)
        @test -p0-p1 == Poly([-1,-1])
        @test p1-p2 == Poly([0,1,-1])
        @test p2-p3 == Poly([-1,-1,0])
        @test p3-p4 == Poly([0,0,1])
        @test p4-p5 == Poly([1,1,0,0,-2,-1])
        @test -p1-p2 == Poly([0,-1,-1])
    end
end
@testset "polynomial multiplication" begin
    @testset "poly * poly" begin
        @test p0*p8 == Poly([3,2,6,7,5])
        @test p0*p5 == Poly([0,0,0,0,2,1])
        @test p1*p4 == Poly([0,1,1])
        @test p1*p7 == Poly([0,1,-2,1])
        @test p6*p7 == Poly([1,0,-2,0,1])
        @test p7*p6 == Poly([1,0,-2,0,1])
        @test p6*p9 == Poly([1,4,8,8,3])
    end
    @testset "numb * poly" begin
        @test 5*p00 == Poly(0)
        @test 3*p0 == Poly(3)
        @test 9*p1 == Poly([0,9])
        @test 3//4 * p2 == Poly([0,0, 0.75])
        @test 3.5*p3 == Poly([3.5,3.5,3.5])
        @test 2//1 * p4 == Poly([2, 2])
    end
    @testset "poly * numb" begin
        @test p00*5 == Poly(0)
        @test p0*3 == Poly(3)
        @test p1*9 == Poly([0,9])
        @test p2* 3//4 == Poly([0,0, 0.75])
        @test p3*3.5 == Poly([3.5,3.5,3.5])
        @test p4 * 2//1 == Poly([2, 2])
    end
end
@testset "poly / numb" begin
    @test p00/5 == Poly(0)
    @test p0/3 == Poly(1/3)
    @test p1/9 ≈ Poly([0,1/9])
    @test p2 / 3//4 ≈ Poly([0,0, 4/3])
    @test p3/3.5 == Poly([1/3.5,1/3.5,1/3.5])
    @test p4 / 2//1 == Poly([0.5, 0.5])
end
@testset "roots of polynomials" begin
    @test roots(p00) == Vector{Float64}([])
    @test roots(pEmpty) == Vector{Float64}([])
    @test roots(p0) == Vector{Float64}([])
    @test roots(p1) == [0]
    @test roots(p2) == [0,0]
    @test roots(p3) ≈ [-0.5 + (√3/2)im, -0.5 - (√3/2)im]
    @test roots(p4) == [-1]
    @test roots(p5) == [-2,0,0,0,0]
    @test roots(p6) ≈ [-1,-1]
    @test roots(p7) ≈ [1,1]
end
@testset "poly divrem" begin
    # @test divrem(p1, p0) == (Poly([0,1]), Poly(0))
    # @test divrem(p4, p0) == (Poly([1, 1]), Poly(0))
    # @test divrem(p8, p0) == (Poly([3,2,6,7,5]), Poly(0))
    # @test divrem(p6, p1) == (Poly([2,1]), Poly(1))
    @test divrem(p6, p4) == (Poly([1,1]), Poly(0))
    # @test divrem(p8, p1) == (Poly([2,6,7,5]), Poly(3))
end

@testset "check nothing is overwritten" begin
    @test p00 == Poly(0)
    @test pEmpty == Poly(Vector{Int32}([]))
    @test p0 == Poly(1)
    @test p1 == Poly([0,1//1])  # passing rational here yields weird behaviour
    @test p2 == Poly([0,0, 1])
    @test p3 == Poly([1,1,1])
    @test p4 == Poly([1.0, 1])
    @test p5 == Poly([0,0,0,0,2,1])
    @test p6 == Poly([1,2,1])
    @test p7 == Poly([1,-2,1])
    @test p8 == Poly([3,2,6,7,5])
    @test p9 == Poly([1,2,3])
end