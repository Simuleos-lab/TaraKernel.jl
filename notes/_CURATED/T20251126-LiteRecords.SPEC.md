# LiteRecords

## Runtime vs Canonical Representation

### Runtime Representation

- `#NEED/REFRESH`
- Runtime `LiteRecord`s may use **nested LiteSpec structures**:
  - nested dictionaries,
  - arrays,
  - tuples / NamedTuples,
  - language-level convenience shapes.
- Runtime representation might be:
  - mutable (eg. `DynamicLiteRecord`),
  - immutable (eg. `StaticLiteRecord`),
  - flexible,
  - host-language specific.
- Runtime objects must satisfy:
  - `tk_islite(record) == true`,
  - `canonical(record)` exists and is deterministic.

### Canonical Representation

- A **Canonical Record** is a flat `TaraSON` object:
  - a map `jsonpointer_key :: String => primitive :: AbstractTaraPrimitive`,
  - no nested dicts,
  - no arrays,
  - no composite structures.
- Hierarchy and structure are encoded **only in key paths**.
- The canonical form is:
  - deterministic,
  - byte-stable,
  - independent of runtime shape.

### Invariant

For any runtime record `r`:

`hash(r) = H(serialize(canonical(r)))`

- Two runtime records are canonically equivalent *iff* their canonical byte representations are identical.
- Runtime shape is never semantically relevant beyond its canonical projection.

---

## LiteSpec

* A data value/object/struct is lite if it can be encoded as:
* a single `JSON` literal
    * scalar, boolean, null
    * string
        * limited length
            * `#OPTIONAL`
* arrays
    * **default (strict) rule**:
        * `#CURRENT`
        * can include only literals
        * `[1,2,3,4]` is lite
        * `[1,[2],[3,4]]` is non-lite
    * **recursive rule**:
        * `#EXPERIMENTAL`
        * arrays MAY include other lite arrays or lite dicts
        * `[1,[2],[3,4]]` becomes lite under this rule
    * type homogeneous
        * `#OPTIONAL`
    * limited length
        * `#OPTIONAL`
* nested lite objects (dicts)
    * can include as children any other lite object
        * for instance:
        * `{"A": [1], "B": {"C": 1}, "C": 1}`
    * limited deep and/or length
        * `#OPTIONAL`
* Any implementation of `TaraKernel` will decide a mapping from
  runtime, language-specific data types to its lite encoding.


---

## TaraSON

- An object is coded in `TaraSON` if:
    - It is JSON compatible
    - Is itself complaiant of the `LiteSpec`

## Canonical and Free representation

- Any `LiteRecord` must have an string representation
- This representation can be `Free` or `Canonical`
- The `CanonicalRep` is defined at [[T20251123-Canonical.Record.Rep.Spec.md]]
- The `FreeRep` representation is just a non canonical TaraSON object string representation
- Two objects with different representations
    - different string representations
- are "semantically" the same if:
    - has the same `CanonicalRep`


## Runtime

**LiteRecord**

* The minimal structure representing a canonical TaraSON object.
* LiteRecords contain only lite fields (eg. strings, numbers, booleans, small vectors, small dicts).

**StaticLiteRecord**

- A LiteRecord with a content derived hash.
    - the hash is stored into the record data
    - Immutable and always attached/related/linked to a segment.
    - The only record type exposed when reading from tapes.

**DynamicLiteRecord**

- Only posible at runtime
- A mutable LiteRecord intended as "stage" object before commiting to a segment.
- before appended, it is promoted to a StaticLiteRecord.
- One information flow is: 
    - DynamicRecord -> StaticRecord -> append -> SegmentTail -> commit
- The reverse direction
    - StaticRecord -> DynamicRecord
        - is forbident  `#OPTIONAL`
        - or, mark as `unsafe` `#OPTIONAL`
