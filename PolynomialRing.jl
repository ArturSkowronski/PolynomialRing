module PolynomialRing


export Poly


struct Poly{T}
    coeffs::Vector{T}
    function Poly(coeffs::AbstractVector{T}) where {T<:Number}
        if length(coeffs) == 0
            return new{T}(zeros(T, 1))
        else
            last_nonz = findlast(!iszero, coeffs)
            return new{T}(last_nonz === nothing ? coeffs[1] : coeffs[1:last_nonz])
        end
    end
end

Poly(n::Number) = Poly([n])  # convert number into constant poly

# promoting type if the type of Poly and Vector do not match:
function Poly{T}(x::AbstractVector{S}) where {T, S}
    U = promote_type(T, S)
    return Poly(convert(Vector{U}, x))
end




end