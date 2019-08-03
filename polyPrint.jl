#################################################
##
## Displaying

import Base: show

function polyPrint(p::Poly{T}) where {T}
    for i in p.coeffs
        print(i)
    end
end
