# HERE: what all tapes must do

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: TaraKernel Base 

# canonize record
# rehash canon record
# push! record into segment
# record data must be copied
function tk_commit_record!(
    seg::AbstractTapeSegment, 
    dym::AbstractDynamicLiteRecord;
    kwargs...
)
    error("Non implemented")
end

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Julia Base