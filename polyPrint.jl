#################################################
##
## Displaying

# import Base: show
export polyPrint

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