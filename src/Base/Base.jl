module Base

    #! include .
    include("000.imports.jl")
    include("100.LiteSpec.types.jl")
    include("101.LiteRecords.types.jl")
    include("102.LiteTapes.types.jl")
    include("200.LiteSpec.islite.jl")
    include("221.LiteRecords.cannonical.repr.jl")
    include("222.LiteRecords.hashing.jl")
    include("900.utils.jl")
    include("901.utils.jsonpointer.jl")
    
end