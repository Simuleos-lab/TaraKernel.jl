## TaraKernel DataFlows (TKDF)
- #SPEC
- A **DataFlow** refers to the pipeline used to move data across the TaraKernel system.
- In general, at `TaraKernel`, data moves in pipes like this:
    - `External.DataType` → `TaraKernel.DataType_1` → `…` → `TaraKernel.DataType_k` → `External.DataType`
- `TaraKernel.DataType` does not mean that a type is *defined* in `TaraKernel.jl`.
    - It only means that the type subtypes a `TaraKernel.Base` abstract type
      and therefore participates in kernel semantics.
- An `External.DataType` is any type that does **not** subtype a `TaraKernel.Base` abstract type.
    - e.g. plain Julia `Dict`, `AbstractArray`, `IOStream`, or user-defined structures.
- A `DataFlow` is just a **specification**.
    - It is not an object in any implementation.
    - It is not part of runtime state.
    - It is not instantiated or manipulated as data.

---

## TKDF: Nature of a DataFlow (not a program)
- #LAW
- A DataFlow is **not** a control-flow specification.
- A DataFlow does **not** describe:
  - execution order,
  - scheduling,
  - concurrency,
  - atomicity,
  - looping,
  - or branching behavior.
- A DataFlow is a **semantic ordering constraint**, not a runtime algorithm.
- It defines:
  - which transformations are *meaningful*,
  - in which abstract direction data may evolve,
  - and which kernel operations are admissible.
- The ordering in a DataFlow expresses:
  - conceptual causality,
  - not temporal sequencing.
- A DataFlow does not dictate *when* steps occur:
  - only *which transitions are legal* under kernel semantics.

---

## TKDF: DataFlow are Central Dogmas
- #INSIGHT
- DataFlows are analogous to the "Central Dogma" in molecular biology:
- DNA -> RNA -> Protein
- This expresses:
    - directionality,
    - constraints,
    - and permitted transformations,
- but does not imply:
    - timing,
    - rates,
    - implementation mechanism,
    - or regulation logic.
- TaraKernel DataFlows play the same role:
    - they constrain meaning, not execution.

---

## TKDF: What is a DataFlow?
- #MODEL
- A DataFlow is a **named, ordered sequence of `tk_*` function calls**.
- It specifies *how* data is permitted to move between:
    - external runtime representations (`External.DataType`),
    - TaraKernel runtime objects (subtypes of `AbstractTKNode`),
    - and storage media (backend bytes, locators, etc.).
- Each step in a DataFlow is exactly one `tk_*` function invocation.
    - The **precise meaning** of each step is defined by:
        - the function’s type signature, and
        - its documentation where it is declared.
- A DataFlow does not define new semantics.
    - It only **selects and orders** existing kernel operations.
    - The semantics of data transformation live exclusively at the level of individual `tk_*` functions. 
        - `DataFlow`s contribute ordering, scope, and admissibility, but not semantic interpretation.
- If a step’s `tk_*` method:
    - is implemented in `TaraKernel.Base`, that is the reference implementation.
    - is defined only on abstract types, or unimplemented in `TaraKernel.Base`,
      then it is an **extension point** in the Julia sense.
- The set of `tk_*` functions that comprise a DataFlow plays the role of a Julia interface.
    - Implementing those functions for a type means
      that the type *participates* in that DataFlow.
- The declaration of each `tk_*` function defines:
    - which types are involved,
    - what role they play in the flow,
    - and what invariants they must satisfy.
- It is always the **user’s responsibility** to implement `tk_*` methods
  in a way that obeys the documented contract of the function and the DataFlow.
- A DataFlow expresses:
    - legal transformation paths,
    - kernel boundaries,
    - and responsibility handoff points,
    without introducing any execution mechanism or runtime abstraction.


---

## TKDF: Runtime
* #LAW
* We say data is at **Runtime** when:
  * it lives in a **transient medium**
    - in-memory objects
    - ephemeral buffers
    - process-local state
    - etc
  * it may be created, mutated, discarded, or recomputed freely,
  * it is not required to be canonical, validated, or complete at all times,
  * it may exist in either:
    * uncommitted form, or
    * committed form.
* Runtime describes:
  * *where* data lives,
  * not *what grade* it has.
* Losing Runtime data:
  * does **not** violate kernel guarantees,
  * as long as `Storage` remains intact,
  * even if the lost data had already been committed.
* Runtime exists to provide:
  * utility,
  * manipulation,
  * transformation,
  * validation,
  * and staging for storage.

---

## TKDF: Committed data
* #LAW
* We say data is **Committed** when:
  * it has passed through a **commit operation**,
  * it satisfies kernel invariants:
    * immutability,
    * canonical representation,
    * content integrity (hashing, commit structure, etc.),
  * its logical identity is fixed.
* Committed describes:
  * *what grade of correctness and authority* the data has,
  * not *where the data lives*.
* Committed data may exist in:
  * `Runtime` (e.g. in memory, buffers, pipelines),
  * `Storage` (e.g. on disk, in archives, in libraries).
* Once data is Committed:
  * it must not be mutated,
  * it must not be re-canonicalized,
  * it must not be re-interpreted for identity purposes.
* Committed data:
  * is authoritative by kernel policy,
  * is treated as fact,
  * is eligible for persistence,
  * but is not guaranteed to be durable unless it also resides in Storage.
* Commit is an **irreversible semantic transition**:
  * identity is created at commit time,
  * all future references depend on this identity.



---

## TKDF: Storage

* We say data is at **Storage** when:
  * it is already **Committed** (immutable, canonical, identity-bearing),
  * and it has reached a **persistent medium** intended to survive process lifetimes.
* Storage therefore represents:
  * **Committed + durable** state.
* Data at Storage:
  * is expected to be recoverable later,
  * may be accessed by other processes,
  * may outlive any single runtime session.
* All kernel invariants apply to Storage data:
  * immutability (append-only evolution at the Tape level),
  * canonical representation (TaraSON / canonical bytes),
  * content integrity (hashing, commit validation, etc.).
* The kernel may treat Storage as:
  * an authoritative source of facts,
  * the historical record of committed content,
  * the long-term memory substrate of the system.
* The same *logical* content may exist at:
  * Runtime,
  * Committed state,
  * and Storage
    simultaneously,
    but only Storage is required to be **durable**.
* Runtime copies and committed-but-not-yet-stored copies are:
  * utility representations,
  * volatile by nature,
  * not relied upon for long-term correctness.





---

## TKDF: TaraKernel.Runtime data
- #MODEL
- We say data is in **TaraKernel.Runtime** when:
  - it is represented by a `TaraKernel.DataType`
    (i.e. a subtype of some `TaraKernel.Base` abstract type),
  - and it currently resides in a Runtime medium.
- Thus:
  - `External.DataType` at Runtime: outside kernel semantics.
  - `TaraKernel.DataType` at Runtime: inside kernel semantics, but still transient.
- Transitions between:
  - `External.Runtime` <-> `TaraKernel.Runtime`
  - `TaraKernel.Runtime` <-> `Storage`
  are exactly the boundary points that DataFlows make explicit and govern.

---

## TKDF: DataFlows usage
- #SPEC
- The purpose of explicitly specifying DataFlows is to:
  - Declare **semantic boundaries**:
      - between the kernel and the outside world,
      - between `TaraKernel.Base` and kernel extensions,
      - between `Runtime` and `Storage`.
  - Enumerate the **legal transformation paths** that data may take
    - while it is under kernel authority.
  - Define where **responsibility is transferred**:
      - from user code to the kernel,
      - from runtime handling to storage guarantees.
  - Justify the inclusion of concrete types in `TaraKernel.Base`:
      - a type belongs in `TaraKernel.Base` if
        - it participates in most legal DataFlows,
        - or is structurally fundamental to them.
- DataFlows do not prescribe implementation techniques.
- They prescribe 
    - **what is allowed**, 
    - **what is guaranteed**, 
    - **where the kernel draws its lines**.

---

## TKDF: Non-Goals and Explicit Exclusions
- #LAW
- A DataFlow defines **admissible transformations**, not an execution model.
- A DataFlow does **not**:
    - define control flow, branching, or looping.
    - impose sequencing beyond the explicit order of `tk_*` calls it declares.
    - prescribe scheduling, threading, or concurrency behavior.
    - imply atomicity, transactionality, or rollback semantics.
    - define locking or mutual exclusion.
    - guarantee consistency under concurrent modification.
    - enforce error recovery or retry behavior.
    - manage resource lifetimes (memory, file handles, buffers, etc.).
    - coordinate distributed systems or processes.
    - provide messaging, eventing, or orchestration semantics.
    - constitute a pipeline abstraction at runtime.
    - introduce any executable construct whatsoever.
- A DataFlow is a **semantic contract only**:
    - it specifies *what is allowed*,
    - not *how or when it runs*.
- No implementation is required to:
    - “execute a DataFlow”,
    - “instantiate a DataFlow”,
    - or “manage DataFlows” as runtime objects.
- All execution behavior arises exclusively from:
    - host language control flow,
    - implementation code,
    - and explicit `tk_*` function invocation.
- A system that respects DataFlows:
    - obeys declared boundaries,
    - upholds stated invariants,
    - and enforces the contracts of `tk_*` functions,
- but is otherwise free in its execution strategy.

---

Nice, that’s a very clear intent. Let me translate that into something you can drop into the spec.

Below is a candidate block you can paste (and tweak) under `TKDF: Runtime` or in its own section like `TKDF: Runtime correctness`.

---

### TKDF: Runtime and Correctness

* #LAW
* The kernel is responsible for **correctness at all boundaries** where data enters or leaves kernel authority.
* Inside Runtime, data may be:
  * incomplete,
  * temporarily inconsistent,
  * or invalid with respect to storage invariants.
* This is permitted **only** as long as the data has not crossed a boundary into:
  * TaraKernel.Storage, or
  * any interface where kernel guarantees are claimed.

---

### TKDF: Checkpoints and Enforcement
* #LAW
* The kernel enforces correctness at **checkpoints**, not continuously.
* A **checkpoint** is any `tk_*` operation that:
  * transitions data into Storage, **or**
  * exposes data as a kernel-validated type.
* At each checkpoint:
  * data MUST satisfy all applicable invariants (canonical, lite, hash-consistent, etc.),
  * failure to satisfy them is a **kernel error** (not a user-level convention),
  * invalid data MUST be rejected and MUST NOT (NEVER) be promoted to Storage.
* Between checkpoints:
  * the kernel does **not** promise correctness of intermediate Runtime values,
  * it only promises that invalid values will be detected before any checkpoint that claims correctness.

---

### TKDF: Temporarily Invalid Runtime Data

* #MODEL
* Runtime tools provided by the kernel MAY operate on:
  * temporally invalid,
  * partially constructed,
  * or not-yet-canonical data.
* Such tools exist to:
  * build up canonical content incrementally,
  * aid migration, repair, or transformation,
  * support interactive or exploratory workflows.
* However:
  * any operation that would *commit* such data to Storage,
  * or present it as a canonical kernel fact,
    * MUST first pass through a correctness checkpoint and may fail there.

---
