# TODO
# - Move to Base
# - This do not depend on storage
# - At least the dynamic records

# dynamic, but still lite
# intentionally has no tape field; 
# attachment happens only at commit time.
# that is, they are always unattached objects
struct DynamicLiteRecord <: TKB.AbstractDynamicLiteRecord
    depot::TKB.DynamicTKDict
    extras::TKB.DynamicTKDict
end

# read only lite record
# TODO: Add optional validation and copying own data
struct CanonicalRecord <: TKB.AbstractCanonicalRecord
    seg::TKB.AbstractTapeSegment
    idx::Int
    extras::TKB.DynamicTKDict
end

struct CommitRecord <: TKB.AbstractCanonicalRecord
    seg::TKB.AbstractTapeSegment
    idx::Int
    extras::TKB.DynamicTKDict
end

# TODO
# - think about
# - A record that is canonical
# - But accept append/delete fields
# - but, overwriting is not allowed
# - Usage case, succesive hashing