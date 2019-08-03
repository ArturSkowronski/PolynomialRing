module PolyRing


export Poly
export peval, roots

import Base: ==, +, -, *, /, ^, isapprox
import Base: divrem, div, rem
import LinearAlgebra: diagm, eigvals


# https://discourse.julialang.org/t/whats-the-correct-way-of-defining-struct-with-an-integer-parameter/23974
"""
    Poly{T<:Number}(coeffs::AbstractVector{T})

Construct a polynomial from its coefficients `coeffs` (starting from lowers terms).
# E.g. ``p(x) = a_0 + a_1 x + \\dotsb + a_n x^n`` is  constructed via `Poly([a_0, ..., a_n])`.

Arithemtic operations are overloaded to work as in the polynomial ring.

# Examples

```julia
julia> Poly([1,2,1])
Poly{Int64}([1, 2, 1])

julia> Poly([1,2//1,1])
Poly{Rational{Int64}}(Rational{Int64}[1//1, 2//1, 1//1])
```
"""
struct Poly{T}
    coeffs::Vector{T}
    function Poly(coeffs::AbstractVector{T}) where {T<:Number}
        if length(coeffs) == 0
            return new{T}(zeros(T, 1))
        else
            last_nonz = findlast(!iszero, coeffs)
            return new{T}(last_nonz === nothing ? [coeffs[1]] : coeffs[1:last_nonz])
        end
    end
end
Poly(n::Number) = Poly([n])  # numbers are constant polynomials

# This is consistent with with the behaviour of arrays, e.g. Int64[1.0] = Int64[1]
function Poly{T}(x::AbstractVector{S}) where {T, S}
    Poly(convert(Vector{T}, x))
end

#################################################
##
## Useful functions

# evaluation of poly
"""
    peval{p::Poly, n::Number)

Evaluate a polynomial `p` at point `x` (via Horner's method).

# Examples

```julia
julia> Poly([1,2,1])
Poly{Int64}([1, 2, 1])

julia> peval(p, 1)
4

julia> peval(p, -1//1)
0//1
```
"""
function peval(p::Poly{T}, n::S) where {T, S<:Number}
    len = length(p.coeffs)
    U = promote_type(T, S)
    b = convert(U, p.coeffs[end])
    for i in (len-1):-1:1
        b = p.coeffs[i] + b*n
    end
    b
end
(p::Poly)(n) = peval(p, n)


# https://en.wikipedia.org/wiki/Companion_matrix
# Calculates companion matrix
# Leaky definition as we assume a[end] != 0
function companion(a::AbstractVector{T}) where {T<:Number}
    U = promote_type(T, Float64)
    len = length(a)
    den = a[end]  # possibly need of copy()
    comp = diagm(-1 => ones(U, len-2))
    comp[:,len-1] = -a[1:end-1]/den
    comp
end
companion(p::Poly) = companion(p.coeffs)

# calculate roots of poly

# Based on
# https://www.mathworks.com/help/matlab/ref/roots.html#buo5imt-5
# may not be numerically stable!
"""
    roots(p::Poly)

Return zeros of `p` with mulitpilicity (hence the number of roots equals the degree of `p`
and roots may happen to be complex). Result are approximate.

# Examples

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
"""
function roots(p::Poly{T}) where {T<:Number}
    (length(p.coeffs) == 1) ? (return Vector{Float64}([])) : (return eigvals(companion(p)))
end

#################################################
##
## Standard comparison & arithmetic functions overloading
==(p1::Poly, p2::Poly) = (p1.coeffs == p2.coeffs)
==(p::Poly, n::Number) = (p.coeffs == [n])
==(n::Number, p::Poly) = ==(p, n)
isapprox(p1::Poly, p2::Poly) = isapprox(p1.coeffs,p2.coeffs) # works as approximate comparison of arrays


function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = copy(convert(Vector{U}, p.coeffs))
    coeffs1[1] += n
    Poly(coeffs1)
end
+(n::Number, p::Poly)= +(p, n)

function +(p1::Poly{T}, p2::Poly{S}) where {T, S}
    U = promote_type(T, S)
    len = max(length(p1.coeffs), length(p2.coeffs))
    tmp = zeros(U, len)
    for i in 1:length(p1.coeffs)
        tmp[i] += p1.coeffs[i]
    end
    for i in 1:length(p2.coeffs)
        tmp[i] += p2.coeffs[i]
    end
    Poly(tmp)
end


-(p::Poly) = Poly(-p.coeffs)
-(p::Poly, n::Number) = +(p, -n)
-(n::Number, p::Poly) = +(-p, n)
-(p1::Poly, p2::Poly) = +(p1, -p2)


/(p::Poly, n::Number) = Poly(p.coeffs / n)


*(p::Poly, n::Number) = Poly(p.coeffs * n)
*(n::Number, p::Poly) = *(p, n)
function *(p1::Poly{T}, p2::Poly{S}) where {T, S}
    U = promote_type(T, S)
    m = length(p1.coeffs)
    n = length(p2.coeffs)
    cfs = zeros(U, m+n-1)
    for i = 1:m
        for j = 1:n
            cfs[i+j-1] += p1.coeffs[i] * p2.coeffs[j]
        end
    end
    Poly(cfs)
end

# https://stackoverflow.com/questions/49889476/raising-a-matrix-to-a-power-in-julia
^(p::Poly, n::Integer) = Base.power_by_squaring(p, n)


# Based on:
# https://en.wikipedia.org/wiki/Synthetic_division
function divrem(num::Poly{T}, den::Poly{S}) where {T, S}
    d = length(den.coeffs)
    if d == 1
        den.coeffs == [0] ? throw(DivideError()) : (return /(num, den.coeffs[1]), Poly(0))
    end

    U = typeof(one(T)/one(S))
    # U = promote_type(T, S)
    # U = Core.Compiler.return_type(div, Tuple{S, T})
    n = length(num.coeffs)
    deg = n-d
    if deg <0
        # return Poly([0]), Poly(num.coeffs)
        return Poly{U}([0]), Poly{U}(num.coeffs)
    end

    # out = copy(num.coeffs)
    out = copy(convert(Vector{U}, num.coeffs))
    norm = den.coeffs[end]
    for i = n:-1:d
        out[i] /= norm
        coef = out[i]
        if coef != 0
            for j = 1:d-1
                out[i-(d-j)] -= den.coeffs[j]*coef
            end
        end
    end
    return Poly(out[d:end]), Poly(out[1:d-1])
end

div(num::Poly, den::Poly) = divrem(num, den)[1]
rem(num::Poly, den::Poly) = divrem(num, den)[2]


# experiments
include("tmp.jl")

end
