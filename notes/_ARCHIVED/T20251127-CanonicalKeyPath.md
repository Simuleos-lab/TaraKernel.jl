# CanonicalKeyPath (JSON-Pointer Style)

## Summary
A **CanonicalKeyPath** is the kernel-level representation of structure in TaraSON:  
a sequence of path segments encoded into a single string using a **JSON-Pointer–style** format.  
This path uniquely identifies each primitive fact in a canonical record. TaraSON itself remains a flat map of  
`CanonicalKeyPath => primitive`.

## Rationale
### 1. Structure represented only at the path level  
The canonical layer has no arrays or nested dicts. All structure is encoded as a list of path segments:
- runtime objects: arbitrary nested structures,
- canonical form: facts indexed by their `CanonicalKeyPath`,
- reconstruction: consumers rebuild structure by parsing paths.

This separation keeps the kernel minimal and cross-language stable.

### 2. JSON-Pointer format fits the requirements  
JSON Pointer (RFC 6901) provides a compact, well-defined encoding for path segments:
- separator: `/`,
- escaping inside segments: `~0` → `~`, `~1` → `/`.

This yields:
- free segment content (only two characters need escaping),
- unambiguous, reversible decoding,
- a tiny, easy-to-implement specification,
- compatibility with existing tooling and intuition.

Path segments like `["ctx", "run", "step", "a/b", "x~y"]` become:
```
/ctx/run/step/a~1b/x~0y
```

### 3. Perfect for line-oriented TaraSON  
Because structure lives entirely in the encoded path:
- canonical records remain line-by-line `key: primitive`,
- custom parsers are trivial to implement,
- streaming, diffing, grepping, sorting all work directly on lines,
- compression captures repeated prefixes effectively.

### 4. Extremely stable canonical boundary  
CanonicalKeyPath becomes the only structural contract for TaraSON:
- deterministic ordering,
- deterministic serialization,
- deterministic hashing,
- zero dependence on host-language data models.

All runtime representations map onto this path grammar.

## Consequences
- The canonical representation remains purely flat.
- A fixed, language-independent path grammar defines all structural meaning.
- Adapter layers in host languages handle mapping between runtime structures and `CanonicalKeyPath`s.
- Consumers reconstruct structure by splitting and unescaping path segments.

## Decision Status
JSON-Pointer–style paths provide the simplest and most robust definition of CanonicalKeyPath and are recommended as the basis for the TaraSON canonical layer.
