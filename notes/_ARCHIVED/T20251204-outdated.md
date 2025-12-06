## LiteSpec

- #OUTDATED
- A data value/object/struct is lite if it can be encoded as:
    - a single `JSON` literal
        - scalar, boolean, null
        - string
            - limited length
                - `#OPTIONAL`
    - arrays
        - can include only literals
            - `[1,2,3,4]` is lite
            - `[1,[2],[3,4]]` is non-lite
        - type homogeneous
            - `#OPTIONAL`
        - limited length
            - `#OPTIONAL`
    - nested lite objects (dicts)
        - can include as children any other lite object
            - for instance:
                - `{"A": [1], "B": {"C": 1}, "C": 1}`
        - limited deep and/or length
            - `#OPTIONAL`
- Any implementation of the `TaraKernel` will deside a mapping from runtime, language specific, data types and its JSON lite encoding.

# TaraSON and runtime lite definition
- #TODO/REMAINDER
- Im removing at kernel level the requirement that arrays must only contain literals
- In the canonical representation
    - arrays do not exist
    - dict do not exist
    - So, why impose any input struct
- The kernel will expose a very simple recursive `tk_islite` interface
