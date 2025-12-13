- # NOTE
- Here we have a mix of `DiskBackend` and general `LiteTape` concepts
- #TODO I must separat both into different notes

- # LiteTapeLib
- `#PREFERRED`
- A folder that contains multiple **Tapes**, each represented as its own subfolder.
- It acts as the **root of the Tape Store**, providing the physical namespace for Tape directories.
- LiteTapeLib holds a small meta file declaring its identity and which Tape folders exist.

***

## LiteTape

- `#PREFERRED`
- A Tape is an **ordered sequence of segments**, exposed through the Tape interface.
- The ordering of segments defines the Tape’s logical record stream.
- The Tape interface implements the **Tara Tapes Spec**: append-only, segment-indexed, and deterministic.
- The Tape introduces no domain semantics.
  It defines a structural projection used by the kernel.
- Physical storage layout (e.g. files, folders) is backend-dependent and not part of the Tape definition.

***

- # LiteTapeSegment
- `#PREFERRED`
- A **single segment unit** that represents an ordered collection of **LiteRecords** exposed through the Tape interface.
- The segment is logically composed of:
  - a Static Prefix,
  - followed by a Dynamic Tail.
- The Static Prefix is immutable after commitment,
  by means of a CommitRecord containing content-dependent hashes.
- The Static Prefix is just a `RecordSequence`
- The segment is identified by:
  - its **position** within the enclosing Tape,
  - and a **content-derived hash** assigned at commit time.
- Internal representation, physical layout, and storage format are backend-defined and unconstrained.
- A segment MUST be expandable by the kernel into a sequence of record byte payloads suitable for validation.
- Canonical record representation is determined by the kernel

***

- #DESIGN
- The primary goal of a `DiskBackend.Tape` is to:
    - Provide a **logistical persistence substrate** for bytes emitted by the kernel.
    - Preserve bytewise identity, ordering, and append-only semantics
      exactly as instructed by the kernel.
    - Expose stored bytes through the kernel-defined Tape interface:
        - LiteTapeLib → ordered Tapes → ordered Segments → ordered Records.

- The backend does **not** define, enforce, or assume any canonical representation.
- It does **not** interpret, validate, or transform TaraSON content.
- It stores and returns opaque byte payloads exactly as provided by the kernel.
- The Tape structure exposed by the backend is a **kernel-facing projection**, independent of physical layout or internal storage representation.
- All semantic meaning, validation rules, and identity guarantees reside exclusively in the kernel.
- The backend maintains no semantic state beyond ordered, append-only byte storage.

***

