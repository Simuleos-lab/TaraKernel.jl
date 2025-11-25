
# dynamic, but still lite
# intentionally has no tape field; 
# attachment happens only at commit time.
# that is, they are always unattached objects
struct DynamicLiteRecord <: Base.AbstractDynamicLiteRecord
    depot::LittleDict{String, Any}
    extras::LittleDict{String, Any}
end

# read only lite record
# TODO: Add optional validation and copying own data
struct StaticLiteRecord <: AbstractStaticLiteRecord
    # It can be attached to both
    # Dynamic or Static Segments
    tape::AbstractLiteTapeSegment
    depot::LittleDict{String, Any}
    extras::LittleDict{String, Any}
end

# A record on standard form
struct CannonicalStaticLiteRecord <: AbstractStaticLiteRecord
    tape::AbstractLiteTapeSegment
    depot::LittleDict{String, Any}
    extras::LittleDict{String, Any}
end