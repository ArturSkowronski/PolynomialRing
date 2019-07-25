include("tmp.jl")
import .Tmp

# using BenchmarkTools

# println(Tmp.Poly(1)==Tmp.Poly(1)) # need to implement ==
# println(Tmp.Poly(Int32(1)) == Tmp.Poly([1])) # prints true, and should not? it is ok, as 2 == 2.0
# println(Tmp.Poly(1) === Tmp.Poly(1)) # overloading === is forbidden
# println(Tmp.Poly(Int32(1)) === Tmp.Poly([1]))

# println(Tmp.Poly(1))
# println(Tmp.Poly([1,2.0]))
# println(Tmp.Poly([1,2,3,4,5]))
# println(Tmp.Poly([1,2,3,4,5,0])) # Get rid of the zero!
# println(Tmp.Poly([])) # does not work, array is of type 'Any'
# println(Tmp.Poly([1,2,3,0,0,0,0])[end]) #no

# println(Vector{Int32}([]))
# println(Vector{Int64}([]))
# println(Tmp.Poly(Vector{Int32}([])))
# println(Tmp.Poly(Vector{Int64}([]))) # deafult-size types are not printd

# println(lastindex([1,2,3,4,5,0]))
# a = [1,2,3,4,5,0]
# a = [0,0]
# last_nonz_a = findlast(!iszero, a)
# println(last_nonz_a==nothing ? a[1] : a[1:last_nonz_a])

# p = Tmp.Poly(Vector{Int32}([]))
# println(p)
# p.coeffs[1] = 3
# println(p) # modified
# p = Tmp.Poly([1,1,1,1,1])
# n = Int32(1)
# println(p.a)
# println(Tmp.peval(p, n))
# println(typeof(Tmp.peval(p, n))) # ok now

# p = Tmp.Poly{Int32}
# println(p)
# n = 2
# println(Tmp.peval(p, n))

# p = []
# n = 1
# println(p*n) # result is Any[] 0-element Array{Any,1}

# println(Tmp.Poly{Int32})
# println(Tmp.Poly{Int32}([1.0])) # no method for that

# pEmpty = Tmp.Poly(Vector{Int32}([]))
# p0 = Tmp.Poly(1)
# p1 = Tmp.Poly([0,1//1])
# p2 = Tmp.Poly([1,-2,1])
# p3 = Tmp.Poly([1,2,1])
# p4 = Tmp.Poly([0,0,1])
# p5 = Tmp.Poly([1,0,-1])
# p6 = Tmp.Poly([1])
# p7 = Tmp.Poly([3,2,6,7,5])
# p8 = Tmp.Poly([1,2,3])

# # println(divrem(p4,p1))
# # println(divrem(p5,p1))
# println(divrem(p8,p0))

# println(p0*p3)
# println(p0*p2)
# println(p4*p3)
# println(p4*p7)
# println(p7*p3)

# @code_warntype p4*p3

# println(p3)
# println(p4)
# p4*p3
# println(p3)
# println(p4)


# println(pEmpty + 1 == Tmp.Poly(1))
# println(p0 + 1 == Tmp.Poly(2))
# println(p1 + 1 == Tmp.Poly([1,1]))
# println(p2 + 1 == Tmp.Poly([1,0,1]))
# println(p3 + 1 == Tmp.Poly([2,1,1]))
# println(p4 + 24.1 == Tmp.Poly([25.1, 1]))
# println(p5 + 3//4 == Tmp.Poly([3//4, 0,0,0,2,1]))
# println(pEmpty)
# println(p0)
# println(p1) # modif / not anymore modif
# println(p2) # modif / not anymore modif
# println(p3) # modif / not anymore modif
# println(p4)
# println(p5)

# a = [1,1,1]
# b = [1,0,0,0]
# b = [1,1,1,1]

# println([a[i] + b[i] for i = 0:max(length(a),length(b))]) # no
# println(a+b) # no
# println(promote_shape(a,b))




# p = Tmp.Poly(rand(Float64,5))
# n = rand()
# @benchmark Tmp.plus1($p,$n)
# println()
# @benchmark Tmp.plus2($p,$n)

# a=[1,2,3,4,5]
# b=[2,3,4,1]

# println(Tmp.companion(a))
# println(Tmp.companion(b))

# println(Tmp.companion(p1))
# println(Tmp.companion(p2))
# println(Tmp.companion(p3))
# println(Tmp.companion(p4))
# println(Tmp.companion(p5))

# println(Tmp.roots(p1))
# println(Tmp.roots(p2))
# println(Tmp.roots(p3))
# println(Tmp.roots(p4))
# println(Tmp.roots(p5))
# # println(typeof(Tmp.roots(p6)))

# p4 = Tmp.Poly([1.0, 1])
# p5 = Tmp.Poly([0,0,0,0,2,1])
# p6 = Tmp.Poly([1,2,1])

# divrem(p6,p4)
