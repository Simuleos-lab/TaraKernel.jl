
## TKDF: DataFlow.N1: ingestion and commit from runtime
- #WIP
- name: `DataFlow.N1`
- This is the only way to introduce additional (new/more) logical content into the system.
- The flow, at the most abstract level, is:
1. Data exists in an `External.DataType`.
2. Data is **ingested** into a `TaraKernel.DataType` at Runtime.
3. More `TaraKernel.Runtime` data may be ingested or **transformed**.
4. `TaraKernel.Runtime` data is **committed** to Storage via a backend.
- Steps 2–4 are kernel steps:
    - they are expressed and constrained by kernel (`tk_*`) functions.
- Steps 2–3 are `TaraKernel.Base` steps:
    - they are implemented by `TaraKernel.Base` (`_tk_*`) functions.
- Steps 1–3 happen entirely at **Runtime**.
- Step 2 is the boundary between `External.Runtime` and `TaraKernel.Runtime`.
- Step 4 is the boundary between `TaraKernel.Runtime` and **Storage**.

--- 
