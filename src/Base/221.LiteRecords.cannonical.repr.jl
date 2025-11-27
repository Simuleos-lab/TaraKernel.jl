# Here we will implement the cannonical representation interface


# TODO Move to serialization
# literal_canonstr(x::Nothing) = "null"
# literal_canonstr(x::Bool) = string(x)
# literal_canonstr(x::Integer) = string(x)
# literal_canonstr(x::AbstractFloat) = string(x)
# literal_canonstr(x::AbstractString) = string(x)
# literal_canonstr(x::Symbol) = string(x)

CANONICAL_KEY_SEP = "::"

# TODO
# - finish this

function litekey_canonstr(k) 
    k = string(k)
    # escape sep
    return k
end

# Assume liteness

function _canonize!(
        data::AbstractDict,
        canon::TaraDict, 
        path_vec::Vector{String}
    )

    @show path_vec
    for (k, v) in pairs(data)
        @show k, v
        ck = litekey_canonstr(k) 
        push!(path_vec, ck)
        _canonize!(
            v,
            canon, 
            path_vec
        )    
    end
end

# leaves
function _canonize!(
        data::Any,
        canon::TaraDict, 
        path_vec::Vector{String}
    )
    path = join(path_vec, CANONICAL_KEY_SEP)
    pop!(path_vec)
    canon[path] = data
    return canon
end

function canonize(data::AbstractDict)
    _canonize!(data, TaraDict(), String[])
    return canon
end