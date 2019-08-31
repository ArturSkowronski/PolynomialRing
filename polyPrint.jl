#################################################
##
## Displaying

import Base: show


# how does a monomial look:
# sign  coeff  "*"  "x"  "^"  exponent


isneg(coeff::T) where {T} = (coeff < zero(T))
function isneg(coeff::Complex{T}) where {T}
    real(coeff) < 0 && return true
    (real(coeff) == 0 && imag(coeff) < 0) && return true
    return false
end

function printSign(io::IO, coeff::T, first::Bool) where {T}
    neg = isneg(coeff)
    if first
        neg && print(io, "- ")
        first = false
    else
        neg ? print(io, " - ") : print(io, " + ")
        first = false
    end
    # there is a need to change the sign of coeff
    coeff =  (neg ? -coeff : coeff)
    return coeff, first
end

function printMonomial(io::IO, j)
    j == 0 && return
    print(io, "x")
    j == 1 || print(io, "^", j)
end

function printCoeff(io::IO, coeff::Number, j)
    (!isone(coeff) || j==0) && print(io, "(", coeff, ")") 
    printMonomial(io, j)
end

function printCoeff(io::IO, coeff::Complex{T}, j) where {T}
    realnz = !iszero(real(coeff))
    imagnz = !iszero(imag(coeff))

    if realnz & imagnz
        print(io, "(", coeff, ")")
        printMonomial(io, j)
    elseif realnz
        (!isone(real(coeff)) || j==0) && print(io, "(", real(coeff), ")")
        printMonomial(io, j)
    elseif imagnz
        !isone(imag(coeff)) ? print(io, "(", imag(coeff), im, ")") : print(io, "(", im, ")")
        printMonomial(io, j)
    else
        return
    end
end

function polyPrint(io::IO, p::Poly{T}) where {T}
    first = true
    printed = false
    for i in degree(p):-1:0
        if !iszero(p[i])
            coeff, first = printSign(io, p[i], first)
            printCoeff(io, coeff, i)
            printed = true
        end
    end
    (!printed & first) && printCoeff(io, 0 , 0) 
end

show(io::IO, p::Poly{T}) where {T} = polyPrint(io, p) 


# handle complex polys in different way