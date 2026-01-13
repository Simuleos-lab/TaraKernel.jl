# Design Review Trace

**PR** [21](https://github.com/Simuleos-lab/TaraKernel.jl/pull/21)
**PR Diff:** `main...HEAD`  
**Generated:** 2026-01-11T18:10:49Z

---

### How to Read This Document

This document is a design review trace for the current pull request.
Its purpose is to make the **design-relevant issue surface** implied by the changes visible, so that a human reviewer can see and comment on those implications.

Key properties:
- Change descriptions are interpretive, not claims about author intent
- Design issues are hypotheses, not defects or recommendations
- Presence of an issue does not imply action is required
- Absence of an issue does not imply endorsement
- Design notes are used as context, not as unquestionable authority
- Alignment, tension, or absence of design notes is itself valid review material
- This document is strictly scoped to this PR.
- It does not propose actions, suggest next steps, or prescribe outcomes.

---

## Orientation

This PR represents a substantial evolution of the TaraKernel type system and pipeline architecture. The changes refactor the record lifecycle from dynamic through canonical to hashed representations, introduce a new TaraSON serialization layer, and add tape commit semantics. The diff touches type hierarchies, validation depth logic, hashing mechanisms, and introduces new data structure dependencies (DataStructures.jl).

---

## Change 1: Addition of DataStructures Dependency

**What Changed:**
- Added `DataStructures` package (v0.19.3) as a new dependency
- Introduced `SortedDict` import alongside existing `OrderedDict` from OrderedCollections
- Project and manifest files updated to reflect dependency addition

**Design Issues:**

[Dependency Boundary] The introduction of `SortedDict` from DataStructures.jl creates an implicit ordering invariant in the canonical representation layer. The existing codebase used `OrderedDict` for insertion-order semantics; `SortedDict` introduces key-sorted semantics. This dual-dictionary strategy surfaces a question: what ordering guarantee is now canonical, and does the introduction of sorted keys affect hash stability across systems?
    - `#josePereiro/FEEDBACK`
        - yes, `TaraSON` represents a key-ordered JSON-like object
        - that is part of the specs

[Type Coupling] `SortedDict` appears in concrete type definitions (e.g., `CanonicalRecord`, `HashedRecord`) which hardens coupling to DataStructures.jl. If ordering semantics or dictionary implementation details change, type-level refactoring may be required.
    - `#josePereiro/FEEDBACK`
        - We must consider implementuing our own `SortedDict`
        - It is simple, and we don't need a new dep only for that
    - `#josePereiro/FEEDBACK`
        - `DataStructures.jl` is 
            - an stable Julia package
            - small dependency
        - no problem
---

## Change 2: Type Hierarchy Refactoring

**What Changed:**
- Renamed `AbstractDynamicLiteRecord` → `AbstractTaraRecord`
- Renamed `AbstractCanonicalRecord` → `AbstractCanonicalTaraRecord`
- Introduced new abstract type `AbstractTaraSONRecord`
- Changed concrete types:
  - `LiteRecord`: now holds single `Dict{String, Any}` (removed `metadata` field)
  - `CanonicalRecord`: now holds `SortedDict{String, Union{Nothing, TaraSONPrimitive}}`
  - Introduced `HashedRecord`, `HashedTaraSON`, `CommitRecord` types
  - Tape type now holds `OrderedDict` of records and commit records

**Design Issues:**

[Naming Consistency] The shift from "Dynamic" and "Canonical" to "Tara" and "CanonicalTara" introduces naming asymmetry. `AbstractTaraRecord` suggests all records are "Tara records," yet `AbstractCanonicalTaraRecord` carries both "Canonical" and "Tara" qualifiers. This hints at semantic overlap or incomplete conceptual separation.

[Metadata Removal] `LiteRecord` previously carried optional metadata; this field is now absent. If metadata was serving a diagnostic or tracing role, its removal raises the question: where does auxiliary information (e.g., max depth, validation context) now live? The removal may signal a design intent to keep records purely data-focused, but it also eliminates a prior extension point.

[Type Proliferation] The introduction of `HashedRecord`, `HashedTaraSON`, and `CommitRecord` as distinct types suggests a stage-based transformation pipeline. Each stage is now crystallized in the type system. This makes transitions explicit but also hardens the pipeline—adding or reordering stages may require new types.
    - `#josePereiro/FEEDBACK`
        - This is intentional
        - pros
            - Each stage has its own type, using the type system as gordian way to prevent misuse
            - methods only function on previously validated data
        - cons
            - more types to manage

[Representation Duality] `HashedTaraSON` holds both a string representation (`data`) and a hash. This pairs parsing and hashing concerns in one type, which may complicate scenarios where you want a parsed structure without re-hashing, or vice versa.
    - `#josePereiro/FEEDBACK`
        - `#josePereiro/PROPOSAL`
            - add an object representation field to `HashedTaraSON`
            - We just need to define the source of truth
            - in this case is the string representation
            - the object representation is for `getindex`
            - it is readonly anyway

---

## Change 3: Removal of Depth-Based Validation

**What Changed:**
- Removed `max_depth` parameter from `tk_islite`, `tk_ensure_lite`, `find_nonlite` functions
- Removed depth-tracking logic (`n::Int` parameter removed from recursive calls)
- Error messages no longer report "maximum depth reached"
- Metadata field tracking `max_depth` removed from `LiteRecord`

**Design Issues:**

[Validation Boundary] The prior design allowed limiting recursion depth, presumably to bound validation cost or prevent deep structures. Removing this parameter implies either:
  - All structures are now validated fully (unbounded depth), which may introduce performance concerns for deeply nested data
  - The concept of "lite" now has a different definition, no longer tied to depth
    - `#josePereiro/FEEDBACK`
        - depth limit is now enforced in the canonicalization stage
        - this is not a final decision yet
  
Neither interpretation is explicit in the diff. The change surfaces a question: what happens when a user provides a deeply nested but otherwise valid lite structure?

[Error Context Loss] The `find_nonlite` function previously returned a 3-tuple `(path, value, reason)` where `reason` could be `:depth_limit` or `:not_literal`. Now it returns a 2-tuple `(path, value)`. The loss of `reason` removes diagnostic context that could have been useful for debugging validation failures.
    - `#josePereiro/FEEDBACK`
        - now the only reason is `:not_literal`

---

## Change 4: Introduction of Shallow Validation

**What Changed:**
- Added `_tk_find_deep` function: checks if any key in a flattened dict has path depth > 10 (counted by `/` separators)
- Added `_tk_ensure_shallow` function: throws error if deep keys found
- Called from `_tk_unsafe_canonical_flatdict` after flattening

**Design Issues:**

[Magic Number] The depth threshold of 10 is hardcoded in `_tk_find_deep`. This number is not parameterized, documented, or justified in the code. It creates an implicit contract: flattened canonical records cannot have paths deeper than 10 levels.
    - `#josePereiro/FEEDBACK`
        - `#josePereiro/NOTE`
            - yes, this is a magic number at the moment
            - this is an `#OPEN/DISCUSSION`
        - `#josePereiro/ISSUE`
            - Also, this is not a real limit
            - people can overcome it be flattening the object a priori
            - we should consider just limiting the final record string length

[Lifecycle Transition] Depth validation moved from the "lite" check (removed) to the "canonical" stage (added). This shifts when depth constraints are enforced. Previously, depth was bounded at input; now, it's bounded after flattening. This raises the question: can a valid `LiteRecord` now become invalid during canonicalization?
    - `#josePereiro/FEEDBACK`
        - Yes, this is posible
        - we are validating data as it flows through the pipeline
        - length limits are enforced when data is serialized into a string
        - we donòt want to serialize just for validating
        - at the current workflow, serialization is not at the beginning

[Path Representation Coupling] The shallow check assumes paths are `/`-separated strings. This ties validation to the path representation format. If path formatting changes, validation logic must also change.
    - `#josePereiro/FEEDBACK`
        - that is true
        - at the moment, we are defining the path format as part of the specs
        - this is an `#OPEN/DISCUSSION`

---

## Change 5: Flattening and Sorting Changes

**What Changed:**
- `_tk_unsafe_canonical_flatdict` previously called `sort!(canon)` after flattening
- Now calls `_tk_ensure_shallow(canon)` instead, and returns a `SortedDict` (which maintains sorted order by construction)
- `CanonicalRecord` constructor now wraps a `SortedDict` instead of a plain dict

**Design Issues:**

[Sorting Invariant] The shift from explicit `sort!` to `SortedDict` changes when ordering is established. `SortedDict` maintains order on insertion, which may have performance implications during flattening. The prior approach deferred sorting until the end. This change may affect insertion-heavy workloads.
    - `#josePereiro/FEEDBACK`
        - I liked more the previous approach
        - sorting at the end is more efficient
        - this is an `#OPEN/DISCUSSION`


[Canonical Representation Stability] If `SortedDict` uses different comparison semantics or ordering than the previous `sort!`, canonical representations (and thus hashes) could differ for the same input data across versions. This is a hash stability concern.
    - `#josePereiro/FEEDBACK`
        - `DataStructures.jl` uses standard Julia ordering
        - so, it is stable across versions
        - this is an `#OPEN/DISCUSSION`
---

## Change 6: Hashing Logic Refactoring

**What Changed:**
- `_tk_unsafe_record_hash` now accepts `CanonicalRecord` instead of `AbstractDict`, accesses `.data`
- `_tk_unsafe_rehash_record!` similarly updated to work on `CanonicalRecord` struct
- Removed `sort!(canon)` call after rehashing (no longer needed with `SortedDict`)
- Introduced `tk_hashed_record` function: creates `HashedRecord` from `CanonicalRecord` after rehashing

**Design Issues:**

[Type Narrowing] Hashing functions now expect concrete `CanonicalRecord` types rather than generic dicts. This tightens the contract but reduces flexibility—any alternative canonical representation would require separate hashing logic.
    - `#josePereiro/FEEDBACK`
        - I liked more the previous approach
        - having a general INTERNAL unsafe hashing function
        - and a specific safe (typed) one for the workflow type
        - the general one can be use for many workflows
        - this is an `#OPEN/DISCUSSION`

[Hash Key Mutation] The rehashing logic mutates the canonical record's `.data` field (deletes and re-inserts hash key). This implies `CanonicalRecord` is not truly immutable, or that the struct itself is immutable but its contained dictionary is mutable. This surfaces a potential lifecycle ambiguity: when is a `CanonicalRecord` "frozen"? 
    - `#josePereiro/FEEDBACK`
        - `#josePereiro/ISSUE`
            - That is a problem
            - we should not mutate the record
            - we must create a new one instead
            - `#INVARIANT` once we create a record, it must be immutable and safe
            - we should work on a dict (independent copy), then create the record at the end


---

## Change 7: TaraSON Serialization Layer

**What Changed:**
- Moved `_tk_canonical_literal_stringify` and `_tk_unsafe_canonical_stringify` from `222.LiteRecords.canonical.repr.jl` to new file `300.TaraSON.base.jl`
- Introduced `tk_hashed_tarason` function: creates `HashedTaraSON` from `HashedRecord`, extracting hash from record data
- `HashedTaraSON` holds serialized string and hash

**Design Issues:**

[Serialization Scope] The creation of a dedicated TaraSON module suggests serialization is now a first-class concern, not just a utility. This raises the question: are other serialization formats contemplated? If so, how would they interact with the hashing and canonical pipeline?
    - `#josePereiro/FEEDBACK`
        - this is ok
        - `TaraSON` is the format of the cannonical record

[Hash Duplication] The hash is stored in both `HashedRecord.data` (as a field `"/__Tara/record.hash/sha256"`) and `HashedTaraSON.hash` (as a separate field). This redundancy surfaces a question: which is the authoritative hash? What happens if they diverge?
    - `#josePereiro/FEEDBACK`
        - this is an `#OPEN/DISCUSSION`
        - `#josePereiro/INVARIANT` I like that ALL the data is in the string representation
        - but having the hash as a separate field is more efficient for lookups
        - having both is a tradeoff

---

## Change 8: Tape Commit Semantics

**What Changed:**
- Introduced `Tape` type: holds `OrderedDict{String, Union{HashedTaraSON, CommitRecord}}`
- Introduced `tk_append!`: adds `HashedTaraSON` to tape, keyed by hash
- Introduced `tk_commit!`: computes commit hash from concatenated record hashes, creates `CommitRecord`, appends to tape
- `CommitRecord` holds `OrderedDict{String, String}` mapping commit hash to itself

**Design Issues:**

[Commit Hash Construction] The commit hash is computed by string-concatenating all record hashes in the tape. This implies:
  - Order matters (since concatenation is order-sensitive)
  - The commit hash is a cryptographic summary of the sequence, not the set, of records
  - If tape order changes (e.g., records reordered), commit hash changes, even if content is identical
      - `#josePereiro/FEEDBACK`
        - Yes, order matters
        - this is intentional
        - tapes are ordered collections

[Self-Referential Commit] `CommitRecord` maps `commit_hash => commit_hash`. This self-reference is unusual and raises the question: what is this mapping's purpose? Is it a placeholder for future metadata? Or does it serve as a structural marker?
    - `#josePereiro/FEEDBACK`
        - yes, `CommitRecord` are records reserved by the kernel
        - they can hold more metadata in the future
      

[Tape Mutability] `Tape` is constructed with an empty `OrderedDict` and mutated via `tk_append!` and `tk_commit!`. This surfaces a lifecycle question: when is a tape "closed"? Can records be appended after commit? If so, does a second commit invalidate the first? 
    - `#josePereiro/FEEDBACK`
        - `tapes` are mutable
        - you can append more records and commit again
        - a commit just hash locks the current state of the tape


## FURTHER ISSUES

[Types] Is the separation between `HashedRecord` (canonical dict + hash) and `HashedTaraSON` (serialized string + hash) justified by their distinct roles in validation vs. storage, or should these be unified?
    - `#josePerero/FEEDBACK`
        - they are two representations of the same data
        - one handle a julia runtime object representation
        - the other wrap a TaraSON string of bytes


[Magic Number] Post-canonicalization depth check `_tk_ensure_shallow` rejects flattened paths deeper than 10 segments
    - `#josePerero/FEEDBACK`
        - `#ISSUE`
            - we need clear justifications for this
            - otherwise it feels arbitrary
            - Also, users can encode deeper herarchy on keys anyway
            - I think it is better to be flexible now


[Design Principle] "checkpoints not continuous validation" model.
    - `#josePerero/FEEDBACK`
        - this is the correctness policy of the kernel at the moment
        - we validate immutable objects as we create them
        - one aspect at the time

[type explosion] The introduction of four new concrete types may indicate over-engineering if intermediate stages serve no validation or semantic purpose beyond code organization.
    - `#josePerero/FEEDBACK`
        - we are using the Julia type system to "store" previous validations


[Inheritance semantics] `Tape` inheriting from `AbstractCanonicalTaraRecord` may violate expectations if client code assumes all canonical records are single-record entities rather than collections.
    - `#josePerero/FEEDBACK`
        - We need to define what we want from the Tape
        - Later, we will be able to evaluate how "fit" a given data structure is
        - `#OPEN/DISCUSSION`

[depod type] `SortedDict{String, Union{Nothing, TaraSONPrimitive}}`
    - `#josePerero/FEEDBACK`
        - `#MAKE/ISSUE`
        - `TaraSONPrimitive` already include `Nothing`
        - Important that `TaraSONPrimitive` is a julia implementation object
        - No part of Kernel Spec

[type mapping] Are the JSON-Pointer-style key generation rules in `__flatten_col!` complete and unambiguous for all lite value types (dicts, arrays, tuples, NamedTuples)?
    - `#josePerero/FEEDBACK`
        - Ambiguity between Dict and NamedTuple keys:
            - Dicts with Symbol keys: When iterating with pairs(), Symbol keys remain as Symbols, then string(k) converts :key → "key"
            - NamedTuples: When iterating with pairs(), keys are also Symbols, then string(k) converts :key → "key"
            - Problem: A Dict with Symbol key :field and a NamedTuple with field field will generate identical JSON-Pointer paths (/field),
            despite being structurally different types. The sentinel markers (::DICT) are identical for both.
        - That is ok, `TaraSON` "understand" about dicts and arrays, like JSON
        - kernel is just mapping the hosting language types to `TaraSON`

[depot type] We are using `SortedDict`
    - `#josePerero/FEEDBACK`
        - `SortedDict` has O(log n) insertion vs. O(1) for `Dict`, which may impact canonicalization of large records.
        - We can use `LittleDict`
        - Which can be sorted
        - A record is a read only
        - `LittleDict` is fast for readings for short dicts
            - It do not need hashing
        - Also, it is memory effitient
        - `#OPEN/DISCUSSION`

[dataflow] The TaraSON string is computed *after* hashing, meaning `HashedTaraSON.data` includes the hash field. This differs from the hashing step, where the hash is excluded from the input.
    - `#josePerero/FEEDBACK`
        - `#josePerero/ISSUE`
            - I donàt like this
            - `HashedRecord` should already based on the bytes, no the Julia object
            - this is safest
            - `HashedRecord` vs `HashedTaraSON`
            - We may want both, but for this workflow `HashedTaraSON` fit better
            - we have a valid flat object `CanonicalRecord`
            - serialize to taraSON and hash can happend in one pass
            - no need for `HashedRecord`
                - why?
                - we serialize once
                - and work over string
                - `TaraSON` is defined as an string
                - an object is a view/projection

[round-tripping] Does the serialization format support round-tripping: can a `HashedTaraSON` string be parsed back into a `CanonicalRecord` with identical field values?** (Note: no deserialization is implemented in this PR)
    - `#josePerero/FEEDBACK`
        - About if we should support round-tripping
        - I think byte to byte yes
        - I think byte to `CanonicalRecord` yes
        - original object no

[datatype] The `Tape` type is a simple `OrderedDict` wrapper. Records and commits share the same namespace (both use hash strings as keys), and the type distinguishes them (`HashedTaraSON` vs. `CommitRecord`).
    - `#josePerero/FEEDBACK`
        - `#josePerero/ISSUE`
            - Tapes as `TaraSON` also
            - As runtime structure 
                - pros
                    - append capability
                    - hash based indexing
                - cons
                    - record data do not has hash 
                    - hash data is on Tape level
                    - violate the "all data is on records"
            - As JSON mapped disk backend 
                - pros
                    - need a unique parser
                - cons
                    - JSON do not garanty order
                        - force us to add index at record key
                    - partial reading hard
                    - no append friendly