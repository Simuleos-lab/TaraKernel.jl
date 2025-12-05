
---
## TapeSegments: Description

- The kernel treats each segment as containing a collection of canonical TaraSON payload.
- Segment records must be self-contained and valid as canonical TaraSON.
- No implicit parent/child relationships are permitted at the segment level.
- The kernel does not infer structure between segments; all relationships must be encoded as data.
- A Tape is valid if **each segment expands to a valid canonical TaraSON collection** with its corresponding content identifier.

---
## TapeSegments: More on Segments

- A tape is divided into independent segments.
- Any data in the tape must belong to a segment.
- Each segment has:
    - a **position** on its tape, defining order.
    - a **payload**
        - a collection of `LiteRecord`s (`TaraSON`)
        - for instance, for a `DiskBackend`
            - as a single `jsonl` file.
        - 1 segment -> N records
    - Note:
        - Any "metadata" must be store as regular records on regular segments
            - inluding anyone need it by the Kernel itself

---
