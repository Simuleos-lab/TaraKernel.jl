
# Object correctness assumed
function _tk_unsafe_segment_content_hash(depot::AbstractVector)
    ctx = SHA.SHA2_256_CTX()
    for record in depot
        rhash = record["/__Tara/record.hash/sha256"]
        SHA.update!(ctx, codeunits(rhash))
    end
    return string("sha256:", bytes2hex(SHA.digest!(ctx)))
end
