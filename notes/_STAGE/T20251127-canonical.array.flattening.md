### Idea: Canonical Array Flattening

- `#EXPERIMENTAL`
- `#NON/APPROVED`
- `#MAYBE-LATER`

**Proposal**
Instead of treating arrays as leaf values in the canonical `LiteRecord`, we could *also* flatten them into per-element entries, so that:

```json
{"A": [32, 1, -1]}
```

canonically becomes something like:

```json
{"A.1": 32, "A.2": 1, "A.3": -1}
```

- assuming a convention where
    - numeric path components are array indices
        - cannot be confused with dict keys
    - only at the end of the path
    - if are no mixed with non scalars
    - are consecutive

**Pros**

- Each primitive value becomes a **standalone, fully contextualized fact**: every line in the canonical view is 
    - `"full/path": primitive`.
- This makes it very natural to interpret records as event-like rows, and to index/search/analyze at the level of individual primitives without needing extra transforms.
- If dict keys are guaranteed non-numeric, then path parsing is clean: numeric segments = array indices, non-numeric = map keys, no ambiguity.

**Cons**

- Arrays stop being a single logical field and become many scalar keys; this **inflates key count and string allocations**, especially for moderately sized lists.
- Canonical records become noisier and harder to read/debug by eye; you mentally reconstruct arrays from `A.1`, `A.2`, …
- The core problem canonicalization must solve is *unordered, nested maps*; arrays already have order and a simple canonical JSON representation. Flattening them is conceptually optional.
- We can always get the “fully exploded primitives with full path” view as a **derived transform** on top of a simpler canonical form (dicts flattened, arrays as leaves), paying the extra cost only when actually needed.

**Current stance**

Keep the idea on the table but **do not flatten arrays in the canonical representation for now**. Canonicalization focuses on flattening nested dicts; array-explosion is treated as a possible *secondary view* for indexing or analysis, to be revisited once the core TaraSON semantics are stable.
