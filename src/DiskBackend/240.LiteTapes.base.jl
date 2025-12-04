## - . .--. .- .--.-.- .--. - .- .- -.. -.-
# MARK: Constructor

LiteTape(lib::LiteTapeLib, name::String) = LiteTape(
    lib, name, TKB.DynamicTKDict()
)

TapeSegment(tape::LiteTape, name::String) = 
    TapeSegment(tape, name, CanonicalRecord[], TKB.CanonicalTKDict[], TKB.DynamicTKDict())



## - . .--. .- .--.-.- .--. - .- .- -.. -.-
# MARK: Attach

import TaraKernel.Base.tk_commit_record!
function TaraKernel.Base.tk_commit_record!(
        seg::TapeSegment, 
        rec::DynamicLiteRecord
    )
    
    # canon depot
    canon = TKB.CanonicalTKDict()

    # canonical data
    TKB._tk_unsafe_canonical_flatdict!(rec.depot, canon)

    # compute content hash
    TaraKernel.Base._tk_unsafe_rehash_record!(canon)

    # Add raw
    push!(seg.raw, canon)
    
    # Add wrappers
    idx = lastindex(seg.raw)
    canrec = CanonicalRecord(seg, idx)
    push!(seg.records, canrec)
    
    return canrec
end