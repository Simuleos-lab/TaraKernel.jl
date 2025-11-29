- #NOTE  
- synonymus  
    - **Artifact** is `#PREFERED`  
    - **BinData**, **BinNode** are `#DEPRECATED` (superseded by the Tara layer concept of *external Artifact referenced by a ContextRecord*, not embedded)

- #NOTE  
- synonymus  
    - **ContextRecord** is `#PREFERED`  
    - **LiteRecord** is `#PREFERED` *as the implementation substrate in TaraKernel*  
    - **ContextBlob**, **ContextNode** are `#DEPRECATED` (superseded by the canonical ContextRecord spec and flat TaraSON)

#NOTE  
- Good context: https://adactio.com/articles/1522/  

#NOTE  
- Use *modeling* in the name of the ContextRecord  
    - A ContextRecord is indeed a *model* (representation) of an Issue `#LIKED`  
    - A ContextRecord aims to answer *meaningful* questions about the Issue, using **lite** and **TaraSON-compatible** fields only  
    - A ContextRecord may include a `"purpose"` field describing which questions it intends to help answer `#OPTIONAL`  
    - This keeps the object a modeling unit, consistent with the Tara Project's view of Context as a lite, intentional description

***
#NOTE  
1. Write a script  
2. Run it  
    2.1 state 0  
    2.2 state 1  
    2.3 state 2  
        2.3.1 Describe state 2  
        2.3.2 Use the same deterministic, lite encoding (TaraSON)  
    - Only **lite, shallow, deterministic** data becomes part of the ContextRecord  
    - Heavy data becomes an **Artifact**, referenced but not embedded  

***
#NOTE  
# Obsidian Integration of out-of-vault files

At first, integration can remain minimal.  
We can simply work with `.md` notes.  
External files may appear as **Artifacts** (referenced by ID/path); the note’s contextual description (the lite part) becomes a ContextRecord.  
A collector may symlink or snapshot notes so that the *ContextRecord* persists inside a Tara-compatible tape even if the external path changes.

***
#DESIGN  
Simuleos tooling encourages producers of data to emit **text-encoded, lite contextual layers** (ContextRecords).  
Each layer takes an initial data view (Scope → Transform Hook) and derives a TaraSON object.  
Different layers correspond to *different contextual transformations*, but all use the **flat, deterministic TaraSON standard**.  
This simplicity is necessary so ContextRecords are:  
- portable  
- comparable  
- hashable  
- durable  
- recorder-agnostic

***
#THINKING  
The problem of the two data types:

There is **Contextual Data**  
- It must be **lite**, **human-readable**, **TaraSON**, and **deterministic**.  
- Anything non-lite must not be stored inline.

There is **Artifact Data**  
- Any non-lite, heavy, binary, or complex data produced by the Issue.  
- ContextRecords do not embed these; instead they refer to them.  
- A ContextRecord describes the environment and meaning surrounding the Artifact.  
- This keeps the ContextRecord small, portable, and queryable.

***
#TODO  
An Artifact descriptor is part of the **ContextRecord** as a *link*, not as an embedded structure.  
For example:

```json
{
    "artifact.id": "sha256-AAA....",
    "artifact.loc": "rel/path/to/file.jld2",
    "artifact.kind": "simulation.output"
}
````

* Keys must remain **flat** (no nested objects).
* This is a canonical TaraSON pattern for referencing heavy data.
* Additional descriptive fields are allowed, but always lite.

---

#NOTE
How do we know a field represents an Artifact?

* No special nested type tag (e.g. `"__type__": "BinNode"`) is used anymore.
* The recorder uses **conventions** (`artifact.*`) or a well-defined schema layer above TaraSON.
* ContextRecord remains purely lite and flat.
* Artifact resolution is performed by ContextRecorders (Simuleos, etc.), not the kernel.

---

#NOTE

* ContextRecords may also include computed labels (`"label.*"` fields)
* These remain lite and aid indexing/searching
* They do not carry type tags or internal metadata blocks

---

#NOTE
The entire Context DB is simply a collection of **flat TaraSON objects**.

* Implementations provide tooling for Artifact lookup and linking.
* The Context layer itself is non-opinionated about data loaders.
* All loader hints must be encoded as **lite flat keys**, not nested structures.

---

#NOTE
Handling non-Context (non-lite) input:

```json
{
    "complex.model": null,
    "param.x.value": 12.34
},
{
    "complex.model.type": "MyJuliaType",
    "complex.model.value": null,
    "param.x.value": 12.34
}
```

* Option 1: omit non-lite data (turn to `null`)
* Option 2: describe the non-lite object lightly
* Both approaches produce valid TaraSON and satisfy the flatness + lite discipline
* Final ContextRecord must contain **only lite fields**

%% Tags ------------------------------------------------------- %%
#Vault/notebook
#Editor/josePereiro
