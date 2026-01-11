
---
# Create issue about
> What about: Forbid the use of reserved `/__Tara/` keys in user-submitted data to prevent hash collisions.
- we can take the lazy path
- Using those fields is a non defined behaviour
- You should not use them

---
# Create issue about
> Tape as Link List
- include on each record a `prev`, `next` fields
- pros
    - Help Storage implementations
- cons
    - non independent hash lock at record level

---
# Create issue about
The Kernel Storage is part of the kernel
- even if we will have a plugable interface for Storage
- we will provide a Disk Stora that is Part of the Kernel Spec
- meaning
- You can always produce such Storage representation using the Kernel
- Its design influence the non-Storage part of the kernel
- we can call it 
    - CanonicalStorage
    - KernelStorage