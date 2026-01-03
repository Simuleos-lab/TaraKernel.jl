# HERE: what all tapes must do

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Segments
# TODO: make its own file

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: TaraKernel Base

export tk_new_tape
function tk_new_tape(id::String)
    tape = Tape(
        id,
        Vector(undef, 0)
    )
    return tape
end


export tk_append!
function tk_append!(tape::Tape, hashed_record::HashedTaraSON)
    push!(tape.data, hashed_record)
    return tape
end



# canonize record
# rehash canon record
# push! record into segment
# record data must be copied
function tk_commit_record!(
    seg::AbstractTapeSegment, 
    dym::AbstractTaraRecord;
    kwargs...
)
    error("Non implemented")
end

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Julia Core.Base-like array
