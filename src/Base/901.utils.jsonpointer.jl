## Minimal JSON-Pointer support

_jsonpointer_stringify(x::AbstractString) = string(x)
_jsonpointer_stringify(x::Integer) = string(x)

function _jsonpointer(
        segments::AbstractVector;
        escaped::Vector{String} = String[],
    )
    # Empty sequence → empty pointer (the whole document)
    isempty(segments) && return ""

    # Ensure `escaped` has the right length
    resize!(escaped, length(segments))

    # Escape each segment and join with "/"
    for (i, seg) in pairs(segments)
        s = _jsonpointer_stringify(seg)
        s = replace(s, "~" => "~0", "/" => "~1")
        escaped[i] = s
    end

    return string("/", join(escaped, "/"))
end

# Internal helper: validate JSON Pointer syntax in one pass over bytes.
# Returns true if valid, false if invalid (when throw_on_error == false),
# or throws ArgumentError with a detailed message (when throw_on_error == true).
@inline function _jsonpointer_validate(
        pointer::AbstractString; 
        throw_on_error::Bool
    )
    cu = codeunits(pointer)
    n  = length(cu)

    # Empty string is a valid JSON Pointer ("whole document").
    n == 0 && return true

    # Non-empty pointers must start with '/'.
    if cu[1] != UInt8('/')
        if throw_on_error
            throw(ArgumentError(
                "Invalid JSON Pointer \"$pointer\": must be empty or start with '/'."
            ))
        else
            return false
        end
    end

    i = 1
    @inbounds while i <= n
        b = cu[i]

        if b == UInt8('~')
            # '~' must be followed by '0' or '1'
            if i == n
                if throw_on_error
                    throw(ArgumentError(
                        "Invalid JSON Pointer \"$pointer\": '~' at byte $i must be followed by '0' or '1'."
                    ))
                else
                    return false
                end
            end

            b2 = cu[i + 1]
            if !(b2 == UInt8('0') || b2 == UInt8('1'))
                if throw_on_error
                    c = Char(b2)
                    throw(ArgumentError(
                        "Invalid JSON Pointer \"$pointer\": '~' at byte $i may only be followed by '0' or '1', found '$c'."
                    ))
                else
                    return false
                end
            end

            i += 2
        else
            i += 1
        end
    end

    return true
end

function _jsonpointer_isvalid(pointer::AbstractString)
    _jsonpointer_validate(pointer; throw_on_error = false)
end

function _jsonpointer_check(pointer::AbstractString)
    _jsonpointer_validate(pointer; throw_on_error = true)
    return pointer 
end
