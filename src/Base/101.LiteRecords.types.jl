# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

# Something that behaves like a Tara record”: 
# - you can at least talk about its canonical payload / hash / basic metadata.
abstract type AbstractLiteRecord <: AbstractLiteNode end

# uncommited LiteRecord
# cleanly separates pre-commit records from stored ones.
# Lets you write APIs like commit!(::AbstractDynamicLiteRecord, tape) while refusing AbstractCanonicalRecord by construction.
abstract type AbstractDynamicLiteRecord <: AbstractLiteRecord end

# commited LiteRecord
abstract type AbstractCanonicalRecord <: AbstractLiteRecord end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullRecord end