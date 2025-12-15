***
## LiteRecords: Runtime Representation

- Runtime `LiteRecord`s may use **nested LiteSpec-compatible structures**:
  - nested dictionaries,
  - arrays,
  - tuples / NamedTuples,
  - other host-language convenience shapes.
- Runtime representation may be:
  - mutable (eg. `DynamicLiteRecord`),
  - immutable (eg. `StaticLiteRecord`),
  - flexible,
  - host-language specific.
- While under kernel authority, runtime records must satisfy:
  - `tk_islite(record) == true`,
  - a deterministic `canonical(record)` can be produced when required
    (eg. at commit or validation boundaries).


***
## LiteRecords: Invariant

For any runtime record `r`:

`hash(r) = H(serialize(canonical(r)))`

- Two runtime records are canonically equivalent *iff* their canonical byte representations are identical.
- Runtime shape is never semantically relevant beyond its canonical projection.

***
## LiteRecords: Canonical Identity Invariant

- For any runtime record `r` that admits canonicalization:
- `H(serialize(canonical(r)))` defines the **sole identity basis** of `r`.

- Two runtime records are canonically equivalent *iff* their canonical byte representations are identical.
- Canonical identity depends only on canonical bytes, never on runtime structure.
- Runtime shape, ordering, or representation is semantically irrelevant for kernel **hashing and equivalence**, and remains meaningful only prior to canonical projection.

***
## LiteRecords: LiteSpec

- A data value/object/struct is considered *lite* if it can be deterministically
  encoded into a TaraSON-compatible form and canonically flattened.
- LiteSpec defines an **admissibility boundary**, not a semantic model.

- A lite value MAY be representable at runtime as:
    - a single JSON literal
        - scalar, boolean, or null
        - string
            - limited length
                - `#OPTIONAL`
    - arrays
        - elements MUST themselves be lite
        - no semantic guarantees are attached to array structure
        - length, homogeneity, or recursion limits are implementation-defined
            - `#OPTIONAL`
    - nested lite objects (dicts)
        - values MUST themselves be lite
        - nesting carries no canonical or semantic meaning
        - depth and size limits are implementation-defined
            - `#OPTIONAL`

- LiteSpec places **no requirements** on runtime structure beyond:
    - canonicalization must exist,
    - canonicalization must be deterministic,
    - non-lite values are rejected at kernel boundaries.

- Any implementation of `TaraKernel` defines:
    - how runtime, language-specific values map to lite encodings,
    - how `tk_islite` is enforced,
    - and which optional limits are applied.


***
## LiteRecords: TaraSON

- `TaraSON` is a flat key–value data format.
- Keys are strings interpreted as `JSON-Pointer`s.
- Values are lite primitives, as defined by the `LiteSpec`.
- The format is a JSON-compatible representation.
- `TaraSON` is an encoding format for the Canonical Records

***
## LiteRecords: Canonical and Free representation

- Any `LiteRecord` admits a representational form.
- A representation may be `Free` or `Canonical`.
- The `CanonicalRep` is defined by the Canonical Record specification.
- The `FreeRep` is any runtime representation that is **lite** and canonizable,
- but is not required to be flat or deterministic.
- A `FreeRep` may be nested, unordered, and language-dependent.
- The kernel compares identity only through `CanonicalRep`.
- Two `LiteRecord`s are equivalent under the kernel iff their `CanonicalRep` byte representations are identical.

***
## LiteRecords: Runtime Records

**LiteRecord**

* A runtime structure representing a TaraSON-derived record.
* LiteRecords may use free-form, nested, or language-specific shapes
  * but MUST be canonizable to a valid canonical TaraSON representation.
* LiteRecords contain only lite values, as defined by the LiteSpec.

**StaticLiteRecord**

- A LiteRecord whose content identity has been fixed by canonicalization and hashing.
- Carries a content-derived hash associated with its canonical representation.
- Immutable under kernel authority.
- Always attached to a TapeSegment.
- The only record form returned when reading from Storaged Tapes.

**DynamicLiteRecord**

- Exists only at runtime.
- A mutable LiteRecord used as a staging object prior to commit.
- May be incrementally constructed, transformed, or validated.
- Before appending, it is canonicalized and promoted to a StaticLiteRecord.
- The forward flow is:
    - DynamicLiteRecord → StaticLiteRecord → append → SegmentTail → commit
- The reverse flow:
    - StaticLiteRecord → DynamicLiteRecord
    - is outside kernel authority and forbidden by default,
    - or explicitly marked as unsafe and non-kernel.
