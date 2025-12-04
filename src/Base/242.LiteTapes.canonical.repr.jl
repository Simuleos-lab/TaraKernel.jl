
# Object correctness assumed
# Expected to be lazy
function _tk_unsafe_canonical_lines(
    raw::Vector{CanonicalTKDict}
)   
    return Channel{String}() do _ch
        for canon in raw
            line = _tk_unsafe_canonical_stringify(canon)
            put!(_ch, line)
        end
    end
end

# Object correctness assumed
function _tk_unsafe_canonical_stringify(
    raw::Vector{CanonicalTKDict}
)
    lines = _tk_unsafe_canonical_lines(raw)
    return join(lines, "\n")
end