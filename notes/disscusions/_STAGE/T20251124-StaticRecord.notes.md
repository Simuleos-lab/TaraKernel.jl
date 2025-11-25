## 1. Core invariant: what `StaticLiteRecord` *means*

Regardless of how you construct it (copy or not), I’d lock in:

> **If it’s a `StaticLiteRecord`, then it is lite, flat, and internally consistent with TaraSON.**

So:

* All keys are strings.
* All values passed the *lite* validator.
* Flatness / size constraints are satisfied.
* Canonicalization is defined and stable.

That’s the semantic contract; the user should never have to wonder “did I construct this via the unsafe path?”.

Copying or aliasing is then *purely* an implementation detail with performance implications, not a semantic change.

---

## 2. Where validation happens

Given that decision:

* The **validator lives in LiteRecords** and is called:

  * on `StaticLiteRecord` construction (any constructor that claims to build one),
  * and on parse-from-disk when wrapping raw TaraSON into a record.

So your flow is:

* `Dict` / builder → validate lite + flatness → `StaticLiteRecord`
* bytes → parse TaraSON → validate lite + flatness → `StaticLiteRecord`

Everything else (tapes, hashes, dedup) can now assume “this record is valid”.

---

## 3. Copying as an optional behavior

You basically have a 2×2 grid:

* **Validation**: yes/no
* **Copying**: yes/no

You’ve already decided validation should always be **yes** for `StaticLiteRecord`. That collapses the grid to:

1. **validate + copy** (default, safe)
2. **validate + no copy** (opt-in, fast)

That’s clean and simple.

### 3.1 Default: validate + copy

This is what you use in normal code and public APIs:

* Take a `Dict` (or some builder).
* Run lite + flatness validator.
* Copy the data into an internal map.
* Compute (or prepare for) canonical form / hash.

Properties:

* Immutable in practice (no one else has a handle to your internal map).
* Invariants cannot be broken accidentally.

This is the “boringly correct” path that most callers should use.

### 3.2 Opt-in: validate + no copy

This is your “I know what I’m doing” fast path:

* Take the caller’s Dict.
* Validate it is lite + flat.
* **Do not copy**; just wrap it.

Now:

* If the caller mutates the Dict afterwards, all bets are off:

  * The record might stop being lite.
  * Previously computed canonical/hash (if any) may become wrong.

But that’s **outside the API contract**, as you said. You can document:

> “If you construct a `StaticLiteRecord` with `copy=false`, you must treat the original Dict as frozen from that point onwards. Mutating it is undefined behavior.”

That’s a perfectly acceptable stance for a low-level library.

---

## 4. Hashing / canonicalization and aliasing

One subtle point: what happens if you cache canonical/ hash when `copy=false` and the caller later mutates the Dict?

You have two basic approaches:

### 4.1 Strict but trusting

* Behave exactly as in the copy case:

  * compute canonical representation and hash once,
  * cache them in the record.
* Document that **mutating the underlying Dict after construction is UB**, including hash inconsistencies.

This keeps the code simple and fast. The cost is: if someone misuses the no-copy path, bugs can be quite weird — but they explicitly opted into “unsafe”.

### 4.2 Paranoid debug mode

* Same as above, but in a “debug mode” (env var, feature flag) you:

  * optionally re-run validation / canonicalization in strategic places (e.g. before writing to disk, or before computing hash),
  * assert if something changed.

This lets you detect misuse during development without paying the cost always.

Given your philosophy, I’d:

* keep the **implementation simple** (no special machinery),
* rely on **documentation + a validator**,
* and maybe add an optional debug flag later if you actually see this go wrong.

---

## 5. Do you still need `UnsafeMaybeStaticLiteRecord`?

With the decision:

* “StaticLiteRecord is always validated lite”
* “Copying is tunable but orthogonal”

you no longer *need* a second type to express “maybe not lite”.

Instead:

* `StaticLiteRecord` = **validated, lite, flat, maybe-copies-its-data**.
* If you ever want to work on *truly unvalidated* maps (e.g. generic JSON trees, partially-parsed payloads), you can:

  * just use `Dict` or a “raw record” struct,
  * or introduce some separate “raw/parsed” type later, but it no longer has to impersonate a static record.

I’d only introduce `UnsafeMaybeStaticLiteRecord` if you later find you really want a **read-only view type over unvalidated data** that still participates in some APIs. For now, your “validate always” decision makes it unnecessary.

---

## 6. What about “validate only at disk boundaries”?

Given this new stance, I would *not* do that for `StaticLiteRecord`:

* If you allow invalid StaticLiteRecords internally and only blow up at disk write:

  * you push bugs far away from their source,
  * lots of code can accidentally start depending on “invalid but works for now”.

By validating on construction, you:

* keep `StaticLiteRecord` a trusted internal currency,
* make write/IO code simpler: it assumes records are already correct.

If you want a “record-ish thing that may be invalid and is only checked at IO”, that’s a different concept — closer to an “ingest buffer” than a static record.

---

## 7. Summary of the contracts

**StaticLiteRecord**

* Always lite + flat (validation enforced on construction).
* Immutable by API.
* May or may not own a copy of the underlying Dict:

  * **default**: validates and copies (safe).
  * **opt-in**: validates but does not copy (fast, caller must not mutate).

**Lite validation**

* Lives in LiteRecords.
* Used whenever you cross the boundary:

  * arbitrary Julia data → StaticLiteRecord,
  * raw TaraSON → StaticLiteRecord.

With that you get:

* a very clean mental model,
* room for an “unsafe, no-copy” fast path,
* and no need to multiply types just to express ownership.
