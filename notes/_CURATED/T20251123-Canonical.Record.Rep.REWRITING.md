# Canonical Record Representation

- A canonical Record is defined as a **single, flat TaraSON object**.
- It define by its String (character sequence) representation.
- No nested structures are allowed (flat); any structural hierarchy must be encoded in **key names**.
    - e.g., `TaraSON://lv1/lv2/keyname`
- All values must be **lite** (see the `LiteSpec`)
- A Record must be **deterministic**:
    - keys sorted lexicographically,
    - stable whitespace and formatting.
- The canonical form is the basis for computing the **content hash**.
    - The content hash depends only on this canonical expansion.
- The canonical representation does not include storage-dependent fields, user-dependent formatting, or dynamic metadata.

---
- # NOTE
- `#NEW` `#TODO/UPDATE/REST`
- The tape on disk, will only store canonical records
- we probably will need to include on the kernel an `IncludeLink`
-- We need it to allow pairs-level dedup
- We need to canonisize anyway to hash
- herarchical info is stored on each pairs
    - reduce corruption risk
    - make easier recoveries
- fit perfectly with `LittleDict` two vector implementation
- Only `DynamicLiteRecord` will have non canonical depots



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

# Notes

- The canonical form defines the universal comparison basis for Records and segments.
- Canonical representation applies uniformly across all Tapes in the system.
- The canonical model guarantees reproducibility, stable addressing, and interoperability across implementations.

---

# OUTDATED IDEAS

- **Implicit suggestion that segments may contain non-canonical, nested structures.**  
    - Canonical TaraSON is strictly flat; any nested representation is now fully removed.
- **Earlier implication that link traversal might be performed during canonicalization.**  
    - Current architecture stops canonical expansion at the first reference.
- **Old assumption that segment interpretation might include parent/child inference.**  
    - Kernel now mandates zero structural inference; relationships must be explicit in data.
- **Suggestion that physical Tape layout could influence canonical identity.**  
    - Canonical identity now depends only on canonical bytes; physical layout is irrelevant.
