# HERE ALL THAT "ENTERS" THIS MODULE

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
# MARK OrderedCollections
import OrderedCollections

const LittleDict = OrderedCollections.LittleDict


# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
# MARK Kernel Base
import ..Base

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: LiteRecord

const AbstractLiteRecord = Base.AbstractLiteRecord
const AbstractDynamicLiteRecord = Base.AbstractDynamicLiteRecord
const AbstractStaticLiteRecord = Base.AbstractStaticLiteRecord

const AbstractLiteProfile = Base.AbstractLiteProfile

# ..-.--. -. -.-. -. .-.- .---.-.-.- -- - -- ..- .- .-.- 
## MARK: LiteTape

const AbstractTapeLibrary = Base.AbstractTapeLibrary
const AbstractLiteTape = Base.AbstractLiteTape
# Segment  =  StaticPrefix*  +  DynamicTail
const AbstractTapeSegment = Base.AbstractTapeSegment
const AbstractStaticPrefix = Base.AbstractStaticPrefix
const AbstractDynamicTail = Base.AbstractDynamicTail