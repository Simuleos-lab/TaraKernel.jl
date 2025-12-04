# #ARCH
# - Interfaces are efined by methods(::AbstractTypes)
# - Concrete types implementations are free

# #ARCH
# - The Kernel will overwrite only basic Base methods
# - Any cool sugaring must be moved to `TaraStdLib`

# #ARCH
# - TaraKernel.Base must define all public interfaces
# - Any backend only deal with implementation

module Base

    #! include .
    include("000.imports.jl")
    include("100.LiteSpec.types.jl")
    include("101.LiteRecords.types.jl")
    include("102.LiteTapes.types.jl")
    include("103.LiteTapeLibs.types.jl")
    include("104.Errors.jl")
    include("200.LiteSpec.islite.jl")
    include("205.LiteNode.DOM.jl")
    include("220.LiteRecords.base.jl")
    include("221.LiteRecords.hashing.jl")
    include("222.LiteRecords.canonical.repr.jl")
    include("240.LiteTapes.base.jl")
    include("241.LiteTapes.hashing.jl")
    include("242.LiteTapes.canonical.repr.jl")
    include("260.LiteTapeLibs.base.jl")
    include("900.utils.jl")
    include("901.utils.jsonpointer.jl")
    include("999.exports.jl")

end