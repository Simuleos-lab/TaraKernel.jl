# TODO
# - Move to Base
# - This do not depend on storage

## - . .--. .- .--.-.- .--. - .- .- -.. -.-
# MARK: Constructor

DynamicLiteRecord() = DynamicLiteRecord(
    TKB.DynamicTKDict(), TKB.DynamicTKDict()
)

CanonicalRecord(tape::TKB.AbstractTapeSegment, idx::Int) = 
    CanonicalRecord(tape, idx, TKB.DynamicTKDict())

## - . .--. .- .--.-.- .--. - .- .- -.. -.-
# MARK: Accessors

# MARK: DynamicRecord

import TaraKernel.Base.tk_setindex!
function tk_setindex!(rec::DynamicLiteRecord, val, key::String)
    val = TKB._tk_ensure_lite(val)
    setindex!(rec.depot, val, key)
end
