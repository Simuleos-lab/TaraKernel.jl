# dataless: a view of the file system
struct LiteTape <: TKB.AbstractLiteTape
    lib::TKB.AbstractTapeLibrary
    name::String                        # the name of the folder
    extras::TKB.DynamicTKDict
end

# data depot
struct TapeSegment <: TKB.AbstractTapeSegment
    tape::TKB.AbstractLiteTape
    name::String                        # the name of the folder
    records::Vector{CanonicalRecord}    # runtime objects
    raw::Vector{TKB.CanonicalTKDict}      # .jsonl file parsed data
    extras::TKB.DynamicTKDict
end

# dataless: a view of a segment
struct StaticSegmentPrefix <: TKB.AbstractStaticSegPrefix
    seg::TKB.AbstractTapeSegment
    idx0::Int 
    idx1::Int 
    extras::TKB.DynamicTKDict
end

# dataless: a view of a segment
struct DynamicSegmentTail <: TKB.AbstractDynamicSegTail
    seg::TKB.AbstractTapeSegment
    idx0::Int 
    extras::TKB.DynamicTKDict
end