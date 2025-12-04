# HERE: what all records must do

## ..-- -. -.- -. -.-. - - -.- - -. - .-.- -
# MARK: Julia Core.Base-like

tk_setindex!(
    ::AbstractDynamicLiteRecord, 
    val::Any, 
    ::String
) = 
    error("Non implemented")