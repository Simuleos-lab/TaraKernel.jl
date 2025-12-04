# Record hashing only dependent on the Record content

# Object correctness assumed
function _unsafe_record_hash(canon::AbstractDict)
    str = _unsafe_canonical_stringify(canon)
    return bytes2hex(SHA.sha256(str))
end

# Object correctness assumed
function _unsafe_rehash_record!(canon::AbstractDict)
    
    # delete hash field
    hashkey = "/__Tara/record.hash/sha265"
    delete!(canon, hashkey)

    # compute hash
    hash = _unsafe_record_hash(canon)
    canon[hashkey] = string("sha265:", hash)
end
