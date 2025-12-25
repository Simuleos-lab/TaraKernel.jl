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

# --- MARK: _tk_islite: arrays-like. n is maximum recursion depth
_tk_islite(c::AbstractVector, n::Int=1) = n == 0 ? false : all(c -> _tk_islite(c, n - 1), values(c))
_tk_islite(c::Tuple, n::Int=1) = n == 0 ? false : all(c -> _tk_islite(c, n - 1), values(c))

# --- MARK: _tk_islite: dict-like
_tk_islite(c::NamedTuple, n::Int=1) = n == 0 ? false : all(c -> _tk_islite(c, n - 1), values(c))
_tk_islite(c::AbstractDict{String, Any}, n::Int=1) = n == 0 ? false : all(c -> _tk_islite(c, n - 1), values(c))

# --- MARK: _tk_islite: base
_tk_islite(x::Any, ::Int) = _tk_islite_literal(x)

tk_islite(x, n) = _tk_islite(x, n)

# --- MARK: find_nonlite
## Find a non-lite value and track its path
## - mostly for debbuging and pretty error printing

_subpath(::AbstractDict{String, Any}, path, k) = string(path, "[\"", k, "\"]")
_subpath(::AbstractVector, path, k) = string(path, "[", k, "]")
_subpath(::Tuple, path, k) = string(path, "(", k, ")")
_subpath(::NamedTuple, path, k) = string(path, "[", k, "]")

function __find_nonlite(c, path, n)
    for (k, v) in pairs(c)
        subpath = _subpath(c, path, k)
        ret = _find_nonlite(v, subpath, n - 1)
        isnothing(ret) || return ret
    end
    return nothing
end

function _find_nonlite(x, path::AbstractString, n::Int)
    n == 0 && return (path, x, :depth_limit)
    _tk_islite_literal(x) && return nothing
    return (path, x, :not_literal)
end

_find_nonlite(
    c::AbstractVector, 
    path::AbstractString,
    n::Int
) = 
    n == 0 ? (path, c, :depth_limit) : __find_nonlite(c, path, n)

_find_nonlite(
    c::AbstractDict{String, Any}, 
    path::AbstractString,
    n::Int
) = 
    n == 0 ? (path, c, :depth_limit) : __find_nonlite(c, path, n)


# Tuples
_find_nonlite(
    c::Tuple, 
    path::AbstractString,
    n::Int
) = 
    n == 0 ? (path, c, :depth_limit) : __find_nonlite(c, path, n)

# NamedTuples
_find_nonlite(
    c::NamedTuple, 
    path::AbstractString,
    n::Int
) =
    n == 0 ? (path, c, :depth_limit) : __find_nonlite(c, path, n)
    

# 5. Fallback: scalar / leaf value
find_nonlite(x, path::AbstractString, n::Int) = _find_nonlite(x, path, n)

find_nonlite(x, n::Int) = find_nonlite(x, "obj", n)

# --- MARK: _tk_ensure_lite
function _tk_ensure_lite(x, n::Int=1)
    _tk_islite(x, n) && return x
    
    # error branch
    ret = find_nonlite(x, n)
    @assert !isnothing(ret)
    
    path, val, reason = ret
    T = typeof(val)
    
    if reason == :depth_limit
        msg = "_tk_ensure_lite: maximum depth ($n) reached at:\n $(path)::$(T)"
    else
        msg = "_tk_ensure_lite: found non-lite value at:\n $(path)::$(T)"
    end
    throw(ArgumentError(msg))
end

tk_ensure_lite(x, n::Int=1) = _tk_ensure_lite(x, n)