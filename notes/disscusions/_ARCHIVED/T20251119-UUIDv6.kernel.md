## UUIDv4
- collisions are extremely rare

## UUIDv6 — a sequential, privacy-safer redesign of v1

- Recently standardized (RFC 9562).
- Contents:
    - Reorders timestamp bits so resulting IDs are monotonically increasing
    - Replaces the MAC address with a random node identifier (no privacy leak)
- Benefits:
    - Very good for databases because indexes remain ordered
    - Still has time-based structure → practical uniqueness guarantee
    - No MAC address reveals
- Problems:
    - Clock rollback still needs handling
    - Not universally supported in libraries (yet)