

# - add raw_records::Vector{String, Any}()
#   - a raw representation of Records data
struct StaticLiteTapeSegment <: Base.AbstractStaticLiteTapeSegment 
end

struct DynamicLiteTapeSegment <: Base.AbstractDynamicLiteTapeSegment 
end

# bring sentinel
const DevNullLiteTapeSegment = Base.DevNullLiteTapeSegment