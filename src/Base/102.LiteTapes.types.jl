# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

abstract type AbstractTapeLibrary end
abstract type AbstractLiteTape end
# Segment  =  StaticPrefix*  +  DynamicTail
abstract type AbstractTapeSegment end
abstract type AbstractStaticPrefix end
abstract type AbstractDynamicTail end

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
# MARK: sentinel 
struct DevNullTapeSegment <: AbstractTapeSegment end
