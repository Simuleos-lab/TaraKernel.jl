# **ContextRecord — Kernel Note**

## **FORMAL DEFINITION**

* A ContextRecord is the **concrete, serialized representation** of the contextual data describing a single Issue. `#LIKED`
* Several ContextRecords might be talking about the same Issue. `#LIKED`
* It is recommended that each ContextRecord describes a single Issue. `#LIKED`
* It is encoded strictly as a **TaraSON object** (lite, deterministic, shallow, JSON-compatible). `#LIKED`
* It contains all lite information available to **identify, describe, and interpret** the Issue. `#LIKED`
* It is **immutable** once created; any further interpretation generates a new ContextRecord. `#LIKED`
* It is the **atomic unit** of storage, exchange, hashing, and indexing in the Tara ecosystem.
* It exists as a **standalone object**, independent of the program or environment that generated it.
* It is a **lite blob** that can be embedded in tapes, registries, or any Tara-compatible storage backend.

---

## **WHY DOES IT EXIST?**

* To provide a **durable, portable, description** of an Issue.
* It whould be **unambiguous**, but this is an User responsability. `#LIKED`
* `Tara` implementations should waranty the `durable` and `portable` part. `#LIKED`
* To unify data coming from heterogeneous tools through a **shared format** (TaraSON).
* To separate **the event** (Issue) from **its description** (ContextRecord). `#LIKED`
* To enable **interoperability** across recorders, platforms, and contexts. `#LIKED`
* To support **cross-modal searches**, merging, provenance tracking, and semantic queries. `#LIKED`
* To ensure that contextual information persists even if the original environment disappears. `#LIKED`
* To enable content hashing, deduplication, and deterministic reconstruction of meaning. `#LIKED`
* To act as the fundamental **boundary object** linking human reasoning, machine reasoning, and storage systems. `#LIKED/ALOT`

---

## **ESSENTIAL PROPERTIES**

* **Lite**: Only TaraSON-approved types (numbers, strings, small vectors, shallow dicts, lite blobs). `#FUNDAMENTAL`
    * The intend is that, a human should always be able manage the amount of information stored on a `ContextRecord`.
        * Both because of the data type/format
        * Also because the data quantity on a single ContextRecord
* **Deterministic**: Same data → same representation → same hash.
* **Immutable**: Never mutated after creation.
* **Self-contained**: Includes all lite information needed to interpret the Issue without external runtime state.
* **Semantic**: Contains data chosen because it *helps explain or identify the Issue*.
* **Portable**: Tool-agnostic and parseable anywhere.
* **Serializable**: Always representable as valid TaraSON.
* **Queryable**: Structured so it can be indexed and searched efficiently.
* **Attachable**: Can have links to external Artifacts (non-lite data).
* **Bounded**: Should describes exactly one Issue; ambiguity or aggregation are not enforced but are discouraged.

---

## **FINAL DEFINITION (COMPACT)**

* **A ContextRecord is the immutable, TaraSON-encoded, lite data object that concretely constitude a description fraction for a single Issue and serves as the fundamental, portable unit of meaning, interoperability, and storage in the Tara ecosystem.**

