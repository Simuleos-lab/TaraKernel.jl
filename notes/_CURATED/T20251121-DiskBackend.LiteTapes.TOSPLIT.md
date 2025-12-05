- # NOTE
- Here we have a mix of `DiskBackend` and general `LiteTape` concepts
- #TODO I must separat both into different notes

- # LiteTapeLib
- `#PREFERRED`
- A folder that contains multiple **Tapes**, each represented as its own subfolder.
- It acts as the **root of the Tape Store**, providing the physical namespace for Tape directories.
- LiteTapeLib holds a small meta file declaring its identity and which Tape folders exist.

***

- # LiteTape
- `#PREFERRED`
- A Tape is an **ordered sequence of segments**, stored as files inside its folder.
- Implements the **Tara Tapes Spec**: append-only, segment-indexed, deterministic, and content-addressable.
- No custom semantics: it is a canonical substrate defined by **The Tara Project**.
- Segment order defines the Tape’s logical record stream.

***

- # LiteTapeSegment
- `#PREFERRED`
- A **single segment file** (`.jsonl`) that contains a ordered collection of **TaraSON** objects (**LiteRecords**).
- Contains Static Prefix + Dynamic Tail.
- A StaticPrefix is immutable by means of a CommitRecord which contains content dependent hashes
    - Analogous to a block chain
- Identified by its **position** in the Tape and by its **content hash** (canonical hash).
- Many different implementations (compression, layout) are allowed as long as the segment expands to a valid TaraSON.
- The fixpoint of the Expansion is the Canonical Record Representation

***

- # DESIGN
- The primary goal of a `DiskBackend.Tape` is to:
    - Define the canonical **disk-level substrate** for Tara Records.
    - Provide an append-only log of TaraSON record.
    - Establish a clear hierarchy:
        - LiteTapeLib -> Tape (folder) -> ordered Segments (files) -> records (TaraSON).

- Tapes do **not** interpret TaraSON; they only store and order it.
- The Tape kernel has **no hidden state** beyond the Tape's content.
