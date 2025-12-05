## Canonical Record: Definition
- #LAW

- A **Canonical Record** is the unique, deterministic representation of a record used as the authoritative form for identity, equality, and hashing.
- A representation qualifies as *canonical* if and only if:
    - It encodes the record as a **finite set of key–value bindings**.
    - Each key is a **string** that fully identifies a field (including logical hierarchy, if any).
    - Each value is a **scalar TaraSON literal** (string, number, boolean, or null).
    - The record admits exactly **one valid byte-level encoding** under the canonicalization rules.
    - The canonical form is **independent of runtime structure**, storage layout, or language-level representation.
    - The canonical form is **stable across time and environments**.
    - The canonical form is the **sole source of record identity** (two records are identical iff their canonical byte encodings are identical).
- A Canonical Record is not:
    - A runtime object.
    - A structural or typed entity.
    - A nested document.
    - An implementation detail.
- It is a **representational contract**, not a data structure.
- A system is compliant with canonicality only to the extent that *all derived notions* (hashes, equality checks, signatures, references) operate on the **canonical representation and nothing else**.

***
## Canonical Record: Representation Format

#DEV

Below is a **full rewrite of `Canonical.Record.Rep.SPEC` into protocol-compliant blocks**, expressed as autonomous sections with tags, minimal scope per block, and no file-level authority assumptions.
Each block is written to stand alone.

---

## Canonical Record: Definition

- #LAW
- A *Canonical Record* is the authoritative, normalized representation of record content used for equivalence, hashing, and exchange.
- It is independent of runtime implementation, language, or memory layout.
- A canonical record exists only as a representation rule, not as a runtime object.

---

## Canonical Record: Flatness Requirement

- #LAW
- Canonical records MUST be flat.
- No nested objects, lists, tuples, or structured values are allowed in canonical form.
- All entries exist at one level in a single mapping.

---

## Canonical Record: Permitted Key Types

- #LAW
- All keys in canonical records MUST be strings.
- Keys are the only carrier of structure.
- The keys are valid `JSON-Pointer`s

---

## Canonical Record: Permitted Value Types

- #LAW
- Canonical values MUST be scalar.
- Permitted values:
    - string
    - integer
    - float
    - boolean
    - null
- No objects, lists, maps, or composites are allowed explicitly.

---

## Canonical Record: Prohibition of Structured Values

- #LAW
- If a value has structure, it is not canonical.
- Structured data MUST be flattened before canonicalization.
- This includes:
    - nested objects
    - arrays / lists
    - dictionaries / maps
    - inline composites

---

## Canonical Record: Encoding Structure in Key Names

- #MODEL
- Structure is expressed through naming, not data shape.
- Hierarchical meaning is encoded in key names as `JSON-Pointer`s
- Example pattern:
    - `/parent/child/attribute`
- This expresses structure conceptually, not structurally.
- The key must be a valid `JSON-Pointer`

---

## Canonical Record: Hierarchy Is Conceptual, Not Structural

- #INSIGHT
- The canonical form does not model hierarchy.
- The representation only simulates hierarchy by convention in keys.
- No inference is made from syntax alone: the system does not parse hierarchy — it preserves identity only.

---

## Canonical Record: Determinism Requirement

- #LAW
- Canonical representation MUST be deterministic.
- The same logical record MUST always produce the same canonical byte representation.
- No runtime-dependent ordering, formatting, or allocation is permitted.

---

## Canonical Record: Lexicographic Key Ordering

- #LAW
- Keys MUST be sorted lexicographically as byte strings before serialization.
- No insertion order, runtime order, or semantic grouping is valid.
- only lexicographically order

---

## Canonical Record: Hash Basis

- #LAW
- Commit hashes are computed FROM the canonical representation.
- Two records are identical if and only if:
- > their canonical representations serialize to the same byte sequence.
- Commit hashing does not inspect runtime representation

---

## Canonical Record: Equivalence

- #LAW
- Two records are canonically equivalent if:
- Their flattened key sets match exactly.
- Their scalar values match exactly.
- Their serialization bytes are identical.
- No tolerance, coercion, or semantic interpretation exists.

---

## Canonical Record:Canonicalization Responsibility

- #MODEL
- It is the producer’s responsibility to convert runtime data into canonical form.
- Consumers MUST assume canonical format is already normalized.
- The canonical layer performs no inference or repair.

---

## Canonical Record: Canonical View versus Runtime Structures

- #MODEL
- The Canonical record is an specification.
- Runtime records are not forced to be canonical.
- Runtime objects (LiteRecords, structured data, objects) may have:
    - nesting
    - references
    - structure
    - metadata

---

## Canonical Record: Canonical Scope

- #LAW
- Canonical format applies only to:
    - hashing
    - content identity
    - equivalence comparison
    - transport / interchange representation
- It does not govern internal runtime organization.

---

## Serialization Distinction

#MODEL

Canonical representation is conceptual.

Serialization is the *mechanical encoding* of that representation into bytes.

Canonical form precedes serialization.

Serialization does not define canonical meaning.

---

## Non-Goals of Canonical Records

#INSIGHT

Canonical records do NOT aim to:

* preserve runtime shape
* model nested data
* enforce schema
* capture semantics
* perform validation

Only identity matters.

---

## Deprecated: Nested Canonical Structures

#DEPRECATED

Earlier designs allowed canonical nesting.

This is no longer permitted.

All structure MUST be flattened.

---

## Deprecated: Lists as Canonical Values

#DEPRECATED

Earlier designs allowed lists or vectors.

Lists are not canonical.

All list semantics MUST be encoded explicitly in keys.

---

## Deprecated: Structural Hashing

#DEPRECATED

Hashing based on nested object structure is forbidden.

Only flattened key–value form is hashable.

---

## Forward Compatibility Rule

#LAW

Future extensions MUST:

* preserve flatness
* preserve key–value determinism
* preserve byte-level identity

No extension may introduce structure, ambiguity, or runtime dependency.

---

If you want, I can next:

* split this into **one-idea-per-block files**, or
* align it explicitly with *LiteRecords* / *LiteTapeSegments* / *Kernel Model*, or
* turn deprecated blocks into a historical note cluster.

#DEV

***
## Determinism and Sorting Rules
- #TODO

***
## Semantic Scope of Canonicalization
- #TODO

***
## Canonical Equivalence between Records
- #TODO

***
## Canonical Representation as Hashing Basis
- #TODO

***
## Relationship to LiteRecords and Runtime Structures
- #TODO

***
## Canonical Views of Nested or Composite Data
- #TODO

***
## Constraints on Canonical Structure Depth
- #TODO

***
## Serialization versus Conceptual Canonical Form
- #TODO

***
## Applicability Limits of Canonical Records
- #TODO

***
## Deprecated Canonicalization Ideas
- #TODO

***
## Historical Assumptions about Nesting
- #TODO

***
## Migration Notes and Forward Compatibility
- #TODO
