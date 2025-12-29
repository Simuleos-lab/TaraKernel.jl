# --- MARK: _tk_islite_literal

_tk_islite_literal(x::Nothing) = true
_tk_islite_literal(x::Bool) = true
_tk_islite_literal(x::Integer) = true
_tk_islite_literal(x::AbstractFloat) = true
_tk_islite_literal(x::AbstractString) = true
_tk_islite_literal(x::Symbol) = true

# base
_tk_islite_literal(x::Any) = false

tk_islite_literal(x) = _tk_islite_literal(x)

# --- MARK: _tk_islite

# --- MARK: _tk_islite: arrays-like
_tk_islite(c::AbstractVector) = all(_tk_islite, values(c))
_tk_islite(c::Tuple) = all(_tk_islite, values(c))

# --- MARK: _tk_islite: dict-like
_tk_islite(c::NamedTuple) = all(_tk_islite, values(c))
_tk_islite(c::AbstractDict{String, Any}) = all(_tk_islite, values(c))

# --- MARK: _tk_islite: base
_tk_islite(x::Any) = _tk_islite_literal(x)

tk_islite(x) = _tk_islite(x)

# --- MARK: find_nonlite
## Find a non-lite value and track its path
## - mostly for debbuging and pretty error printing

_subpath(::AbstractDict{String, Any}, path, k) = string(path, "[\"", k, "\"]")
_subpath(::AbstractVector, path, k) = string(path, "[", k, "]")
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
    _tk_islite_literal(x) && return nothing
    return (path, x)
end

_find_nonlite(
    c::AbstractVector, 
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

# --- MARK: _tk_ensure_lite
function _tk_ensure_lite(x)
    _tk_islite(x) && return x
    
    # error branch
    ret = find_nonlite(x)
    @assert !isnothing(ret)
    
    path, x = ret
    T = typeof(x)
    # For debugging, you can also append `, value = $(repr(x))`
    # but that can be very verbose for big objects.
    msg = "_tk_ensure_lite: found non-lite value at:\n $(path)::$(T)"
    throw(ArgumentError(msg))
end

tk_ensure_lite(x) = _tk_ensure_lite(x)

# assume flattened
# --- MARK: _find_deep
function _tk_find_deep(d)
    for (k, v) in pairs(d)
        if (length(split(k, "/")) > 10)
            return (k, v)
        end
    end

    return nothing  
end

# --- MARK: _ensure_shallow
function _tk_ensure_shallow(x)
    # error branch
    ret = _tk_find_deep(x)
    isnothing(ret) && return x
    
    k, v = ret
    T = typeof(v)
    # For debugging, you can also append `, value = $(repr(x))`
    # but that can be very verbose for big objects.
    msg = "_tk_find_deep: found non-shallow value at:\n $(k)::$(T)"
    throw(ArgumentError(msg))
end