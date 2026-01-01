# Record hashing only dependent on the Record content

# Object correctness assumed
function _tk_unsafe_record_hash(canon::AbstractDict)
    str = _tk_unsafe_canonical_stringify(canon)
    return bytes2hex(SHA.sha256(str))
end

# Object correctness assumed
function _tk_unsafe_rehash_record!(canon::AbstractDict)
    
    # delete hash field
    hashkey = "/__Tara/record.hash/sha256"
    delete!(canon, hashkey)

    # compute hash
    hash = _tk_unsafe_record_hash(canon)
    hash = string("sha256:", hash)
    canon[hashkey] = hash
    sort!(canon)
    return hash
end