# Remarks

## `eval` & `copy`

This

```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = convert(Vector{U}, p.coeffs)
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

 behaves in bad way when `T==S`, i.e. it overwrites the original poly with the updated one (not sure why). It works properly when `T\neqS`.

This works fine:

```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = T==S ? copy(p.coeffs) : convert(Vector{U}, p.coeffs)
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

This

```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    coeffs1 = copy(p.coeffs)
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

has problems with (automatic) conversion at all.

## Some performance

This is slightly slower:

```julia
function plus1(p::Poly{T}, n::S) where {T, S<:Number}
    if T==S
        coeffs1 = copy(p.coeffs)
    else
        U = promote_type(T, S)
        coeffs1 = convert(Vector{U}, p.coeffs)
    end
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

than this:

```julia
function plus2(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = T==S ? copy(p.coeffs) : convert(Vector{U}, p.coeffs)
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

Vide:

```julia
julia> @benchmark Tmp.plus1($p,$n)
BenchmarkTools.Trial:
  memory estimate:  272 bytes
  allocs estimate:  3
  --------------
  minimum time:     66.643 ns (0.00% GC)
  median time:      69.987 ns (0.00% GC)
  mean time:        78.966 ns (8.50% GC)
  maximum time:     32.826 μs (99.75% GC)
  --------------
  samples:          10000
  evals/sample:     977
```

and

```julia
julia> @benchmark Tmp.plus2($p,$n)
BenchmarkTools.Trial:
  memory estimate:  272 bytes
  allocs estimate:  3
  --------------
  minimum time:     66.476 ns (0.00% GC)
  median time:      69.823 ns (0.00% GC)
  mean time:        78.069 ns (8.40% GC)
  maximum time:     29.376 μs (99.71% GC)
  --------------
  samples:          10000
  evals/sample:     977
```

## Rational arrays

Rational arrays behave in a very weird way: for some reason some overwriting takes place while adding such arrays (while adding polynomials), thus there is need for additional `copy` after `convert`:

```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = T==S ? copy(p.coeffs) : copy(convert(Vector{U}, p.coeffs))
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

This behaves weird when we have rational poly:
```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    U = promote_type(T, S)
    coeffs1 = T==S ? copy(p.coeffs) : convert(Vector{U}, p.coeffs)
    coeffs1[1] += n
    return Poly(coeffs1)
end
```

## To implement or not to implement

Shall this

```julia
==(p::Poly, n::Number) = (p.coeffs == [n])
==(n::Number, p::Poly) = ==(p, n)
```

be implemented or not?

It should, as this is implemented:

```julia
function +(p::Poly{T}, n::S) where {T, S<:Number}
    [...]
end
+(n::Number, p::Poly)= +(p, n)
```
