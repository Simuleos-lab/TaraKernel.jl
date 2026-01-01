# Record hashing only dependent on the Record content

# Object correctness assumed
function _tk_unsafe_record_hash(canon::CanonicalRecord)
    str = _tk_unsafe_canonical_stringify(canon.data)
    return bytes2hex(SHA.sha256(str))
end

# Object correctness assumed
function _tk_unsafe_rehash_record!(canon::CanonicalRecord)
    
    # delete hash field
    hashkey = "/__Tara/record.hash/sha256"
    delete!(canon.data, hashkey)

    # compute hash
    hash = _tk_unsafe_record_hash(canon)
    hash = string("sha256:", hash)
    canon.data[hashkey] = hash
    
    return hash
end

export tk_hashed_record
function tk_hashed_record(canon::CanonicalRecord)
    
    _tk_unsafe_rehash_record!(canon)

    hashed_record = HashedRecord(
        canon.data
    )

    return hashed_record
end