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
        push!(literec.data, k => v)
    end

    return literec
end

## ..-- -. -.- -. -.-. - - -.- - -. - .-.- -
# MARK: Julia Core.Base-like dict

tk_setindex!(
    ::AbstractDynamicLiteRecord, 
    val::Any, 
    ::String
) = 
    error("Non implemented")

    # read access
tk_getindex(
    ::AbstractDynamicLiteRecord,
    ::String,
) =
    error("Non implemented")

tk_haskey(
    ::AbstractDynamicLiteRecord,
    ::String,
) =
    error("Non implemented")

# bulk views
tk_keys(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")

tk_values(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")

tk_pairs(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")

# size / emptiness
tk_length(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")

tk_isempty(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")

# mutation
tk_delete!(
    ::AbstractDynamicLiteRecord,
    ::String,
) =
    error("Non implemented")

tk_empty!(
    ::AbstractDynamicLiteRecord,
) =
    error("Non implemented")
