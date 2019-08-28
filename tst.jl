include("polyRing.jl")


using .PolyRing
using Test

pEmpty = Poly(Vector{Int32}([]))
p00 = Poly(0)
p0 = Poly(1)
p1 = Poly([0,1//1])
p2 = Poly([0,0, 1])
p3 = Poly([1,1,1])
p4 = Poly([1.0, 1])
p5 = Poly([0,0,0,0,2,1])
p6 = Poly([1,2,1])
p7 = Poly([1,-2,1])
p8 = Poly([3,2,6,7,5])
p9 = Poly([1,2.0,3])
p10 = Poly([1,-3,2])
p11 = Poly([-2,2])
p12 = Poly([1, 2+im])
p13 = Poly([1, 2+im, im, 1, 1+im])
p14 = Poly([1, 2-im, im, -1, -1+im])

# @testset "divrems tests" begin
#     @test divrem(p10, p11) == (Poly([-0.5, 1]), Poly(0))
#     @test divrem1(p10, p11) == (Poly([-0.5, 1]), Poly(0))
#     @test divrem2(p10, p11) == (Poly([-0.5, 1]), Poly(0))
#     @test divrem3(p10, p11) == (Poly([-0.5, 1]), Poly(0))
# end

polyPrint(p13)
polyPrint(-p13)
polyPrint(p14)
polyPrint(-p14)