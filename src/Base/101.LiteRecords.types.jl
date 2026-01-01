# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
#= 
- DynamicRecord
    - Lite:         yes
    - Runtime:      yes
    - Dynamic:      yes
    - Static:       no
    - Committed:    no
    - Canonical:    any
    - Attached:     no
- CanonicalRecord
    - Lite:         yes
    - Runtime:      yes
    - Dynamic:      yes
    - Static:       no
    - Committed:    no
    - Canonical:    yes
    - Attached:     no
- CommittedRecord
    - Lite:         yes
    - Runtime:      yes
    - Dynamic:      no
    - Static:       yes 
    - Committed:    yes
    - Canonical:    yes
    - Attached:     yes
=#

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

# Something that behaves like a Tara record”: 
# - you can at least talk about its canonical payload / hash / basic metadata.
abstract type AbstractLiteRecord <: AbstractTKNode end

# uncommited LiteRecord
# cleanly separates pre-commit records from stored ones.
# Lets you write APIs like commit!(::AbstractTaraRecord, tape) 
# while refusing AbstractCanonicalTaraRecord by construction.
abstract type AbstractTaraRecord <: AbstractLiteRecord end

# canonical LiteRecord
abstract type AbstractCanonicalTaraRecord <: AbstractLiteRecord end

# parsed canonical LiteRecord
abstract type AbstractTaraSONRecord <: AbstractLiteRecord end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullRecord end

export LiteRecord
struct LiteRecord <: AbstractTaraRecord
    data::Dict{String, Any}
end

export CanonicalRecord
struct CanonicalRecord <: AbstractCanonicalTaraRecord
    data::SortedDict{String, Union{Nothing, TaraSONPrimitive}}
end

export MaskedCanonicalRecord
struct MaskedCanonicalRecord <: AbstractCanonicalTaraRecord
    data::SortedDict{String, Union{Nothing, TaraSONPrimitive}}
end

export TaraSONRecord
struct TaraSONRecord <: AbstractTaraSONRecord
    data::String
end
