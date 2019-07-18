include("tmp.jl")
import .Tmp

println(Tmp.Poly(1))
println(Tmp.Poly([1,2.0]))
println(Tmp.Poly([1,2,3,4,5]))
println(Tmp.Poly([1,2,3,4,5,0])) # Get rid of the zero!
# println(Tmp.Poly([])) # does not work, array is of type 'Any'

println(Vector{Int32}([]))
println(Vector{Int64}([]))
println(Tmp.Poly(Vector{Int32}([])))
println(Tmp.Poly(Vector{Int64}([]))) # deafult-size types are not printd
