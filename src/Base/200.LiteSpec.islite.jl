# --- MARK: islite_literal
islite_literal(x::Nothing) = true
islite_literal(x::Bool) = true
islite_literal(x::Integer) = true
islite_literal(x::AbstractFloat) = true
islite_literal(x::AbstractString) = true
islite_literal(x::Symbol) = true

# base
islite_literal(x::Any) = false

# --- MARK: islite: base
# base
islite(x::Any) = islite_literal(x) || false

# --- MARK: islite: builtin
function islite(t::Tuple)
    @inbounds for x in t
        islite_literal(x) || return false
    end
    return true
end

function islite(nt::NamedTuple)
    @inbounds for x in values(nt)
        islite_literal(x) || return false
    end
    return true
end

function islite(a::AbstractArray)
    @inbounds for x in a
        islite_literal(x) || return false
    end
    return true
end

#### Dicts (JSON-style, string keys)
function islite(d::AbstractDict{K,V}) where {K<:AbstractString, V}
    # TODO/TAI add size control (?)
    @inbounds for (k, v) in d
        # k is already <:AbstractString, so only check the value:
        islite(v) || return false
    end
    return true
end