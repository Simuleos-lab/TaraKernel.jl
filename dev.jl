@time begin
    using TaraKernel
    using JSON
end

## .- .-.- .- -. -.-- -.- -.---- .- ..- -. .-.-
# Goal:
# Draft a sequence of ATOMIC functions implementing DataFlow.N1
# From runtime data to commited tape
# Note: atomic means that they make a single functionality
# Those are some of the high level functions
# many others should follow.

# Note: This is a draft, it is expected to change

# Types are garantees of validation
# I mean, functions should only validate data on type creation
# for instance, is ok to assume a `LiteRecord` lite after its creation

# Proposal: all records are read only
# The kernel do not provide mutability
# You should interact with the kernel if you want to commit

## .- .-.- .- -. -.-- -.- -.---- .- ..- -. .-.-
let
    # Runtime data
    # - mutate/create here
    raw = Dict{String, Any}(
        "A" => 1, 
        "B" => "I know I can play Bembe"
    )

    raw2 = Dict{String, Any}(
        "A" => 1, 
        "B" => [1,2,3]
    )

    raw3 = Dict{String, Any}(
        "A" => 1, 
        "B" => Dict{String, Any}(
            "A" => 1, 
            "B" => [1,2,3]
        )
    )

    # Move to TaraKernel type
    # - validate liteness
    # - should return a `LiteRecord`
    # - This is already read only
    lite_record = tk_lite_record(raw3)::LiteRecord

    # cannonize
    # - return a `CanonicalRecord`
    canonical_record = tk_canonical_record(lite_record::LiteRecord)::CanonicalRecord
    
    # println(JSON.json(canon; pretty=true))
    
    # Hashed Record
    # - compute the hash of the masked TaraSON
    # - add the hash to the record
    hashed_record = tk_hashed_record(canonical_record::CanonicalRecord)::HashedRecord
    
    # hashed TaraSON
    # - return a HashedTaraSON
    #   - just a wrapper around a TaraSON string
    hashed_tarason = tk_hashed_tarason(hashed_record::HashedRecord)::HashedTaraSON
    
    println(hashed_tarason.data)

    # append (stage)
    # append the HashedTaraSON to the tape
    tape = Tape("shhh_mother_is_sleeping")
    tk_append!(tape::Tape, hashed::HashedTaraSON)

    println(tape)
    
    # # commit (stage)
    # # compute the tape hashes
    # # create a `CommitRecord`
    # # append the `CommitRecord`
    # tk_commit!(tape::Tape)::CommitRecord
    
    # # write to Storage Backend 
    # # check tape is commited
    # # validate tape
    # # send NEW record bytes to storage
    # tk_write!(tape::Tape)
end