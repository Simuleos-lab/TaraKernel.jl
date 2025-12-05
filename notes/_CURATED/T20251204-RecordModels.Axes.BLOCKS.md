# Axis.DynamicVsCommitted
* **Name**: Dynamic vs Committed
* **Type**: Ontology.Axis
* **Purpose**: Separate mutable runtime entities from immutable content-addressed entities.
* **Definition**:
    * This axis distinguishes whether a record is still mutable and evolving, or has been finalized and frozen by content hashing.
* **States**:
    * **Dynamic**
        * Mutable
        * Not content-addressed
        * Semantics may still change
        * Represents in-progress or working data
    * **Committed**
        * Immutable by policy
        * Identity derived from content hash
        * Equivalent to a git-commit-like object
        * Denotes semantic finalization
* **Notes**:
    * Committed is a *subset of Static*.
    * Not all static objects are committed; committed implies identity + immutability.

---

# Axis.RuntimeVsStorage
- **Name**: Runtime vs Storage
- **Type**: Ontology.Axis
- **Purpose**: Distinguish in-memory existence from persistence.
- **Definition**:
    - This axis describes whether a record exists transiently in memory or has been persisted to a backend.
- **States**:
    * **Runtime**
        * Lives in RAM
        * Local to process / task / pipeline
        * Can be ephemeral or transitional
    * **Storage**
        * Persisted externally
        * Located on tape segments, files, or object stores
        * Survives process lifetime

---

# Axis.FreeVsCanonical
* **Name**: Free Form vs Canonical
* **Type**: Ontology.Axis
* **Purpose**: 
    * Distinguish informal runtime representation from normalized semantic representation.
* **Definition**:
    * This axis separates representation flexibility from deterministic encoding.
* **States**:
    * **Free form**
        * May be nested
        * Ordering is arbitrary
        * Can hold runtime objects (Date, UUID, structs, etc.)
        * Only required to obey LiteSpec
    * **Canonical form**
        * Flat representation
        * Deterministic encoding
        * TaraSON compatible
        * Used for hashing, identity, comparison, and persistence

---

# Concept.DynamicRecord
- **Name**: DynamicRecord
- **Type**: Ontology.Role
- **Purpose**: Primary runtime manipulation object.

- **Position in Axes**:
    * Dynamic
    * Runtime
    * Free form (typically)
- **Definition**:
    * A Detached, mutable record used as the main user-level data structure.
- **Guarantees**:
    * May violate canonical form temporarily
    * Enforces LiteSpec only
    * Is intended as editing / transformation substrate

---

# Concept.CommittedRecord
- **Name**: CommittedRecord
- **Type**: Ontology.Role
- **Purpose**: Represent finalized, hash-addressed records.
- **Position in Axes**:
    * Committed
    * Runtime or Storage
    * Always Canonical
- **Definition**:
    * A record whose identity is derived from its content and whose semantics may no longer change.
- **Variants**:
    * Runtime-Committed
        - Content-addressed but not yet persisted
    * Storage-Committed
        - Content-addressed and persisted on backend
- **Guarantees**:
    * Immutable
    * Deterministic identity
    * Canonical payload
    * Referentially stable

---

# Concept.CanonicalRecord
    - **Name**: Canonical Form
    - **Type**: Ontology.Representation
    - **Purpose**: Normalize semantic equality.
- **Definition**:
    - Canonical form is not a record *type* but a representation state:
    - a flattened TaraSON-compatible mapping used for hashing and equality.
- **Notes**:
    * A canonical object may:
        * Be runtime or stored
        * Be static or not yet committed
    * In practice canonical form is enforced for:
        * Storage
        * Commit
        * Hashing
        * Deduplication

---

# Relation.AxesIndependence
* **Name**: Axes Are Orthogonal
* **Type**: Ontology.Relation
* **Definition**:
    - The three axes are independent and may compose freely.
- **Examples**:
| State                    | Possible? |
| ------------------------ | --------- |
| Dynamic + Runtime        | Yes       |
| Committed + Runtime      | Yes       |
| Committed + Storage      | Yes       |
| Canonical + Dynamic      | Yes       |
| Canonical + Static       | Yes       |
| Static but not Committed | Yes       |

---

# Constraint.CommittedImpliesCanonical
- **Name**: Committed ⇒ Canonical
- **Type**: Ontology.Constraint
- **Rule**:
    - All committed records MUST have a canonical form.
- **Justification**:
    - Content hashing is only valid on normalized representation.

---

# Constraint.CommittedImpliesStatic
- **Name**: Committed ⊂ Static
- **Type**: Ontology.Constraint
- **Rule**:
    - All committed records are static, but not all static records are committed.
- **Justification**:
    - Static ≈ frozen snapshot
    - Committed ≈ frozen snapshot + identity

---