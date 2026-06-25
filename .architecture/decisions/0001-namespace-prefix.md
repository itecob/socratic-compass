# ADR 0001: Use `compass:` as the skill namespace prefix

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** A
**Provenance note:** Pre-interview-system decision (back-filled per C-006 audit on 2026-06-25). Author-drafted during initial spec/plan creation; human ratified at spec submission.
**Context:** Skills cross-reference each other via prefix; collisions are possible with other plugins (notably Superpowers). The prefix must be both unique and readable.
**Decision:** Use `compass:` (long form) rather than `se:` (short form).
**Consequences:** Easier — references are self-documenting and unlikely to collide. Harder — every absorbed skill needs sed rewriting and the prefix is verbose in cross-references.
**Alternatives considered:**
- `se:` — rejected: too short to be self-documenting; high collision risk.
- `strat-eng:` — rejected: hyphenated abbreviation reads worse than the full word.
**Invariants this creates:** INV-001 (every absorbed skill has cross-references rewritten).
