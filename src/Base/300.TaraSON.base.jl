# Object correctness assumed
# Intended for literal (keys, values)
# like JSON.json("/key")
_tk_canonical_literal_stringify(x) = JSON.json(x)

# Object correctness assumed
# MEANING: turn a canonical dict into one JSON line
function _tk_unsafe_canonical_stringify(canon::AbstractDict)
    elms = String[]
    for (k, v) in pairs(canon)
        k = _tk_canonical_literal_stringify(k)
        v = _tk_canonical_literal_stringify(v)
        p = string(k, ":", v)
        push!(elms, p)
    end
    return string("{", join(elms, ","), "}")
end

export tk_hashed_tarason
function tk_hashed_tarason(hashed_record::HashedRecord)
    
    hashed_tarason = HashedTaraSON(
        _tk_unsafe_canonical_stringify(hashed_record.data),
        hashed_record.data["/__Tara/record.hash/sha256"]
    )

    return hashed_tarason
end