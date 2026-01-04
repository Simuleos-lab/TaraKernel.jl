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
        rec.hash => rec
    )

    return tape
end


# compute commit hash from record hashes
# create commit record
# append commit record
export tk_commit!
function tk_commit!(tape::Tape)

    str = ""

    for key in keys(tape.data)
        str = string(str, key)  # concatenate all previous record hashes
    end

    commit_hash = string("sha256:", bytes2hex(SHA.sha256(str)))

    commit_record = CommitRecord(
        OrderedDict{String, String}(commit_hash => commit_hash)
    )

    push!(
        tape.data,
        commit_hash => commit_record
    )

    return commit_record
end

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Julia Core.Base-like array
