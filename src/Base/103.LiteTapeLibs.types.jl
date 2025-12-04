# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: Abstract

abstract type AbstractTapeLibrary <: AbstractLiteNode end
abstract type AbstractTapeLibraryLoc end

## --. -.- - .-- .. .- .- -. -. .- .- . .- -.-.-.-
# MARK: Concretes

struct DevNullTapeLibrary <: AbstractTapeLibrary end

