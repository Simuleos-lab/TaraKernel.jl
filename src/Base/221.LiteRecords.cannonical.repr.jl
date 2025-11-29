# Here we will implement the cannonical representation interface

"""
    jsonpointer(segments::Vector{String}) -> String

Encode a list of path segments into a JSON-Pointer–style path.
Applies the RFC-6901 escape rules:
  '~' becomes '~0'
  '/' becomes '~1'
"""
function jsonpointer(segments::Vector{String})
    io = IOBuffer()
    write(io, '/')  # JSON Pointer always starts with '/'

    for (i, seg) in enumerate(segments)
        # Escape per RFC 6901
        esc_seg = replace(seg, "~" => "~0", "/" => "~1")
        write(io, esc_seg)
        if i < length(segments)
            write(io, '/')   # separator between segments
        end
    end

    return String(take!(io))
end

# Assume liteness

function _safe_pop!(pathbuff)
    isempty(pathbuff) || pop!(pathbuff)
    return nothing
end

function __flatten_col!(
        canon::AbstractDict, 
        data,
        pathbuff::Vector{String}
    )

    for (k, v) in pairs(data)
        push!(pathbuff, string(k))
        __flatten_keys!(canon, v, pathbuff)
        _safe_pop!(pathbuff) # pop done key
    end
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::AbstractDict,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff)
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::AbstractVector,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff)
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::Tuple,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff)
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::NamedTuple,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff)
    return canon
end

# leaves
function __flatten_keys!(
        canon::AbstractDict, 
        data::Any, # anything else is a leaf
        pathbuff::Vector{String}
    )
    path = jsonpointer(pathbuff)
    canon[path] = data
    return canon
end

function canonical(
        data::AbstractDict;
        canon::AbstractDict = LittleDict{String, Any}(), 
        pathbuff::Vector{String} = String[]
    )
    __flatten_keys!(canon, data, pathbuff)
    sort!(canon)
end