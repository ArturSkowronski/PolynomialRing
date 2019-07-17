module Tmp



export Poly

struct Poly
    a::Vector
end

Poly(n::Number) = Poly([n])

end