# TaraKernel — Conceptual Overview

## What Problem This Project Addresses

Long‑lived projects—scientific, computational, or creative—inevitably accumulate data, intermediate states, mistakes, partial results, and abandoned paths. These traces are often as informative as the final outcome. Over time, however, our *interpretation* of that material evolves: new theories emerge, better tools appear, and earlier assumptions are revised or discarded.

What should not change is the record of **what actually happened**. Yet most systems blur this distinction, constantly rewriting history in the name of cleanup, refactoring, or reinterpretation.

TaraKernel is an attempt to build a **minimal, immutable memory substrate** whose sole responsibility is to preserve raw facts exactly as they occurred. It deliberately avoids embedding meaning, interpretation, or schema, so that future tools, analyses, and perspectives can reinterpret the past without ever rewriting it.

---

## The Core Idea

**TaraKernel is a small, strict kernel that records data as immutable, content‑addressed facts, while leaving all meaning and interpretation to higher layers.**

The kernel defines authority, identity, and invariants. It answers questions like *“What was recorded?”*, *“In what order?”*, and *“Has this been altered?”*. Everything else—querying, semantics, structure, visualization, and user interaction—lives explicitly outside of it.

---

## Kernel vs. Everything Else

The system is intentionally divided into two clearly separated worlds:

**The Kernel**

* Defines which data transitions are allowed and which are forbidden.
* Fixes identity through deterministic canonicalization and hashing.
* Enforces immutability and strictly append‑only history.
* Understands *no domain semantics* and makes no assumptions about meaning.

**Everything Above the Kernel**

* Interpretation, schema, querying, visualization, and intent.
* Free to evolve, improve, and even contradict earlier interpretations.
* Able to add structure, convenience, and meaning.
* Never allowed to rewrite kernel‑recorded history.

The kernel does not explain data. It does not optimize or curate narratives. It only guarantees *what was recorded* and that it has not been silently changed.

---

## What the Kernel Actually Handles

The kernel operates over a deliberately small set of purely structural elements:

* **Records** — small “lite” data objects that can be deterministically canonicalized.
* **Segments** — ordered groups of records, sealed by a commit hash that binds their content.
* **Tapes** — ordered, append‑only sequences of segments.
* **Tape Libraries** — collections of tapes.

These structures define **ordering and containment only**. They introduce no relationships, no hierarchy beyond sequence, and no interpretation. Any notion of meaning must be encoded explicitly as data and interpreted elsewhere.

---

## Canonical Representation: Why Everything Is Flat

Before data becomes authoritative, it is converted into a **canonical flat representation** (called *TaraSON*): a deterministic list of key–value facts.

At this level there are:

* No nested objects
* No arrays
* No language‑specific structures

Flattening removes ambiguity. It guarantees deterministic serialization, stable hashing, and language‑agnostic identity. Any higher‑level structure—lists, trees, objects—is reconstructed *outside* the kernel, where such abstractions can change without affecting historical identity.

---

## Identity, Hashing, and Immutability

All kernel identity is **content‑derived** and mechanically enforced:

* Records are hashed from their canonical byte representation.
* Segment hashes are computed from the ordered sequence of record hashes they contain.
* Tape hashes are computed from the ordered sequence of segment hashes.

This Merkle‑style structure makes history rewriting practically impossible. Changing past content necessarily invalidates every dependent hash, propagating the cost of alteration forward. Importantly, these hashes are not kept as external metadata: they are stored as **regular records**, embedded directly in the ordered sequence of records itself. As a result, hashes are subject to the same append‑only, content‑addressed rules as all other data. Altering them would require rewriting the record stream that contains them, further amplifying the cost and visibility of any attempted change. Immutability is not a convention or a promise—it is a structural consequence.

---

## Runtime vs. Storage: Authority Boundaries

TaraKernel distinguishes sharply between two phases of data existence:

* **Runtime data** — mutation allowed, in‑memory, experimental, and provisional. Used for construction, manipulation, and validation.
* **Committed / storage data** — immutable, canonical, identity‑bearing, and continuously validated by the kernel.

Storage backends are treated as logistical substrates, not as authorities. Data is trusted only because the kernel can validate it every time it is accessed, not because the storage medium is assumed to be correct. 

---

## What the Kernel Explicitly Does *Not* Do

By design, the kernel excludes:

* Schema enforcement beyond minimal structural invariants
* Querying, indexing, filtering, or aggregation
* Concurrency or transaction models
* Interpretation, inference, or meaning extraction
* Cleaning, fixing, or rewriting data

These exclusions are intentional and foundational. They keep the kernel small, stable, and resistant to conceptual drift.

---

## Design Philosophy

TaraKernel treats recorded data like a scientific notebook or an audit log:

* Mistakes remain.
* Wrong values remain.
* Unintended actions remain.

These are not defects to be erased but facts to be preserved. Meaning improves over time. Tools improve. Interpretations change. **History must not.**

---

## Current State of Development

The conceptual model is stable and largely specified. Core kernel mechanisms—canonicalization, hashing, append‑only tapes, and validation—are implemented and exercised. Storage backends are intentionally minimal and “dumb,” while higher‑level semantics, ergonomics, and interpretation are deliberately deferred to future layers.

TaraKernel aims to be a permanent foundation: small, strict, and boring—so everything built on top of it can safely evolve.
