# dataless: a view of the file system
struct LiteTape <: AbstractLiteTape
    lib::AbstractTapeLibrary
    name::String                        # the name of the folder
    extras::DynamicTaraDict
end

# data depot
struct TapeSegment <: AbstractTapeSegment
    tape::AbstractLiteTape
    name::String                        # the name of the folder
    records::Vector{CanonicalRecord}    # runtime objects
    raw::Vector{CanonicalTaraDict}      # .jsonl file parsed data
    extras::DynamicTaraDict
end

# dataless: a view of a segment
struct StaticSegmentPrefix <: AbstractStaticSegPrefix
    seg::AbstractTapeSegment
    idx0::Int 
    idx1::Int 
    extras::DynamicTaraDict
end

# dataless: a view of a segment
struct DynamicSegmentTail <: AbstractDynamicSegTail
    seg::AbstractTapeSegment
    idx0::Int 
    extras::DynamicTaraDict
end