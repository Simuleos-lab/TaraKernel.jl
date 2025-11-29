# Context and Issue

- This is a conceptual classification/formalization
- It is not a dercription of any protocole or implementation

## Context

- A Context is a **lite** metadata record describing an Issue.
- A Context MUST:
    - contain only lite data,
    - be serializable as in a stable representation,
    - remain human-readable and machine-indexable.
- A Context MUST NOT:
    - contain heavy blobs
        - If data prevents it from being lite, it can't be included.
        - that is, contain non-lite structures.

## Issue

- An Issue represents an observed artifact:
    - simulation state,
    - recorded event,
    - stored dataset,
    - any unit of work or state worth describing.
- An Issue MAY contain/:
    - non-lite data
    - binary blobs
    - external files,
    - domain-specific objects.

## Relationship

- A Context describes an Issue.
- An Issue MAY use its Context as its entirety if all information is lite.
- Otherwise:
    - the Context contains references to non-lite data,
    - the Issue owns or points to those blobs.

