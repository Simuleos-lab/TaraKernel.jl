# Dynamic vs Static Objects — Progressive Commitment Model  

## GENERAL GOAL
- Describe the full conceptual model for `Dynamic` and `Static` states for **Records** and **Tape Segments**.
- Explain progressive commitment, immutability, and the “no uncommit” principle.
- Capture all workflows, invariants, and design rationales.
- Provide a canonical reference for Recorder authors and Kernel implementers.

---

## MOTIVATION
- TaraKernel relies on strict, immutable data structures once committed.
- Mutation must only allowed in a **pre-commit dynamic state**, never on **static** states.
- Recorders must handle partially constructed data, batching, and write buffers.
- A clear `Dynamic → Static` lifecycle simplifies correctness and prevents drift.
- The distinction mirrors Git’s staging/commit philosophy: append-only, never rewrite.

---

## CORE IDEA
- Every meaningful object in the Tara Kernel has two roles:
    - **Dynamic**: mutable, unfinished, pre-commit state.
    - **Static**: immutable, canonical, committed state.
- Mutation is allowed only in the dynamic state.
- Once static, an object:
    - is final,
    - participates in canonical hashing,
    - is part of the Tape,
    - is never legaly altered.

---

## DEFINITIONS — RECORDS

### DynamicLiteRecord
- A **free-standing mutable record**.
- Has no tape or segment association.
- Used during scope capture and transformation phases.
- Only form allowed to mutate field values.
- Not part of any tape.
- Does not possess a canonical hash.
- Not serializable as a final Record until committed.
    - Very important
- dynamic segments can be serianlized, but dynamic records do not.
- the user must simulate dynamism by appending
- this actually disencourage using the tape as a mear temporal cache
- If you want to do so, you must do the full `create.new.dynamic.from.static` -> `format.dynamic` -> `commit.to.new.static` -> `deprecate.old.static`
- The point is, we will never support a direct overwriting data workflow


### StaticLiteRecord
- An **immutable record**.
- Contains only validated, flat, deterministic TaraSON content.
- May reference its parent `StaticLiteTapeSegment`.
- Has (or can have) a canonical content-hash derived from the canonical view.
- Never mutated after creation.
- Is the only form allowed inside Tape Segments.
- Cannot revert to a dynamic state.

---

## DEFINITIONS — TAPE SEGMENTS

### DynamicLiteTapeSegment
- A **pending segment** used by writers.
- Represents a sequence of `StaticLiteRecord`s waiting to be written.
- Mutable: records can be appended until the segment is sealed.
- Has no canonical hash.
- Not registered in Tape metadata.
- Not part of the Tape stream.
- Lives similarly to a “hidden file”: tools may default to ignore it.
- Produced and consumed only by Tape writer APIs.
- Represents the natural batching unit for Recorder workflows.

### StaticLiteTapeSegment
- A **closed, immutable, canonical segment**.
- Has a content-addressable identifier.
- Registered in the Tape’s segment list in order.
- Represents a physical `.jsonl` (or compressed) file on disk.
- Used for reading, scanning, canonicalization, and recovery.
- Cannot revert to a dynamic segment.
- Cannot be reopened or extended; new appends must use a fresh DynamicLiteTapeSegment.

---

## PROGRESSIVE COMMITMENT MODEL

### Description
- A structured pipeline:
    1. **Dynamic Record** is created.
    2. Converted into a **Static Record**.
    3. Appended to a **Dynamic Segment**.
    4. Dynamic Segment is sealed into a **Static Segment**.
    5. Static Segment is attached to the Tape.
    6. Static Segment is written to disk.

### Meaning
- Each stage progressively reduces mutability.
- Each stage increases invariants (lite discipline → canonical form → hashing → storage).
- Each stage increases guarantees for reproducibility and traceability.

### No Uncommit Principle
- Unsealing static objects is **forbidden**.
- Static -> Dynamic transitions do not exist.
- Correction must always create a new dynamic object.
- Removal must be modeled as a tombstone or by creating a replacement segment.
- Mirrors Git philosophy: “history is append-only”.

---

## HIDDEN FILE ANALOGY

### DynamicLiteTapeSegment as a hidden file
- Not visible in the Tape.
- Not considered part of the canonical record stream.
- Can exist temporarily during a write session.
- Tools (scanners, readers, indexers) **must ignore** them by default.
- Only writer functions should interact with them.

### Rationale
- Prevents accidental exposure of incomplete data.
- Allows safe batching and asynchronous write strategies.
- Mirrors filesystem behavior: hidden files exist during writes, then are atomically renamed into place.

---

## WORKFLOWS

### 1. Record Creation Workflow
- Recorder captures a Scope.
- Transform hooks convert Scope → DynamicLiteRecord.
- DynamicLiteRecord is validated and canonicalized.
- Produces a StaticLiteRecord.
- StaticLiteRecord is pushed into a DynamicLiteTapeSegment.

### 2. Segment Assembly Workflow
- Dynamic segment collects static records.
- Recorder may:
    - apply deduplication,
    - compute local metadata,
    - perform small merges,
    - estimate segment size thresholds.
- Nothing is committed until the dynamic segment is sealed.

### 3. Sealing Workflow
- `seal_segment!(tape, dynseg)` is called.
- Operation computes canonical hash and content.
- Writes the final `.jsonl` file.
- Registers the new StaticLiteTapeSegment in the Tape’s meta.
- DynamicLiteTapeSegment becomes invalid after sealing.

### 4. Tape Growth Workflow
- Tape only grows by append.
- No modifications to earlier segments.
- No reordering, replacing, or rewriting.
- Repacking creates **equivalent new tapes**, not mutations of existing segments.

---

## STRICT INVARIANTS

### Segment-Level
- Static segments are immutable.
- Dynamic segments are mutable only until sealing.
- No function can produce DynamicLiteTapeSegment from StaticLiteTapeSegment.

### Record-Level
- Static records are immutable.
- Dynamic records produce static ones, never the reverse.

### Tape-Level
- Tapes contain only static segments.
- Tapes never contain dynamic segments.
- Meta files describe only static segments.

### API-Level
- Read APIs never expose dynamic segments.
- Write APIs always manipulate dynamic segments.
- Writers are the sole mechanism for sealing.

---

## DESIGN RATIONALES

### Separation of phases
- Minimizes complexity by isolating mutation from immutability.
- Allows concurrent or asynchronous writing.
- Enables multi-stage transformation workflows.

### Predictability
- Writers always work with Dynamic objects.
- Readers always work with Static objects.
- No ambiguous intermediate states.

### Simplified debugging
- Dynamic segments and records can be inspected without risking corruption.
- Static segments provide a clear, unchanging ground truth.

### Reduced drift across backends
- Defining `DynamicLiteTapeSegment` centrally in the kernel avoids each Recorder inventing its own version.
- Simplifies porting to new storage backends.

### Determinism
- Dynamic states are intentionally not hashed.
- Static states participate in canonical hashing.
- Provides stable addressing, deduplication, and recovery semantics.

---

## CONNECTIONS

- Progressive commitment is analogous to Git’s staged / commit workflow.
- Dynamic segments mirror how filesystems use temporary hidden files during writes.
- Static segments mirror content-addressed immutable blocks (Perkeep, IPFS).
- Record and Segment types follow the same two-phase lifecycle.
- Tapes remain the canonical substrate for all meaning.

---

## SUMMARY (COMPACT)
- **Dynamic objects** = mutable, pre-commit, not part of canonical data.
- **Static objects** = immutable, canonical, hashed, part of tape.
- Commitment is **one-way**.
- Uncommit / reopen is **forbidden**.
- Dynamic segments must be **officially supported**, but never treated as Tape content.
- All readers ignore dynamic segments; only writers manipulate them.
- This model ensures correctness, simplicity, and long-term stability of TaraKernel.

