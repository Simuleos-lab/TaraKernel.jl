## Consolidation
- This is no part of the kernel
- This is just thinking about upstream usage

- We migth have consolidators
- We produce Tapes that are meant to be 'local'
- It is only scoped to the producer application
- But, we can have another application that merge this Tape into a public, aggregated one
- The aggregator can create new Records and translate the local links
- That is, a key requirement is that no external tape link the local one
- The local Tape can link outside, that is ok
-- Any local link can be recomputed
-- Any non-local link, but outlink, needs no modification

- It is this, or we need a DNS kind of system which find `lib/tapes/records` by hash
- Option 1
- Any commit hash is an id of the lib/tap/segment stuff
- Usable in a link
- The "older" the hashes used, the more secure the link
- We can treat them independently 

- I think we need to be able to reproduce the hashing run
- I mean, if I give you a hash of a lib
- you need to be able to know all records it is locking
- Otherwise you would not be able to validate it
- This is solved by having a Segment like object in each Tape/Lib
- It is the collection IN ORDER, of all relevant hashes
- And it will have the committ prefixes as regular Segments
- [tapehash0, tapehash1, ..., tapehashk, libhash0]
- This is defining both the arder, and the hashing scope

- Option 2
- Maybe, even at the kernel level, a lib should also include a random UUID for universal localization
-- Maybe also a Tape
- Them, inside the lib we can just search for a content hash
- `#NO-GOOD` it wekkent hash locking

- That is, a link can be
- LibUUID/TapeHash/SegmentHash