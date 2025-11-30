Below is a **direct, compact, enumerated list** of the **main conceptual objects** in the project (Simuleos + Tara), extracted from the notes you provided.
Everything listed is a *named concept* with a well-defined role.
Citations refer to your uploaded notes.

---

# **Main Conceptual Objects (Enumerated List)**

## **1. Issue**

The *thing being described*. A discrete event/state/action/moment that warrants contextualization.


## **2. ContextRecord**

The immutable, lite, TaraSON-encoded description of a single Issue.
Atomic unit of context, hashing, storage, and interoperability.


## **3. Contextual Data**

All **lite** data that helps *explain, interpret, or identify* an Issue (parameters, metadata, lite results, notes).
Includes lite primary results if they are meaningful.


## **4. TaraSON**

Unified Context Protocol: strict, JSON-compatible, deterministic lite format used by all recorders.


## **5. The Tara Project**

Umbrella project defining the universal protocol, recorder ecosystem, storage conventions, and semantic model of context.


## **6. Recorder**

Any tool that emits TaraSON records (Simuleos, Obsidian collector, journaling tools, sensor collectors…).


## **7. Simuleos**

A recorder specialized for simulation workflows.
Extracts Scopes, turns them into ContextRecords via hooks, and stores them using tapes.


## **8. Scope**

A Dict-like snapshot of the program’s state at a specific moment (locals, globals, metadata).
Input for the hook pipeline.
Immutable for hooks.


## **9. @sim_scope**

Macro that marks the moment of scope capture → defines a new Issue and triggers hook processing.


## **10. Labels**

Special markers (e.g., `_sim_label_HASH`) identifying scope capture regions. Used by Guard hooks for validation.


## **11. Hook System**

Pipeline applied to each captured Scope. Contains three conceptual hook types:

* **Guard Hooks** — validate scope, enforce lite rules and labels.
* **Transform Hooks** — convert Scope → ContextRecord (derivations, hashing, extraction).
* **Sink Hooks** — store ContextRecord (tapes, logs, registries).


## **12. Lite Discipline**

The structural constraint that only JSON-compatible, shallow, deterministic data is allowed inside ContextRecords.
Defines what can be stored as context.


## **13. Tara Ecosystem Provenance Graph**

Implicit graph where Issues (nodes) are connected through contextual references, lineage, and relationships.


## **14. Artifact**

Non-lite data associated with an Issue (e.g., heavy arrays, binary files). Referenced by ContextRecords but not embedded.


## **15. LiteRecord**

Tier-0 JSON-like key–value container (strings, numbers, small arrays, lite dicts). Foundation for ContextRecord encoding.


## **16. StaticBlob / DynamicBlob**

Two blob flavors:

* **StaticBlob** — immutable, content-hash named.
* **DynamicBlob** — mutable, identified by an ID, can be committed to produce a StaticBlob.


## **17. LiteRecordArray**

Array of LiteRecords stored in batch files (.jsonl).
Used inside LiteTapeSegment structures.


## **18. LiteTapeLib**

The root object pointing to the directory storing batches.
Entry point of storage.


## **19. LiteTapeSegment**

A batch file storing multiple blobs (ContextRecords).
Append-only, identified by a timestamp and batch metadata.


## **20. LiteTapeRecord**

A wrapper representing a single blob inside a batch.
Holds the LiteRecord plus metadata like object keys.


## **21. Content Hash**

Deterministic hash of a blob’s content, used for immutability, deduplication, and naming.
Used heavily for StaticBlobs and for ContextRecords.


## **22. Masking Hash Technique**

Hashing scheme where the hash field inside metadata is temporarily replaced with a null-hash during hash computation.
Ensures deterministic self-hashing.


## **23. Universal Context Tree (global space)**

Concept describing a potential global, content-addressable tree linking all contextual objects across sources (inspired by IPFS, Keybase).


## **24. Kernel Notes**

Structured, flat, human/LLM-readable notes containing tagged, persistent ideas.
Define collaboration rules, design specs, and conceptual definitions.


## **25. Tags (e.g., #IMPORTANT, #LAW, #DECISION, #LIKED)**

Priority-driven mechanism for persistently encoding semantics inside kernel notes.


## **26. The Two Dimensions of Contextuality**

* **Structural:** lite discipline.
* **Intentional:** semantic role (helps interpret Issue).


## **27. BinNode / Binary Data Descriptor**

ContextRecord describing how to load or reference heavy binary data. Uses keys like `"__type__": "BinNode"` and `"load.path"`.


## **28. ContextRecord**

Generalized Dict-like object extended with custom value-resolution and indexing; used for internal context tree representation.


## **29. Scope Engine**

Coordinated mechanism orchestrating scope extraction, hook invocation, validation, and storage.


## **30. Provenance / Lineage Chain**

Chain of relationships between Issues created through contextual references and hashes.


## **31. Ownership / Cryptographic Identity**

Future feature: cryptographic signatures to identify authorship and ensure integrity of content-addressed records.


## **32. Event Model**

System where each `@sim_scope` triggers an event consumed by matching hooks.


## **33. Storage Backends**

Any system capable of storing TaraSON (tapes, git, cloud sync, registries). The protocol abstracts over them.


## **34. Context Extraction Pipeline**

Process converting raw Scope → validated → lite → contextual → serialized ContextRecord.


## **35. Recorder Configuration**

Declarative description of which hooks run, their match rules, and ordering.


## **36. Semantic Gradient (raw → derived → context)**

Conceptual model describing the continuum from raw data to contextual meaning.

