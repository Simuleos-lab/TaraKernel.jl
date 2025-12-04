
# dynamic, but still lite
# intentionally has no tape field; 
# attachment happens only at commit time.
# that is, they are always unattached objects
struct DynamicLiteRecord <: AbstractDynamicLiteRecord
    depot::DynamicTaraDict
    extras::DynamicTaraDict
end

# read only lite record
# TODO: Add optional validation and copying own data
struct CanonicalRecord <: AbstractCanonicalRecord
    seg::AbstractTapeSegment
    idx::Int
    extras::DynamicTaraDict
end

struct CommitRecord <: AbstractCanonicalRecord
    seg::AbstractTapeSegment
    idx::Int
    extras::DynamicTaraDict
end