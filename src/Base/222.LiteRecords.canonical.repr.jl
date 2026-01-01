# Here we will implement the canonical representation interface

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
# MARK: Canonical

# Assume liteness

function __flatten_col!(
        canon::CanonicalTKDict, 
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
    canon[path] = tag
end

function __flatten_keys!(
        canon::CanonicalTKDict, 
        data::AbstractDict,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end


function __flatten_keys!(
        canon::CanonicalTKDict, 
        data::NamedTuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::DICT", pathbuff)
    __flatten_col!(canon, data, pathbuff, false)
    return canon
end

function __flatten_keys!(
        canon::CanonicalTKDict, 
        data::AbstractVector,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end

function __flatten_keys!(
        canon::CanonicalTKDict, 
        data::Tuple,
        pathbuff::Vector{String}
    )
    __obj_sentinel!(canon, "::ARR", pathbuff)
    __flatten_col!(canon, data, pathbuff, true)
    return canon
end


# leaves
function __flatten_keys!(
        canon::CanonicalTKDict, 
        data::Any, # anything else is a leaf
        pathbuff::Vector{String}
    )
    _tk_islite_literal(data) || error("Non literal leaf found")
    path = _tk_jsonpointer(pathbuff)
    canon[path] = data
    return canon
end

# Object correctness assumed
# MEANING: flat a dict canonicaly
function _tk_unsafe_canonical_flatdict(
        literec::LiteRecord,
        canon::CanonicalTKDict;
        pathbuff::Vector{String} = String[]
    )
    __flatten_col!(canon, literec.data, pathbuff, false)
    _tk_ensure_shallow(canon)
    return canon
end

export tk_canonical_record
function tk_canonical_record(literec::LiteRecord)

    canon = LittleDict{String, TaraSONPrimitive}()
    flattened_data = _tk_unsafe_canonical_flatdict(literec, canon)

    canon_record = CanonicalRecord(
        flattened_data
    )

    return canon_record
end