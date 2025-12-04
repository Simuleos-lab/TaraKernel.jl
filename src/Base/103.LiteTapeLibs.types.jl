# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

abstract type AbstractTapeLibrary <: AbstractTKNode end
abstract type AbstractTapeLibraryLoc end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullTapeLibrary <: AbstractTapeLibrary end

