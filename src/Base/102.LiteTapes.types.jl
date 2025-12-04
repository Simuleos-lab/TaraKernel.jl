# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

abstract type AbstractLiteTape <: AbstractLiteNode end

abstract type AbstractTapeSegment <: AbstractLiteNode end

abstract type AbstractStaticSegPrefix <: AbstractLiteNode end
abstract type AbstractDynamicSegTail <: AbstractLiteNode end

# read only, no dynamic part
abstract type AbstractReservedTape <: AbstractLiteTape end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullLiteTape <: AbstractLiteTape end

struct DevNullTapeSegment <: AbstractTapeSegment end

