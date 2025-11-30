- # NOTE
- Here we have a mix of `DiskBackend` and general `LiteTape` concepts
- #TODO I must separat both into different notes

- # LiteTapeLib [.ARCH.md]
- `#PREFERRED` [.ARCH.md]
- A folder that contains multiple **Tapes**, each represented as its own subfolder. [.ARCH.md]
- It acts as the **root of the Tape Store**, providing the physical namespace for Tape directories. [.ARCH.md]
- LiteTapeLib holds a small meta file declaring its identity and which Tape folders exist. [.ARCH.md]

*** [.ARCH.md]

- # LiteTape [.ARCH.md]
- `#PREFERRED` [.ARCH.md]
- A Tape is an **ordered sequence of segments**, stored as files inside its folder. [.ARCH.md]
- Implements the **Tara Tapes Spec**: append-only, segment-indexed, deterministic, and content-addressable. [.ARCH.md]
- No custom semantics: it is a canonical substrate defined by **The Tara Project**. [.ARCH.md]
- Segment order defines the Tape’s logical record stream. [.ARCH.md]

*** [.ARCH.md]

- # LiteTapeSegment [.ARCH.md]
- `#PREFERRED` [.ARCH.md]
- A **single segment file** (`.jsonl`) that contains a ordered collection of **TaraSON** objects (**LiteRecords**). [.ARCH.md]
- Contains Static Prefix + Dynamic Tail. [.ARCH.md]
- A StaticPrefix is immutable by means of a CommitRecord which contains content dependent hashes [.ARCH.md]
    - Analogous to a block chain [.ASSAY.md]
- Identified by its **position** in the Tape and by its **content hash** (canonical hash). [.ARCH.md]
- Many different implementations (compression, layout) are allowed as long as the segment expands to a valid TaraSON. [.ARCH.md]
- The fixpoint of the Expansion is the Canonical Record Representation [.SPEC.md]

*** [.ARCH.md]

- # DESIGN [.ARCH.md]
- The primary goal of a `DiskBackend.Tape` is to: [.ARCH.md]
    - Define the canonical **disk-level substrate** for Tara Records. [.ARCH.md]
    - Provide an append-only log of TaraSON record. [.ARCH.md]
    - Establish a clear hierarchy: [.ARCH.md]
        - LiteTapeLib -> Tape (folder) -> ordered Segments (files) -> records (TaraSON). [.ARCH.md]

- Tapes do **not** interpret TaraSON; they only store and order it. [.SPEC.md]
- The Tape kernel has **no hidden state** beyond the Tape's content. [.SPEC.md]
