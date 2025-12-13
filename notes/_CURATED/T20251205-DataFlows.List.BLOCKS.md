
## TKDF: DataFlow.N1: ingestion and commit from runtime
- #WIP
- name: `DataFlow.N1`
- This is the only way to introduce additional (new/more) logical content into the system.
- The flow, at the most abstract level, is:
1. Data exists in an `External.DataType`.
2. Data is **ingested** into a `TaraKernel.DataType` at Runtime.
3. More `TaraKernel.Runtime` data may be ingested or **transformed**.
4. `TaraKernel.Runtime` data is **committed** to Storage via a backend.
- Steps 2–4 are kernel steps:
    - they are expressed and constrained by kernel (`tk_*`) functions.
- Steps 2–3 are `TaraKernel.Base` steps:
    - they are implemented by `TaraKernel.Base` (`_tk_*`) functions.
- Steps 1–3 happen entirely at **Runtime**.
- Step 2 is the boundary between `External.Runtime` and `TaraKernel.Runtime`.
- Step 4 is the boundary between `TaraKernel.Runtime` and **Storage**.

--- 

## TKDF: DataFlow.N1: Step 1
- #BOARD
- #EXPERIMENTAL
- STEP: Data exists in an `External.DataType`.
    - this has no associated `tk_` functions
    - this belong to the user space
    - althouth the `External.DataType` must be a compatible one

## TKDF: DataFlow.N1: Step 2
- #BOARD
- #EXPERIMENTAL
STEP: Data is **ingested** into a `TaraKernel.DataType` at Runtime.
    - you create an empty `DynamicRecord`
    - populate `tk_setindex!(::DynamicRecord, val, keys...)`
    - or `tk_merge!(::DynamicRecord, ::Dict)`
    - `tk_setindex!` and `tk_merge!` check for liteness
    - `DynamicRecord` is the `TaraKernel.DataType`

## TKDF: DataFlow.N1: Step 3
- #BOARD
- #EXPERIMENTAL
- STEP: More `TaraKernel.Runtime` data may be ingested or **transformed**.
    - `DynamicRecord` are totally mutable
    - you can keep adding stuff
    - or delete stuff
    - always validating liteness
    - etc

## TKDF: DataFlow.N1: Step 4
- #BOARD
- #EXPERIMENTAL
- STEP: `TaraKernel.Runtime` data is **committed** to Storage via a backend.
- `tk_canonical(src::DynamicRecord, CanonicalRecord)`
    - `DynamicRecord` is cannonizised to the given `CanonicalRecord` type.
    - note that this function ask for a sink type
    - like `CSV.read` 
    - This allow user extenssions to other sink types
- `tk_commit!(src::CanonicalRecord, seg::TapeSegment, CommittedRecord)`
    - the same, it has a sink
    - add content hash
    - attach/append the `CommittedRecord` to the seg
    - return an inmmutable/static record
    - you can keep doing it all time you need
    - new stuff is added to a `DynamicalTapeTail`
- `tk_commit!(seg)`
    - add/append `CommitRecord` to seg
    - Make prefix static
    - propagate the commit to the tape and lib
        - write on `commits.manifest`
            - #EXPERIMENTAL
    - #TODO: maybe separate commit from writing to storage
        - non necessary/justify for segments/tape/lib
    - maybe a better name `tk_commit_and_store!(seg)`

## TKDF: `tk_commit!`
- this is a very important function
