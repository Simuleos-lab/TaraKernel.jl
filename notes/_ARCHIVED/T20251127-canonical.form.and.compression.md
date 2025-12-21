# Canonical Form and Compression — Key Redundancy as a Feature  

`#KERNEL/NOTE`

- Canonicalization produces **flat, fully-qualified keys**; repeated path prefixes across records are intentional.
- This redundancy makes structural context explicit and ensures deterministic ordering and equality.
- In JSONL form, many records share the **same key substrings** and often in the **same order**.
- LZ-family compressors (gzip, zstd, xz) exploit repeated substrings using sliding-window dictionaries.
- After the first few records, compressors learn the keyspace; subsequent lines compress to **small deltas**.
- Large, repeated path prefixes (e.g., `"run/meta/config/"`) are encoded once and referenced many times.
- Canonical JSONL therefore compresses **exceptionally well**, often similar to or smaller than nested JSON.
- The flat/canonical shape prioritizes clarity and immutability; compression absorbs most size overhead.
- This is also Git friendly by the way
    - append only + delta logging mix very well
- Result: **simple canonical semantics + high compressibility** without custom formats or special encodings.
