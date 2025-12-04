# TaraSON and runtime lite definition
- Im removing at kernel level the requirement that arrays must only contain literals
- In the canonical representation
    - arrays do not exist
    - dict do not exist
    - So, why impose any input struct
- The kernel will expose a very simple recursive `islite` interface
