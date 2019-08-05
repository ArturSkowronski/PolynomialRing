#################################################
##
## Displaying

# import Base: show
export polyPrint

function polyPrint(p::Poly{T}) where {T}
    first = true
    for i in degree(p):-1:1
        sgn = sign(p[i])
        if sgn == +1
            first || print(" + ")
            print(p[i])
            print("x^")
            print(i)
            first = false
        elseif sgn == -1
            print(" - ")
            print(abs(p[i]))
            print("x^")
            print(i)
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
    print("todo")
end

# handle complex polys in different way