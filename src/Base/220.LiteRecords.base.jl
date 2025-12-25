# HERE: what all records must do

# - validate liteness
# - should return an immutable `LiteRecord`
# - This is already read only
export tk_lite_record
function tk_lite_record(raw::AbstractDict, max_depth::Int=1)::LiteRecord
    
    raw_copy = deepcopy(raw)
    tk_ensure_lite(raw_copy, max_depth)

    literec = LiteRecord(
        data = raw_copy,
        metadata = Dict(
            "max_depth" => max_depth
        )
    )

    return literec
end

## ..-- -. -.- -. -.-. - - -.- - -. - .-.- -
# MARK: Julia Core.Base-like dict

tk_setindex!(
    rec::LiteRecord, 
    key::String,
    val::Any
) = 
    error("Not implemented")

# read access
tk_getindex(
    rec::LiteRecord,
    key::String,
) =
    return rec.data[key]

tk_haskey(
    rec::LiteRecord,
    key::String,
) =
    haskey(rec.data, key)

# bulk views
tk_keys(
    rec::LiteRecord,
) =
    return keys(rec.data)

tk_values(
    rec::LiteRecord,
) =
    return values(rec.data)

tk_pairs(
    rec::LiteRecord,
) =
    return pairs(rec.data)

# size / emptiness
tk_length(
    rec::LiteRecord,
) =
    return length(rec.data)

tk_isempty(
    rec::LiteRecord,
) =
    return isempty(rec.data)

# mutation
tk_delete!(
    rec::LiteRecord,
    key::String,
) =
    delete!(rec.data, key)

tk_empty!(
    rec::LiteRecord,
) =
    empty!(rec.data)

# sorting
tk_sort!(
    rec::LiteRecord
) = 
    sort!(rec.data)