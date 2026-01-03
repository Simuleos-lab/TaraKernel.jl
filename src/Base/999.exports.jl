# HERE ALL THAT "GETS-OUT" OF THIS MODULE

# 101
export AbstractLiteRecord
export AbstractDynamicLiteRecord
export AbstractCanonicalRecord
export AbstractTKProfile

# 102
export AbstractTapeLibrary
export AbstractLiteTape
export AbstractTapeSegment
export AbstractStaticSegPrefix
export AbstractDynamicSegTail
export DevNullTapeSegment

### Types
export LiteRecord
export CanonicalRecord
export HashedRecord
export HashedTaraSON
export Tape

## constructors
export tk_lite_record
export tk_canonical_record
export tk_hashed_record
export tk_hashed_tarason
export tk_new_tape

## tape operations
export tk_append!