# HERE: what all tapes must do

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Segments
# TODO: make its own file

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: TaraKernel Base 

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
