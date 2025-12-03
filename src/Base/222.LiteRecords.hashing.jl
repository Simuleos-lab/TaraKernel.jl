# Record hashing only dependent on the Record content

# Do not check liteness
# Do not check flatness
# Do not check JSON-Pointers 
function _unsafe_rehash_record!(canon::AbstractDict)
    
    # delete hash field
    hashkey = "/__Tara/record.hash/sha265"
    delete!(canon, hashkey)

    # compute hash
    str = _unsafe_canonical_stringify(canon)
    hash = bytes2hex(SHA.sha256(str))
    canon[hashkey] = string("sha265:", hash)
end
