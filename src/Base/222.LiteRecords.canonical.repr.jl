# Here we will implement the canonical representation interface

# Assume liteness

function __flatten_col!(
        canon::CanonicalRecord, 
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
    path = _tk_jsonpointer(pathbuff)
    canon.data[path] = tag
end

function __flatten_keys!(
        canon::CanonicalRecord, 
        data::AbstractDict,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end


function __flatten_keys!(
        canon::CanonicalRecord, 
        data::NamedTuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end

function __flatten_keys!(
        canon::CanonicalRecord, 
        data::AbstractVector,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end

function __flatten_keys!(
        canon::CanonicalRecord, 
        data::Tuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end


# leaves
function __flatten_keys!(
        canon::CanonicalRecord, 
        data::Any, # anything else is a leaf
        pathbuff::Vector{String}
    )
    _tk_islite_literal(data) || error("Non literal leaf found")
    path = _tk_jsonpointer(pathbuff)
    canon.data[path] = data
    return canon
end

# Object correctness assumed
# MEANING: flat a dict canonicaly
function _tk_unsafe_canonical_flatdict(
        data::AbstractDict,
        canon::CanonicalRecord = CanonicalRecord();
        pathbuff::Vector{String} = String[]
    )
    __flatten_col!(canon, data, pathbuff, false)
    tk_sort!(canon)
    return canon
end

export tk_canonical_record
tk_canonical_record(data) = _tk_unsafe_canonical_flatdict(data)

# Object correctness assumed
# Intended for literal (keys, values)
# like JSON.json("/key")
_tk_canonical_literal_stringify(x) = JSON.json(x)

# Object correctness assumed
# MEANING: turn a canonical dict into one JSON line
function _tk_unsafe_canonical_stringify(canon::CanonicalRecord)
    elms = String[]
    for (k, v) in pairs(canon)
        k = _tk_canonical_literal_stringify(k)
        v = _tk_canonical_literal_stringify(v)
        p = string(k, ":", v)
        push!(elms, p)
    end
    return string("{", join(elms, ","), "}")
end