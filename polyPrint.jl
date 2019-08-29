#################################################
##
## Displaying

# import Base: show
export polyPrint


# how does a monomial look:
# sign  coeff  "*"  "x"  "^"  exponent


isneg(coeff::T) where {T} = (coeff < zero(T))
function(coeff::Complex{T}) where {T}
    real(coeff) < 0 && return true
    (real(coeff) == 0 & imag(coeff) < 0) && return true
    return false
end

function printSign(io::IO, coeff::T, first::Bool) where {T}
    neg = isneg(coeff)
    if first
        neg && print(io, "- ")
    else
        neg ? print(io, " - ") : print(io, "+")
    end
    # there is a need to change the sign of coeff
    return -coeff
end

function printMonomial(io::IO, j)
    j == 0 && return
    print(io, "*x")
    j == 1 || print(io, "^", j)
end

printCoeff(io::IO, coeff::Number) = print(io, coeff)
function printCoeff(io::IO, coeff::Complex{T}) where {T}
    realnz = !iszero(real(coeff))
    imagnz = !iszero(imag(coeff))

    if realnz & imagnz
        print(io, "(", coeff, ")")
    elseif realnz
        print(io, real(coeff))
    elseif imagnz
        print(io, "(", imag(coeff), im, ")")
    else
        return
    end
end


    

function polyPrint(p::Poly{T}) where {T}
    first = true
    for i in degree(p):-1:1  # start from highest exponents
        sgn = sign(p[i])  # determine the exponent of the coeff
        if sgn == +1
            first || print(" + ")
            print(p[i])
            print("x")
            i==1 || print("^", i)
            first = false
        elseif sgn == -1
            print(" - ")
            print(abs(p[i]))
            print("x")
            i==1 || print("^", i)
            first = false
        end
    end

    sgn = sign(p[0])
    if sgn == +1
        first || print(" + ")
        print(p[0])
    elseif sgn == -1
        print(" - ")
        print(abs(p[0]))
    else
        first ? print("0") : nothing
    end
end

function polyPrint(p::Poly{T}) where {T<:Complex}
    first = true
    for i in degree(p):-1:1
        ri = reim(p[i])
        sgnre = sign(ri[1])
        sgnim = sign(ri[2])
        if p[i] == 0
            continue 
        elseif sgnre == 0
            if sgnim == +1
                first || print(" + (")
                print(ri[2])
                print("im)x")
                i==1 || print("^", i)
                first = false
            elseif sgnim == -1
                print(" - (")
                print(abs(ri[2]))
                print("im)x")
                i==1 || print("^", i)
                first = false
            end
        elseif sgnre == +1
            if sgnim == 0
                first || print(" + ")
                print(ri[1])
                print("x")
                i==1 || print("^", i)
                first = false
            else
                first || print(" + ")
                print("(")
                print(p[i])
                print(")")
                print("x")
                i==1 || print("^", i)
                first = false
            end
        else
            if sgnim == 0
                print(" - ")
                print(abs(ri[1]))
                print("x")
                i==1 || print("^", i)
                first = false
            else
                print(" - ")
                print("(")
                print(-p[i])
                print(")")
                print("x")
                i==1 || print("^", i)
                first = false
            end
        end
    end

    ri = reim(p[0])
    sgnre = sign(ri[1])
    sgnim = sign(ri[2])
    if sgnre == +1
        if sgnim == 0
            first || print(" + ")
            print(ri[1])
        else
            first || print(" + ")
            print("(")
            print(p[0])
            print(")")
        end
    elseif sgnre == -1
        if sgnim == 0
            print(" - ")
            print(abs(ri[1]))
        else
            print(" - ")
            print("(")
            print(-p[0])
            print(")")
        end
    else
        first ? print("0") : nothing
    end
    print("\n")
end

# handle complex polys in different way