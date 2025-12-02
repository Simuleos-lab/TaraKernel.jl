# Here we will implement the cannonical representation interface

# Assume liteness

function _safe_pop!(pathbuff)
    isempty(pathbuff) || pop!(pathbuff)
    return nothing
end

function __flatten_col!(
        canon::AbstractDict, 
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

function __flatten_keys!(
        canon::AbstractDict, 
        data::AbstractDict,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end


function __flatten_keys!(
        canon::AbstractDict, 
        data::NamedTuple,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::AbstractVector,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end

function __flatten_keys!(
        canon::AbstractDict, 
        data::Tuple,
        pathbuff::Vector{String}
    )
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end


# leaves
function __flatten_keys!(
        canon::AbstractDict, 
        data::Any, # anything else is a leaf
        pathbuff::Vector{String}
    )
    islite_literal(data) || error("Non literal leaf found")
    path = _jsonpointer(pathbuff)
    canon[path] = data
    return canon
end

# Do not check liteness
# Do not check JSON-Pointers
function _unsafe_canonical_flatdict(
        data::AbstractDict,
        canon::AbstractDict = LittleDict{String, Any}();
        pathbuff::Vector{String} = String[]
    )
    __flatten_keys!(canon, data, pathbuff)
    sort!(canon)
    return canon
end

# Do not check flatness
# Do not check liteness
# Do not check JSON-Pointers
function _unsafe_canonical_stringify(canon::AbstractDict)
    return JSON.json(canon)
end