# **GENERAL GOAL**

* Summarize all explicitly stated ideas from the full chat about LiteTapes, Tape metadata, TaraSON, system segments, Tape identity, structure, repacking, and API semantics.
* Organize the information cleanly using the kernel-note format.
* Capture relevant concepts, constraints, trade-offs, and design choices exactly as they appeared.
* Preserve disagreements, alternatives, and unresolved points.

---

# **LITETAPES DIRECTORY STRUCTURE**

* LiteTapeLib is a root directory that contains all Tapes.
* Each Tape is a subfolder inside the LiteTapeLib.
* Each Tape folder contains multiple segment files.
* Segments are stored as `jsonl` files.
* One file per segment is the default proposed layout.
* Segment filenames typically follow a pattern like `seg-000001.jsonl`.
* This structure allows append-only, immutable segments.
* Segment granularity supports compaction, dedup, and rewriting.
* Alternative considered: **one file per tape**, but rejected due to reduced flexibility.
* Excessive segment count may require sharding (not yet mandatory).
* Directory-level identity is defined by a specific meta file.

---

# **TAPE.IDENTITY AND META FILES**

* Each Tape folder requires a meta file to define that “this folder is a Tape.”
* Deleting the meta file invalidates the Tape.
* A new Tape must be created if the meta file is lost.
* Recovery is possible by scanning segments but results in a new Tape identity.
* Tape identity (UUID) exists independently of segment contents.
* Meta files describe Tape structure rather than contextual user data.
* Meta files contain both structural and system information.
* Meta is needed for fast loading and avoiding full rescans.
* Meta cannot be fully derived from segments in general.
* Meta must be considered **authoritative** for the implementation.

---

# **LITETAPELIB META**

* The LiteTapeLib root contains its own meta file (`litelib.meta.jsonl`).
* This file defines:

  * The LiteTapeLib identity.
  * A list of Tape folders.
  * Their states (active/archived).
* Follows the same TaraSON system-segment model as tape meta.

---

# **TAPE META CONTENT**

* Tape meta includes:

  * Tape ID.
  * Creation time.
  * Format version.
  * Segment list.
  * Segment descriptors (index, filename, compression, state).
  * Internal counters (e.g., next segment index).
  * User metadata attached to the Tape.
* Structural fields are system-controlled.
* User metadata fields are user-settable.
* Tape meta is not arbitrarily writable; controlled update operations are required.

---

# **META AS TARASON SYSTEM SEGMENTS**

* TaraSON can express “facts about issues,” including Tape-level definitions.
* Meta files can be represented as **reserved TaraSON jsonl segments**.
* Meta is implemented as a system-level segment (`tape.meta.jsonl`).
* Meta segment is treated as **segment 0** of a Tape.
* System namespace types are reserved:

  * `LiteTape.Meta`
  * `LiteTape.Segment`
  * `LiteTape.UserMeta`
  * `LiteLib.Meta`
  * `LiteLib.Tape`
* Tools interpret these records specially.
* System records coexist with user data segments while being structurally distinct.
* Meta is not part of the contextual data domain but uses the same language.

---

# **SEGMENT MODEL**

* Segments are immutable once closed.
* A read-only `LiteTapeSegment` represents a static segment.
* Dynamic segments exist only during writing.
* Dynamic segments are not part of the Tape’s formal structure.
* A dynamic segment becomes static after being closed.
* Final static segment creation involves flushing and renaming.
* Dynamic segments are implementation details, not first-class persistent objects.
* Multiple segment types were considered but rejected to keep the model simple.

---

# **SEGMENT OPERATIONS**

* Append segment: adds a new static segment to the Tape.
* Repack segments: produce a new ordered list of segments.
* Compaction: reduce segments through dedup or compression.
* Rewriting segment structure updates the meta file accordingly.
* Repacks yield equivalent Tapes that differ at the storage level but preserve records.
* Structural operations manipulate Tape meta but preserve Tape-level semantics.

---

# **EQUIVALENT TAPES**

* Equivalent Tapes contain the same logical Tara record stream.
* Physical structure (e.g., segment boundaries, compression) may differ.
* Rewriting or repacking generates new segment sets but preserves equivalence.
* Tape identity can remain or change depending on operation semantics.
* Lossless transformations are allowed and common.

---

# **TAPE RECOVERY**

* Missing or corrupted meta makes the Tape invalid.
* Recovery scans segment files and reconstructs a meta file.
* Recovered meta produces a **new Tape**.
* Recovery may lose some structural information.
* Recovery is permissible but must be explicitly defined.

---

# **API SEMANTICS**

* Tape exposes:

  * `meta(tape)` → read the Tape meta records.
  * `segments(tape)` → iterator over static segments in canonical order.
* User metadata can be set or updated.
* Structural fields in meta cannot be arbitrarily set.
* Structural mutation must go through explicit operations:

  * append segment,
  * repack segments,
  * clone tape,
  * recover tape.
* API avoids raw "set segments iterator" for safety.
* Segments are discovered from meta, not from directory scans.
* New segment creation is always mediated through a writer.

---

# **DESIGN PRINCIPLES**

* Tapes are append-only sequences of records.
* Segments provide atomicity and immutability.
* Meta expresses structure using the same TaraSON language.
* Implementation concerns must not pollute contextual record semantics.
* Meta is stored externally but in the same representational substrate.
* Clear separation of:

  * system-level records,
  * user-level contextual records.
* Reserved namespaces prevent collisions.
* Manifest-based design mirrors existing storage systems (RocksDB, Iceberg, Git).
* Repacking and dedup are first-class operations.
* Simplicity preferred over abstraction.
* Implementation flexibility must not break semantic clarity.

---

# **CONNECTIONS**

* Dynamic-to-static segment transition is related to mutation control.
* Meta files relate to Tape identity and recovery.
* System segments relate to the reserved system namespace in TaraSON.
* Equivalent Tapes relate to repacking and immutable segments.
* API semantics depend on structural constraints expressed in meta.
* Dirtree layout depends on Tape-level meta’s ability to define structure.

