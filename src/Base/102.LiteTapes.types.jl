# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

abstract type AbstractLiteTape <: AbstractTKNode end

abstract type AbstractTapeSegment <: AbstractTKNode end

abstract type AbstractStaticSegPrefix <: AbstractTKNode end
abstract type AbstractDynamicSegTail <: AbstractTKNode end

# read only, no dynamic part
abstract type AbstractReservedTape <: AbstractLiteTape end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullLiteTape <: AbstractLiteTape end

struct DevNullTapeSegment <: AbstractTapeSegment end

export Tape
struct Tape <: AbstractLiteTape
    id::String
    data::Vector{HashedTaraSON}
end
