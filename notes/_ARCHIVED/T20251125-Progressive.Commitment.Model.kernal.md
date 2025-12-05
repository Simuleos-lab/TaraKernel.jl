# Dynamic vs Static Objects — Progressive Commitment Model (Updated)

## GENERAL GOAL
- Describe the conceptual model of `Dynamic` and `Static` states for **Records** and **Tape Segments**.
- Integrate the new model of **LiteTapeSegment = one append-only stream** containing:
    - committed prefixes (`StaticPrefix`)
    - an uncommitted tail (`DynamicTail`)
- Explain progressive commitment and the non-reversible nature of static views.
- Provide a canonical reference for Recorder authors and Kernel implementers.
- Ensure compatibility with the new naming and semantics.

---

## MOTIVATION
- TaraKernel enforces strict immutability once data has been committed.
- Mutation must only occur in **pre-commit dynamic states**.
- Long-running append workflows require a clean distinction between:
    - committed, hashable prefixes
    - an open, writable tail
- A progressive `Dynamic → Static` lifecycle ensures correctness and prevents drift.
- Mirrors Git-like principles: commit creates an immutable snapshot; history is append-only.

---

## CORE IDEA
- Every meaningful kernel object exists in two roles:
    - **Dynamic**: mutable, unfinished, pre-commit.
    - **Static**: immutable, canonical, committed.
- Mutation is allowed only in dynamic states.
- Once static, an object:
    - is final,
    - has or participates in canonical hashing,
    - becomes part of the committed tape view,
    - is never legally altered.

---

# DEFINITIONS — RECORDS

## DynamicLiteRecord
- A **free-standing mutable record**.
- No association with tapes, segments, prefixes, or tails.
- Used during scope capture and transformation.
- Only form allowed to mutate fields.
- Not part of any tape.
- Has no canonical hash.
- Not serializable as a canonical record.
- DynamicRecords cannot be stored directly; only StaticRecords enter tape structures.
- Dynamism must be simulated through **append-only workflows**, not overwriting.
- Using the Tape as a temporary scratchpad is intentionally discouraged.
- If a user wants mutable semantics, they must follow:
    ```
    old.static → new.dynamic → new.static → append → (optionally) deprecate old prefix
    ```
- Direct overwriting workflows are never supported.

## StaticLiteRecord
- A StaticLiteRecord is, by definition, a **Committed** LiteRecord:
    - it satisfies canonicality and content-integrity invariants,
    - its identity is fixed by its content-derived hash.
- An **immutable** record.
- Contains validated, flat, deterministic TaraSON content.
- May reference its `LiteTapeSegment` and the `StaticPrefix` it belongs to.
- Has (or can have) a canonical hash.
- Not mutable once created.
- Only StaticRecords may appear in `StaticPrefix` and `DynamicTail`.
- Cannot revert to a dynamic state.

---

# DEFINITIONS — TAPE SEGMENTS (UPDATED MODEL)

## LiteTapeSegment
- The **entire append-only record stream** for a segment.
- Contains:
    - zero or more committed prefixes (`StaticPrefix`)
    - one uncommitted tail (`DynamicTail`)
- Backends may represent it as a file, buffer, blockstore, etc.
- The logical ordering is canonical; physical layout is a backend detail.
- A segment grows only by append.

## StaticPrefix
- A **committed, immutable, hashable prefix** of a LiteTapeSegment.
- Defined by a `CommitRecord` at logical index `k`.
- Represents all records from index `1` to `k`, inclusive.
- Immutable once committed.
- Canonically identifiable via prefix-hash.
- Multiple prefixes may coexist (nested commit model).
- Readers default to the **latest** StaticPrefix.

## DynamicTail
- The **uncommitted suffix** of a LiteTapeSegment.
- Begins immediately after the last `CommitRecord`.
- Contains only StaticRecords, never a commit.
- Mutable via append operations.
- Not hashable.
- Not part of any committed prefix.
- Becomes empty when a new `CommitRecord` seals a new prefix.

---

# PROGRESSIVE COMMITMENT MODEL (UPDATED)

## Description
A structured, one-direction pipeline:

1. **DynamicLiteRecord** is created.
2. Converted to **StaticLiteRecord**.
3. Appended to the **DynamicTail** of a LiteTapeSegment.
4. A **CommitRecord** is appended.
5. This seals the prefix and creates a **new StaticPrefix**.
6. The segment now has a new committed view.
7. Tape readers see only committed prefixes unless explicitly asked to read the tail.

## Meaning
- Each commit increases immutability.
- Each prefix becomes its own stable, reproducible snapshot.
- The system provides:
    - lite discipline
    - canonicalization
    - hashing
    - durable storage

## No Uncommit Principle
- `StaticPrefix` is immutable.
- Cannot remove, modify, restore, or shrink committed prefixes.
- No Static → Dynamic transition.
- Corrections must be expressed as **new dynamic → new static → new prefix**.
- Mirrors Git: history is append-only.

---

# HIDDEN FILE ANALOGY (UPDATED)

## DynamicTail as “hidden state”
- Exists during writing, often on-disk, but **not part of committed tape data**.
- Readers, scanners, and indexers **ignore** it by default.
- Only writer APIs interact with it.
- When sealed by a CommitRecord, the tail becomes part of a new StaticPrefix.
- Mirrors filesystem atomic-write patterns:
    - dynamic tail = “working region”
    - commit = “rename into place”

---

# WORKFLOWS (UPDATED)

## 1. Record Creation Workflow
- Scope is captured.
- User transformations create a DynamicLiteRecord.
- Validated and canonicalized → StaticLiteRecord.
- StaticLiteRecord is appended to the segment’s DynamicTail.

## 2. Segment Assembly Workflow
- DynamicTail accumulates StaticRecords.
- Recorder may:
    - deduplicate,
    - add metadata,
    - merge,
    - rotate on size or time.
- No data becomes committed until a CommitRecord is written.

## 3. Commit Workflow
- Writer appends a `CommitRecord` to the DynamicTail.
- This seals the entire prefix `[1 → k]`.
- A new StaticPrefix is created and assigned a prefix-hash.
- The DynamicTail resets (empty).

## 4. Tape Growth Workflow
- A segment grows as:
    ```
    StaticPrefix_1  →  (DynamicTail)  →  StaticPrefix_2  →  ...
    ```
- No rewriting of prior prefixes.
- No reorder, no deletion.
- Repacking produces new equivalent segments, not mutations of existing ones.

---

# STRICT INVARIANTS (UPDATED)

## Segment-Level
- A LiteTapeSegment is a **single ordered sequence**.
- StaticPrefixes are immutable snapshots.
- DynamicTail is mutable only by append.
- No backward mutation.

## Record-Level
- Static records cannot change.
- Dynamic records must become static before entering the segment.
- No Static → Dynamic conversion.

## Prefix-Level
- CommitRecord defines prefix boundaries.
- Prefix hash covers all records from index 1 to the commit index.
- Multiple prefixes may coexist.

## API-Level
- Readers default to the latest StaticPrefix.
- Readers may request earlier prefixes.
- Readers may explicitly request the DynamicTail.
- Writers operate only on the DynamicTail.

---

# DESIGN RATIONALES (UPDATED)

## Separation of phases
- All mutation flows through DynamicTail.
- All stability flows through StaticPrefix.

## Predictability
- Writers = dynamic state.
- Readers = static state.
- No mixed or ambiguous states.

## Simplified debugging
- DynamicTail is safe to inspect.
- StaticPrefix offers stable ground truth.

## Reduced drift across backends
- Kernel defines the semantics:
    - ordered stream,
    - prefix boundaries,
    - append-only tail,
    - commit mechanism.
- Backends implement storage but cannot change meaning.

## Determinism
- Only StaticPrefixes are hashed.
- DynamicTail is intentionally non-hashable.
- Ensures stable addressing and reproducibility.

---

# CONNECTIONS
- Progressive commitment resembles Git-style snapshots.
- StaticPrefix resembles content-addressed prefixes (Perkeep, IPFS).
- DynamicTail resembles “open” write buffers in log-structured systems.
- Records and segments share the same Dynamic → Static lifecycle invariants.

---

# SUMMARY (COMPACT)
- **DynamicLiteRecord** = mutable, not serializable.
- **StaticLiteRecord** = immutable, canonical.
- **LiteTapeSegment** = entire ordered segment stream.
- **StaticPrefix** = committed, immutable prefix defined by a CommitRecord.
- **DynamicTail** = uncommitted suffix where writers append.
- Commitment is one-way; rollback is forbidden.
- Readers see committed prefixes; writers manipulate the tail.
- This unified model provides clarity, safety, efficiency, and long-term stability.

