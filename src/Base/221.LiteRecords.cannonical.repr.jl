# Here we will implement the cannonical representation interface

# Assume liteness

function _safe_pop!(pathbuff)
    isempty(pathbuff) || pop!(pathbuff)
    return nothing
end

function __flatten_col!(
        canon::CanonicalTaraDict, 
        data,
        pathbuff::Vector{String}, 
        isvec = false
    )
    if isvec
        i0 = firstindex(data)
    end
    for (k, v) in pairs(data)
        if isvec
            k = k - i0
        end
        push!(pathbuff, string(k))
        __flatten_keys!(canon, v, pathbuff)
        _safe_pop!(pathbuff) # pop done key
    end
    return canon
end

function __obj_sentinel!(
    canon, tag::String, 
    pathbuff::Vector{String}
)
    # TODO/TRIADE think about sentinels
    path = _jsonpointer(pathbuff)
    canon[path] = tag
end

function __flatten_keys!(
        canon::CanonicalTaraDict, 
        data::AbstractDict,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end


function __flatten_keys!(
        canon::CanonicalTaraDict, 
        data::NamedTuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end

function __flatten_keys!(
        canon::CanonicalTaraDict, 
        data::AbstractVector,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end

function __flatten_keys!(
        canon::CanonicalTaraDict, 
        data::Tuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end


# leaves
function __flatten_keys!(
        canon::CanonicalTaraDict, 
        data::Any, # anything else is a leaf
        pathbuff::Vector{String}
    )
    islite_literal(data) || error("Non literal leaf found")
    path = _jsonpointer(pathbuff)
    canon[path] = data
    return canon
end

# Object correctness assumed
function _unsafe_canonical_flatdict!(
        data::AbstractDict,
        canon::CanonicalTaraDict = CanonicalTaraDict();
        pathbuff::Vector{String} = String[]
    )
    __flatten_col!(canon, data, pathbuff, false)
    sort!(canon)
    return canon
end

# Object correctness assumed
function _unsafe_canonical_stringify(canon::CanonicalTaraDict)
    return JSON.json(canon)
end