module Tmp


export Poly
export peval

import Base: ==, +, -, *, /


# https://discourse.julialang.org/t/whats-the-correct-way-of-defining-struct-with-an-integer-parameter/23974

# automatic conversion of vector takes place
# passing empty vector yields error as there is a need to specify Type<:Number

struct Poly{T}
    coeffs::Vector{T}
    function Poly(coeffs::AbstractVector{T}) where {T<:Number}
        if length(coeffs) == 0
            return new{T}(zeros(T, 1))
        else
            last_nonz = findlast(!iszero, coeffs)
            return new{T}(last_nonz == nothing ? [coeffs[1]] : coeffs[1:last_nonz])
        end
    end
end

Poly(n::Number) = Poly([n])  # convert number into constant poly

# Promoting type if the type of Poly and Vector do not match
# Or maybe it should convert Vector to the type of Poly?
function Poly{T}(x::AbstractVector{S}) where {T, S}
    U = promote_type(T, S)
    return Poly(convert(Vector{U}, x))
end

# range object of form: start:step:stop

function peval(p::Poly{T}, n::S) where {T, S<:Number}
    # What should be returned if we pass empty Poly??
    len = length(p.coeffs)
    U = promote_type(T, S)
    b = convert(U, p.coeffs[end])
    for i in (len-1):-1:1
        b = p.coeffs[i] + b*n
    end
    return b
end

# Standard functions overloading
==(p1::Poly, p2::Poly) = (p1.coeffs == p2.coeffs)

# Question: should n == Poly(n) ?


function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = T==S ? copy(p.coeffs) : copy(convert(Vector{U}, p.coeffs))
    coeffs1[1] += n
    return Poly(coeffs1)
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
    return Poly(tmp)
end

-(p::Poly) = Poly(-p.coeffs)
-(p::Poly, n::Number) = +(p, -n)
-(n::Number, p::Poly) = +(-p, n)
-(p1::Poly, p2::Poly) = +(p1, -p2)

/(p::Poly, n::Number) = Poly(p.coeffs / n)

*(p::Poly, n::Number) = Poly(p.coeffs * n)
*(n::Number, p::Poly) = *(p, n)

end