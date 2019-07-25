module Tmp


export Poly
export peval, roots

import Base: ==, +, -, *, /, isapprox
import Base: divrem, div, rem
import LinearAlgebra: diagm, eigvals


# https://discourse.julialang.org/t/whats-the-correct-way-of-defining-struct-with-an-integer-parameter/23974
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

Poly(n::Number) = Poly([n])  # convert number into constant poly

# Promoting type if the type of Poly and Vector do not match
# Or maybe it should convert Vector to the type of Poly?
function Poly{T}(x::AbstractVector{S}) where {T, S}
    U = promote_type(T, S)
    Poly(convert(Vector{U}, x))
end

function peval(p::Poly{T}, n::S) where {T, S<:Number}
    # What should be returned if we pass empty Poly??
    len = length(p.coeffs)
    U = promote_type(T, S)
    b = convert(U, p.coeffs[end])
    for i in (len-1):-1:1
        b = p.coeffs[i] + b*n
    end
    b
end


# https://en.wikipedia.org/wiki/Companion_matrix
# Companion matrix
# Leaky def as we assume a[end] != 0
function companion(a::AbstractVector{T}) where {T<:Number}
    U = promote_type(T, Float64)
    len = length(a)
    den = a[end]  # possibly need of copy()
    comp = diagm(-1 => ones(U, len-2))
    comp[:,len-1] = -a[1:end-1]/den
    comp
end
companion(p::Poly) = companion(p.coeffs)

# https://www.mathworks.com/help/matlab/ref/roots.html#buo5imt-5
function roots(p::Poly{T}) where {T<:Number}
    (length(p.coeffs) == 1) ? (return Vector{Float64}([])) : (return eigvals(companion(p)))
end


# Standard comparison & arithmetic functions overloading
==(p1::Poly, p2::Poly) = (p1.coeffs == p2.coeffs)
==(p::Poly, n::Number) = (p.coeffs == [n])
==(n::Number, p::Poly) = ==(p, n)
isapprox(p1::Poly, p2::Poly) = isapprox(p1.coeffs,p2.coeffs)

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

# Dividing polynomials
# https://en.wikipedia.org/wiki/Synthetic_division
function divrem(num::Poly{T}, den::Poly{S}) where {T, S}
    d = length(den.coeffs)
    if d == 1
        den.coeffs == [0] ? throw(DivideError()) : (return /(num, den.coeffs[1]), Poly(0))
    end

    U = typeof(one(T)/one(S))
    n = length(num.coeffs)
    deg = n-d
    if deg <0
        return Poly{U}([0]), Poly{U}(num.coeffs)
    end

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

end
