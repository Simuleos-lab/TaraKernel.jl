module TaraKernel

    include("Base/Base.jl")
    include("DiskBackend/DiskBackend.jl")

    using .Base

    ### LiteRecord
    
    export LiteRecord
    export CanonicalRecord
    export tk_lite_record
    export tk_canonical_record

end