# TaraKernel.jl — Design Principles Overview  

This summary zooms in on **TaraKernel.jl** itself: what role it plays, and which *design choices* shape its implementation. It’s meant for someone who already knows the Tara idea at a high level.

---

## 1. Role in the Stack: “Plumbing, Not Policy”

**TaraKernel.jl = Julia implementation of the Tara storage model.**

Its job is to:

- implement **Records**, **Tapes**, and **TaraSON** in Julia;
- provide a **strict, boring, low-level substrate** with clear guarantees;
- avoid any domain-specific semantics (no “Issues”, no “Scopes”, no application logic).

Everything higher-level (Simuleos, recorders, UIs, analysis tools) should:

- **use** TaraKernel,  
- **not redefine** its notions of Record/Tape/TaraSON,  
- treat it like a **stable storage engine** for context.

---

## 2. Canonical Records & Content Addressing

Core idea: a Record has **one canonical form**.

- A canonical Record is a **single flat TaraSON object**:
  - no nested JSON trees; hierarchy is encoded in the keys (`"sim.param.alpha"` rather than nested objects);
  - only **lite types** are allowed (numbers, strings, booleans, small arrays, shallow dicts);
  - keys are sorted, values are normalized → deterministic byte sequence.

From this, TaraKernel derives a **content ID** (hash):

> **Same meaning → same canonical bytes → same hash.**

Design consequences:

- Deduplication is trivial: identical records share the same ID.
- Equality and comparison are robust (you compare hashes).
- The ID depends only on the canonical payload, not file layout or physical storage.

---

## 3. Tapes: Append-Only Streams of Canonical Payloads

TaraKernel models storage through **Tapes**:

- A Tape is an **ordered sequence of segments**; each segment holds a list of canonical records.
- Tapes are **append-only** at the logical level.
- The kernel is **agnostic** about structure between records:
  - parent–child relationships, threading, or workflows are encoded as *data fields* (e.g. `"parent_id"`), not in the Tape machinery itself.
- A Tape is valid if:
  - each record expands to a valid canonical TaraSON payload,
  - and its ID matches the hash of that payload.

Key principle:

> **Physical layout is an implementation detail; logical identity is canonical content + hash.**

So you can compress, repack, chunk, or deduplicate on disk, as long as you can reconstruct the same canonical records with the same IDs.

---

## 4. LiteRecords & LiteTapes: A Small, Strict Core

Internally, TaraKernel centers on two main building blocks:

- **LiteRecords**  
  In-memory representation of canonical Tara **Records**:
  - flat key–value maps,
  - TaraSON-compatible types only,
  - behave like strict dictionaries.

- **LiteTapes**  
  In-memory representation of Tara **Tapes** and their segment structure.

Design goals:

- **Tiny and predictable core**
  - No hidden metadata blocks.
  - No embedded schemas.
  - No complex query language.
- **No per-record history**
  - Commit and immutability semantics belong to the **Tape layer**, not the LiteRecord object itself.
- **Flat and explicit**
  - Any richer structure is left to higher layers (recorders, applications).

Idea: everything you want to do with context in the ecosystem should be implementable **on top of** LiteRecords/LiteTapes, without changing their semantics.

---

## 5. “Plumbing, Not Policy” Applied

TaraKernel deliberately follows a Git-like philosophy:

> **Being wrong is worse than being inconvenient.  
> If you touch the plumbing, you are responsible for the consequences.**

In practice this means:

- **Strict invariants**:
  - records must be lite and canonical,
  - Tapes are sequences of valid segments,
  - hashes must match canonical content.
- **No silent fixes**:
  - no automatic correction of invalid data,
  - no hidden type conversions or migrations.
- **No high-level semantics baked in**:
  - no built-in understanding of “Issue”, “Scope”, or “ContextRecorder”.

TaraKernel says: *“Here is a small, very clear contract. If you obey it, you get strong guarantees. If not, you get errors, not magic.”*

---

## 6. Compression & Repacking: First-Class but Invisible

TaraKernel supports **JIT-style compaction** at the Tape/Segment level:

- Initially, Tapes grow as naïve append-only logs.
- Later, a **repack** pass can:
  - deduplicate identical ContextRecords,
  - merge compatible segments,
  - improve locality and reading performance.

Design constraint:

- Repacking must preserve **canonical payloads and their IDs**.
- From the kernel’s point of view, a repacked Tape is just an equivalent logical Tape.

So optimization is encouraged, but always **semantically invisible** to users of TaraKernel.

---

## 7. Clear Layer Boundaries

TaraKernel is carefully separated from higher layers:

- **Specs layer (Tara Project)**  
  Defines abstract notions: Records, Tapes, TaraSON.

- **Kernel layer (TaraKernel.jl)**  
  Exactly implements those notions:
  - LiteRecords, LiteTapes,
  - canonicalization,
  - content hashing,
  - Tape operations.

- **Recorder layer (e.g. Simuleos)**  
  Works with Scopes, Issues, hooks, and context extraction **on top of** TaraKernel.

Rules:

- TaraKernel must not depend on recorder-specific concepts.
- Recorders must not redefine Record/Tape semantics; they rely on kernel invariants.

This layering keeps the implementation **modular**, **testable**, and **evolvable**.

---

## 8. Minimal Julia Surface, Maximum Stability

From a Julia-package perspective, TaraKernel aims to be:

- **Small and explicit**:
  - a central `TaraKernel` module that mainly exposes types and core operations, not a huge tangled API.
- **Light on dependencies**:
  - only essential libraries (e.g. utilities for exports); no heavy stack.
- **Version-stable**:
  - semantics that match Tara specs and change rarely, so other packages can treat TaraKernel as a long-term dependency.

The emphasis is on:

> **A small, boring, highly reliable surface that you can build serious tools on.**

---

## 9. What TaraKernel.jl Wants to Be — In One Sentence

> **TaraKernel.jl is the strict, content-addressed storage engine for context: it turns flat, lite TaraSON objects into immutable, hashed segments on Tapes — and nothing more.**

Everything else (Scopes, Issues, workflows, GUIs, ML tools) is deliberately left to other layers, so that TaraKernel can stay correct, predictable, and trustworthy.
