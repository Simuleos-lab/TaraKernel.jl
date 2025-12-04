## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Abstracts
abstract type AbstractLiteNode end

abstract type AbstractLiteProfile end

# #ARCH
# - liteness is not enforced using the Type system
# - this is just for helping type stability

const AbstractTaraPrimitive = Union{
    Nothing, Bool, Int64, Float64, String, Symbol
}

# A locator spec is an object containig all necessary
# to locate an object
abstract type AbstractLocatorSpec end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

# MARK: LiteProfile
struct DefaultLiteProfile <: AbstractLiteProfile end
const DynamicTaraDict = LittleDict{String, Any}

# TaraSON == CanonicalRecord representation
# - you can explait that
# - keys are sorted
# - dict is flat
# - but the number of pairs can be large
# - #TODO find the best data structure
const CanonicalTaraDict = LittleDict{String, AbstractTaraPrimitive}


