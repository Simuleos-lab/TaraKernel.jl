# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: LiteRecord

# Something that behaves like a Tara record”: 
# - you can at least talk about its canonical payload / hash / basic metadata.
abstract type AbstractLiteRecord end

# uncommited LiteRecord
# cleanly separates pre-commit records from stored ones.
# Lets you write APIs like commit!(::AbstractDynamicLiteRecord, tape) while refusing AbstractStaticLiteRecord by construction.
abstract type AbstractDynamicLiteRecord <: AbstractLiteRecord end

# commited LiteRecord
abstract type AbstractStaticLiteRecord <: AbstractLiteRecord end


# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: LiteTape

abstract type AbstractLiteTapeLib end
abstract type AbstractLiteTape end
abstract type AbstractLiteTapeSegment end
abstract type AbstractStaticLiteTapeSegment <: AbstractLiteTapeSegment end
abstract type AbstractDynamicLiteTapeSegment <: AbstractLiteTapeSegment end