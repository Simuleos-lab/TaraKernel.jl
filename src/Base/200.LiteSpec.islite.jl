# --- MARK: islite_literal

islite_literal(x::Nothing) = true
islite_literal(x::Bool) = true
islite_literal(x::Integer) = true
islite_literal(x::AbstractFloat) = true
islite_literal(x::AbstractString) = true
islite_literal(x::Symbol) = true

# base
islite_literal(x::Any) = false

# --- MARK: islite

# --- MARK: islite: arrays-like
islite(c::AbstractArray) = all(islite, values(c))
islite(c::Tuple) = all(islite, values(c))

# --- MARK: islite: dict-like
islite(c::NamedTuple) = all(islite, values(c))
islite(c::AbstractDict{String, Any}) = all(islite, values(c))

# --- MARK: islite: base
islite(x::Any) = islite_literal(x)

# --- MARK: find_nonlite
## Find a non-lite value and track its path
## - mostly for debbuging and pretty error printing

_subpath(::AbstractDict{String, Any}, path, k) = string(path, "[\"", k, "\"]")
_subpath(::AbstractArray, path, k) = string(path, "[", k, "]")
_subpath(::Tuple, path, k) = string(path, "(", k, ")")
_subpath(::NamedTuple, path, k) = string(path, "[", k, "]")

function __find_nonlite(c, path)
    for (k, v) in pairs(c)
        subpath = _subpath(c, path, k)
        ret = _find_nonlite(v, subpath)
        isnothing(ret) || return ret
    end
    return nothing
end

function _find_nonlite(x, path::AbstractString)
    islite_literal(x) && return nothing
    return (path, x)
end

_find_nonlite(
    c::AbstractArray, 
    path::AbstractString
) = 
    __find_nonlite(c, path)

_find_nonlite(
    c::AbstractDict{String, Any}, 
    path::AbstractString
) = 
    __find_nonlite(c, path)


# Tuples
_find_nonlite(
    c::Tuple, 
    path::AbstractString
) = 
    __find_nonlite(c, path)

# NamedTuples
_find_nonlite(
    c::NamedTuple, 
    path::AbstractString
) =
    __find_nonlite(c, path)
    

# 5. Fallback: scalar / leaf value
find_nonlite(x, path::AbstractString) = _find_nonlite(x, path)

find_nonlite(x) = find_nonlite(x, "obj")

# --- MARK: ensure_lite
function ensure_lite(x)
    islite(x) && return x
    
    ret = find_nonlite(x)
    @assert !isnothing(ret)
    
    path, x = ret
    T = typeof(x)
    # For debugging, you can also append `, value = $(repr(x))`
    # but that can be very verbose for big objects.
    msg = "ensure_lite: found non-lite value at:\n $(path)::$(T)"
    throw(ArgumentError(msg))
end