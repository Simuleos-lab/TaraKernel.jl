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
# Lets you write APIs like commit!(::AbstractDynamicLiteRecord, tape) 
# while refusing AbstractCanonicalRecord by construction.
abstract type AbstractDynamicLiteRecord <: AbstractLiteRecord end

# commited LiteRecord
abstract type AbstractCanonicalRecord <: AbstractLiteRecord end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullRecord end

export LiteRecord
Base.@kwdef struct LiteRecord <: AbstractDynamicLiteRecord
    data::Union{Nothing, Dict{String, Union{Nothing, Bool, Integer, AbstractString, AbstractFloat, Symbol}}} = nothing
    metadata::Union{Nothing, String} = nothing
end

export CanonicalRecord
Base.@kwdef struct CanonicalRecord <: AbstractDynamicLiteRecord
    data::Union{Nothing, Dict{String, Union{Nothing, Bool, Integer, AbstractString, AbstractFloat, Symbol}}} = nothing
    metadata::Union{Nothing, String} = nothing
end