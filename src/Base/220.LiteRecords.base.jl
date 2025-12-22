# HERE: what all records must do

# - validate liteness
# - should return a `LiteRecord`
# - This is already read only
export tk_lite_record
function tk_lite_record(raw::AbstractDict)::LiteRecord
    
    tk_ensure_lite(raw)

    literec = LiteRecord(
        data = Dict();
        metadata = ""
    )

    for (k, v) in pairs(raw)
        tk_setindex!(literec, k, v)
    end

    return literec
end

## ..-- -. -.- -. -.-. - - -.- - -. - .-.- -
# MARK: Julia Core.Base-like dict

tk_setindex!(
    rec::AbstractDynamicLiteRecord, 
    val::Any, 
    key::String
) = 
    push!(rec.data, key => val)

    # read access
tk_getindex(
    rec::AbstractDynamicLiteRecord,
    key::String,
) =
    return rec.data[key]

tk_haskey(
    rec::AbstractDynamicLiteRecord,
    key::String,
) =
    haskey(rec.data, key)

# bulk views
tk_keys(
    rec::AbstractDynamicLiteRecord,
) =
    return keys(rec.data)

tk_values(
    rec::AbstractDynamicLiteRecord,
) =
    return values(rec.data)

tk_pairs(
    rec::AbstractDynamicLiteRecord,
) =
    return pairs(rec.data)

# size / emptiness
tk_length(
    rec::AbstractDynamicLiteRecord,
) =
    return length(rec.data)

tk_isempty(
    rec::AbstractDynamicLiteRecord,
) =
    return isempty(rec.data)

# mutation
tk_delete!(
    rec::AbstractDynamicLiteRecord,
    key::String,
) =
    delete!(rec.data, key)

tk_empty!(
    rec::AbstractDynamicLiteRecord,
) =
    empty!(rec.data)
