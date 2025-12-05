## Context and Issue
- #MODEL
- Both are a conceptual classification.
- It is not a description of a protocol or an implementation.

---

## Concept: Context Record
- **Type**: Concept
- A Context is a **lite** record describing an `Issue`.
- This is one of the interpretation of `TaraSON` records
- They are use for codifiying contextual data
- **Rules**
- A Context MUST:
    - #LAW
    - contain only lite data,
    - be serializable in a stable representation,
    - remain human-readable and machine-indexable.
- A `Context` MUST NOT:
    - #LAW
    - contain heavy blobs,
        - large arrays or serialized structs
- #NOTE
    - If data prevents the `Context` from being lite, it cannot be included.

---

## Concept: Issue
- An Issue represents some recorded or observed entity, for example:
    - simulation state,
    - recorded event,
    - stored dataset,
    - any unit of work or state worth describing.
### Rules
    - #MODEL
    - An Issue codificaion MAY contain:
        - non-lite data,
        - binary blobs,
        - external files,
        - domain-specific objects.

---

## Concept: Context Issue Relation
- ### Rules
    - #LAW
    - A Context describes an Issue.
- #LAW
- An Issue MAY be represented entirely by its Context
    - *if and only if* all information is lite.
- #MODEL
- Otherwise:
    - the Context contains references to non-lite data,
    - the Issue owns or points to the actual data.

---
