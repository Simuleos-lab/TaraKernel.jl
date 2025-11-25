# [KERNEL NOTE] LiteTapeSegment — StaticPrefix / DynamicTail Model  
#DEFINITION
- Defines the logical structure and invariants of a `LiteTapeSegment`.
- Distinguishes the committed part (`StaticPrefix`) from the uncommitted part (`DynamicTail`).
- Independent of backend representation (files, buffers, blocks, etc.).
- Establishes reader and writer responsibilities.
- Guarantees immutability, ordering, and append-only semantics.

---

# CONCEPTUAL MODEL
- A `LiteTapeSegment` is an **ordered sequence** of `StaticRecord`s.
- The sequence may contain **zero or more committed prefixes**.
- Each committed prefix ends with a `CommitRecord`.
- All records **after** the last `CommitRecord` belong to the `DynamicTail`.
- The backend may store the segment however it chooses.
    - The logical ordering and commit semantics must be preserved.

---

# CORE COMPONENTS

## LiteTapeSegment
- Logical container of all records belonging to the segment.
- Defines the **record order**.
- Defines the boundaries between committed and uncommitted regions.
- Readers treat the segment as a sequence of:
    - `StaticPrefix(k)`  (committed)
    - `DynamicTail`      (uncommitted)

## StaticPrefix
- A **committed prefix** of the segment.
- Consists of all records from index `1` to index `k`.
- Index `k` is always a `CommitRecord`.
- Immutable and hashable.
- Identified by the prefix hash defined by the kernel.
- Represents a stable snapshot of the segment content up to that point.
- All prior prefixes remain valid even after new commits.

## DynamicTail
- The **uncommitted suffix** following the last `CommitRecord`.
- Contains only non-commit `StaticRecord`s.
- Mutable via append operations.
- Not part of any committed state.
- Not hashable.
- Not visible by default to readers.
- Becomes empty once a new `CommitRecord` is appended.

---

# ORDERING INVARIANT
- The segment is an ordered list:
    ```
    Segment = [StaticRecord₁, StaticRecord₂, …, StaticRecordₙ]
    ```
- The backend must preserve ordering in all representations.
- Appends always increase the logical index.
- No record may be removed, replaced, or reordered.

---

# COMMITTING INVARIANT
- A `CommitRecord` at index `k` commits:
    - all records from index `1`,
    - up to and including index `k`.
- The committed prefix is:
    ```
    StaticPrefix(k) = [StaticRecord₁ … StaticRecord₍k₋₁₎, CommitRecord_k]
    ```
- The prefix cannot change after commit.
- The commit record defines the **prefix hash** and associated metadata.
- Multiple commits can exist; each one defines a valid historical view.

---

# DYNAMIC TAIL INVARIANT
- The `DynamicTail` begins at index `k+1`, where `k` is the last commit index.
- Contains only `StaticRecord`s.
- Ends when a new `CommitRecord` is appended.
- Writers may append arbitrarily many records to the tail.
- Readers ignore the tail unless explicitly requested to read dynamic data.

---

# IMMUTABILITY INVARIANT
- `StaticPrefix` is permanently immutable.
- No committed record can be changed.
- No committed region can be shrunk or extended.
- Only the `DynamicTail` is mutable, and only by append.
- “Uncommit,” “rollback,” or “reopen” operations are not supported.

---

# APPEND-ONLY INVARIANT
- All growth happens via appending to the tail.
- A new commit:
    - seals the current dynamic tail,
    - produces a new `StaticPrefix`,
    - moves the boundary between committed and uncommitted regions.
- No backwards mutation at any level.

---

# BACKEND FREEDOM
- Backends (e.g., DiskHandler) control:
    - file structure,
    - byte offsets,
    - buffering,
    - compression,
    - chunking,
    - flushing strategy.
- These are implementation details.
- Backends must expose:
    - the logical ordered list of records,
    - commit boundaries,
    - the dynamic tail,
    - the ability to append,
    - the ability to append a `CommitRecord`.

---

# READER BEHAVIOR
- Default reader view:
    - Only the **last** `StaticPrefix`.
- Readers may explicitly request:
    - earlier prefixes (historical commits),
    - the dynamic tail (uncommitted data).
- Readers must not depend on uncommitted regions unless explicitly opted in.

---

# WRITER BEHAVIOR
- Writers append records to the tail.
- Writers append a `CommitRecord` to seal a new prefix.
- Writers must not mutate earlier records.
- Writers may keep the tail open across long-running sessions.
- Writers must ensure ordering is preserved.

---

# MULTIPLE COMMITS MODEL
- A segment can contain multiple `StaticPrefix`es.
- Each prefix represents a historical snapshot.
- A new commit extends the segment without invalidating prior commits.
- This creates a “nested commit” structure:
    ```
    StaticPrefix(5)
    StaticPrefix(12)
    StaticPrefix(20)
    …
    ```

---

# SUMMARY
- A `LiteTapeSegment` is an append-only ordered sequence of static records.
- `StaticPrefix` defines committed, immutable, hashable prefixes.
- `DynamicTail` defines the open, mutable, uncommitted suffix.
- `CommitRecord` seals the tail and forms a new prefix.
- Backends are free in representation but must honor all logical invariants.
- Readers see committed data; writers operate on the tail.
- No overwrite, no rollback, no mutation of earlier committed regions.

