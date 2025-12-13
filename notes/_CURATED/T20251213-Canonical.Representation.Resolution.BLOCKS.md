## Canonical Representation: Resolution Levels

- #MODEL
- The notion of *canonical representation* exists at multiple, coherent resolution levels.
- Each level is a faithful projection of the one below it.
- Canonical identity is ultimately anchored at the byte level.

---

### Canonical Bytes

- **Type**: Authoritative Representation
- The **canonical bytes** of a record are the unique **TaraSON-formatted byte sequence** representing that record.
- Canonical bytes:
    - define record identity,
    - are the sole input to hashing and Merkle constructions,
    - are what is retorned by Tapes and validated by the kernel.
- Two records are canonically identical *iff* their canonical bytes are bytewise identical.
- This is the highest-resolution and authoritative form of canonical representation.

---

### Canonical View

- **Type**: Structural Representation
- A **canonical view** is a runtime data structure that represents the canonical bytes in a convenient, structured form.
- It consists of:
    - a flat, ordered collection of `(key, primitive)` pairs,
    - keys as valid `JSON-Pointer`s,
    - values as lite primitives.
- The canonical view:
    - preserves ordering required for deterministic serialization,
    - round-trips losslessly to the same canonical bytes.
- Example:
    - a `CanonicalRecord` object.
- The canonical view is *not* authoritative; it derives all meaning from the canonical bytes it represents.

---

### Canonical-Capable Object

- **Type**: API / Contractual Representation
- A **canonical-capable object** is a runtime object that is **guaranteed by contract** to produce canonical bytes.
- Such objects:
    - may use free or nested runtime structures,
    - are not required to be flat or ordered internally,
    - must admit a deterministic canonicalization procedure.
- Canonical-capable objects do not define identity directly.
- Example:
    - `LiteRecord` objects.
- Canonical identity becomes fixed only when a canonical-capable object is projected into its canonical bytes.

---

### Resolution Ordering

- #INVARIANT
- The resolution order is strictly:
    - Canonical-Capable Object
    - Canonical View
    - Canonical Bytes
- Authority increases monotonically with resolution.
- Identity exists only at the Canonical Bytes level.
