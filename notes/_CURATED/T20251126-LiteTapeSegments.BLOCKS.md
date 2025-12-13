***
## TapeSegments: Description

- The kernel treats each segment as a finite, ordered collection of records,
  whose storage-grade form is a canonical TaraSON representation.
- A segment’s committed state MUST be hash-verifiable by at least one
  closing `CommitRecord`, which binds the segment’s record content
  to a deterministic content identity.
- Segments introduce no implicit structure:
    - no parent/child relationships,
    - no inferred semantics,
    - and no interpretation beyond explicit record content and order.
- Any relationships—within a segment or across segments—MUST be encoded
  explicitly as data and remain uninterpreted by the kernel.
- A Tape is considered valid only if, for each segment in order:
    - all records admit a valid canonical TaraSON expansion,
    - and all kernel-defined commit, hashing, and content-identity
      invariants are satisfied.

***
## TapeSegments: More on Segments

- A tape is divided into an ordered sequence of segments.
- Any content present on a tape MUST belong to exactly one segment.
- Each segment has:
    - a **position** on its tape, which defines global record order.
    - a **payload**
        - a finite collection of canonical `TaraSON` records,
        - for example, in the `DiskBackend`,
            - materialized as a single `jsonl` file.
        - one segment contains N records.
- Notes:
    - The kernel recognizes no special metadata layer.
        - #UNDER/DISSCUSION
    - Any information, including kernel-required data,
      MUST be encoded as regular records within regular segments.
