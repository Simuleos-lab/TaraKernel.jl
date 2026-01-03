# HERE: what all tapes must do

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Segments
# TODO: make its own file

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: TaraKernel Base

export tk_append!
function tk_append!(tape::Tape, rec::HashedTaraSON)

    push!(
        tape.data, 
        rec.hash => rec.data
    )

    return tape
end


# compute commit hash from record hashes
# create commit record
# append commit record
function tk_commit!(tape::Tape)

    str = ""

    for key in keys(tape.data)
        str = string(str, key)  # concatenate all previous record hashes
    end

    commit_hash = string("sha256:", bytes2hex(SHA.sha256(str)))

    push!(
        tape.data,
        commit_hash => commit_hash
    )

    return tape
end

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Julia Core.Base-like array
