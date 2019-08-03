export divrem1, divrem2, divrem3

function divrem1(num::Poly{T}, den::Poly{S}) where {T, S}
    d = length(den.coeffs)
    if d == 1
        den.coeffs == [0] ? throw(DivideError()) : (return /(num, den.coeffs[1]), Poly(0))
    end

    # U = typeof(one(T)/one(S))
    # U = promote_type(T, S)
    # U = Core.Compiler.return_type(div, Tuple{S, T})
    n = length(num.coeffs)
    deg = n-d
    if deg <0
        return Poly([0]), Poly(num.coeffs)
        # return Poly{U}([0]), Poly{U}(num.coeffs)
    end

    out = copy(num.coeffs)
    # out = copy(convert(Vector{U}, num.coeffs))
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

function divrem2(num::Poly{T}, den::Poly{S}) where {T, S}
    d = length(den.coeffs)
    if d == 1
        den.coeffs == [0] ? throw(DivideError()) : (return /(num, den.coeffs[1]), Poly(0))
    end

    # U = typeof(one(T)/one(S))
    # U = promote_type(T, S)
    U = Core.Compiler.return_type(div, Tuple{S, T})
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

function divrem3(num::Poly{T}, den::Poly{S}) where {T, S}
    d = length(den.coeffs)
    if d == 1
        den.coeffs == [0] ? throw(DivideError()) : (return /(num, den.coeffs[1]), Poly(0))
    end

    # U = typeof(one(T)/one(S))
    U = promote_type(T, S)
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