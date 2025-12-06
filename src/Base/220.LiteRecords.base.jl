# HERE: what all records must do

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
