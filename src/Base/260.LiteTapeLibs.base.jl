# HERE: what all tapelibs must do

# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: TaraKernel Base 

# MARK: Lib manifest
# #TODO Move to notes
# - It is a [reserve] tape itself
# - It is a private tape
#   - must methods will ignore it
tk_manifest(::AbstractTapeLibrary) = error("Non implemented")

# MARK: Tape register
# #TODO Move to notes
# - It is a segment[s] at the manifest
# - Returns all tapes 
# - An unregister tape does not exist
# - It determines the default ordering of tapes
tk_registered_tapes(::AbstractTapeLibrary) = error("Non implemented")


tk_eachtape(::AbstractTapeLibrary) = error("Non implemented")


# .-.--..-.--.-.-..--.-.-.-..-- - -.- -.- .- -
# MARK: Julia Base