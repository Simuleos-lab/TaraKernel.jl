
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