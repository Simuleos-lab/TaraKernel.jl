
# dynamic, but still lite
# intentionally has no tape field; 
# attachment happens only at commit time.
# that is, they are always unattached objects
struct DynamicLiteRecord <: AbstractDynamicLiteRecord
    depot::TaraDict
    extras::TaraDict
end

# read only lite record
# TODO: Add optional validation and copying own data
struct StaticLiteRecord <: AbstractStaticLiteRecord
    # It can be attached to both
    # Dynamic or Static Segments
    tape::AbstractTapeSegment
    depot::TaraDict
    extras::TaraDict
end

# A record on standard form
struct CannonicalStaticLiteRecord <: AbstractStaticLiteRecord
    tape::AbstractTapeSegment
    depot::TaraDict
    extras::TaraDict
end