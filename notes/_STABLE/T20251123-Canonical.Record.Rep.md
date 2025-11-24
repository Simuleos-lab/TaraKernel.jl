# Canonical Record Representation

- A canonical Record is defined as a **single, flat TaraSON object**.
- No nested structures are allowed; any structural hierarchy must be encoded in **key names**.
    - e.g., `lv1:lv2:keyname`
- All values must be **lite** (TaraSON-approved types): numbers, strings, booleans, small arrays, flat dictionaries.
- A Record must be **deterministic**:
    - keys sorted lexicographically,
    - values normalized according to the TaraSON canonical rules,
    - stable whitespace and formatting.
- The canonical form is the basis for computing the **content identifier**.
    - The content identifier depends only on this canonical expansion.
- The canonical representation does not include storage-dependent fields, user-dependent formatting, or dynamic metadata.

---

# Links and External References

- Records may contain references to external Artifacts through **identifier fields**.
- Link representation is **pure data**:
    - a link is represented as a lite string value (e.g., an Artifact hash or Tape location).
- Links must not trigger expansion inside the canonical form.
- Link traversal is not part of canonical representation.
    - Canonical expansion stops at the first reference.
- No embedded Records are allowed.
    - All child Records must be independent canonical units.

---

# Canonical View Rules

- A canonical view is always a **single flat TaraSON map**.
- Any representation that is not flat must be converted to the canonical flattened form before hashing or exchanging.
- The canonical view is used for:
    - hashing,
    - replication,
    - deduplication,
    - Tape-level semantic equivalence checks.
- Two Records are canonically equivalent if their canonical forms are bytewise identical.

---

# Segment-Level Interpretation

- The kernel treats each segment as containing exactly one canonical TaraSON payload.
- Segment content must be self-contained and valid as canonical TaraSON.
- No implicit parent/child relationships are permitted at the segment level.
- The kernel does not infer structure between segments; all relationships must be encoded as data.
- A Tape is valid if **each segment expands to a valid canonical TaraSON payload** with its corresponding content identifier.

---

# Compressed or Transformed Tapes

- The kernel does not distinguish between compressed, repacked, chunked, or transformed Tape layouts.
- A Tape is considered valid if:
    - every segment can be reconstructed to its canonical TaraSON payload,
    - the content identifier for each segment matches its canonical expansion.
- The physical shape of the Tape (compression, deduplication, packing strategy) is irrelevant to the kernel.
- Only the logical, canonical payload matters.

---

# Notes

- The canonical form defines the universal comparison basis for Records and segments.
- Canonical representation applies uniformly across all Tapes in the system.
- The canonical model guarantees reproducibility, stable addressing, and interoperability across implementations.
