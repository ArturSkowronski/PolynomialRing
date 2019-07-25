# PolyRing

Implements a type of **polynomial of one variable** together with common arithemtic
operations af addition and multiplication (both poly-poly & poly-number).

## Constructor

**Poly{T<:Number}(coeffs::AbstractVector{T})**

```julia
julia> Poly([1,2,1])
Poly{Int64}([1, 2, 1])

julia> Poly([1,2//1,1])
Poly{Rational{Int64}}(Rational{Int64}[1//1, 2//1, 1//1])
```

## Methods (algebra & comparisons)

### +,-,*,/,==, isapprox, diverem, div, rem

## Other methods

### peval{p::Poly, n::Number)

```julia
julia> Poly([1,2,1])
Poly{Int64}([1, 2, 1])

julia> peval(p, 1)
4

julia> peval(p, -1//1)
0//1
```

### roots(p::Poly)

```julia
julia> p = Poly([1,2,1])
Poly{Int64}([1, 2, 1])

julia> roots(p)
2-element Array{Float64,1}:
 -0.9999999999999999
 -0.9999999999999999

julia> q = Poly([1,1,1])
Poly{Int64}([1, 1, 1])

julia> roots(q)
2-element Array{Complex{Float64},1}:
 -0.49999999999999994 + 0.8660254037844386im
 -0.49999999999999994 - 0.8660254037844386im
```
