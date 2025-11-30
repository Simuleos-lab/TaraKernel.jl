# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

# Something that behaves like a Tara record”: 
# - you can at least talk about its canonical payload / hash / basic metadata.
abstract type AbstractLiteRecord end

# uncommited LiteRecord
# cleanly separates pre-commit records from stored ones.
# Lets you write APIs like commit!(::AbstractDynamicLiteRecord, tape) while refusing AbstractStaticLiteRecord by construction.
abstract type AbstractDynamicLiteRecord <: AbstractLiteRecord end

# commited LiteRecord
abstract type AbstractStaticLiteRecord <: AbstractLiteRecord end

# MARK: depot types
const AbstractTaraKey = Union{AbstractString, Symbol}
const AbstractTaraDict = AbstractDict{<:AbstractTaraKey, Any}


# TODO/ Propagate this
const TaraPrimitive = Union{
    Nothing, Bool, Int64, Float64, String
}

const TaraDict = LittleDict{String, Any}

# TaraSON == CanonicalRecord representation
# - you can explait that
# - keys are sorted
# - dict is flat
# - but the number of pairs can be large
# - #TODO find the best data structure
const CanonicalTaraDict = LittleDict{String, TaraPrimitive}
