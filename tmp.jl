module Tmp


export Poly

# https://discourse.julialang.org/t/whats-the-correct-way-of-defining-struct-with-an-integer-parameter/23974

# automatic conversion of vector takes place
# passing empty vector yields error as there is a need to specify Type<:Number

struct Poly{T}
    a::Vector{T}
    function Poly(a::AbstractVector{T}) where {T<:Number}
        if length(a) == 0
            return new{T}(zeros(T, 1))
        else
            return new{T}(a)
        end
    end
end

Poly(n::Number) = Poly([n])


end

