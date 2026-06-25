# ADR 0002: Absorb Superpowers skills rather than declare a dependency

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** A
**Provenance note:** Pre-interview-system decision (back-filled per C-006 audit on 2026-06-25). Author-drafted during initial spec/plan creation; human ratified at spec submission.
**Context:** The plugin needs Superpowers workflow skills (brainstorming, writing-plans, TDD, etc.) but plugins do not yet have a dependency mechanism.
**Decision:** Bundle copies of the required Superpowers skills under the `compass:` namespace.
**Consequences:** Easier — plugin works standalone; no install ordering. Harder — duplicate skills if a user has both plugins; absorbed skills must be re-synced when Superpowers updates upstream.
**Alternatives considered:**
- Declare a runtime dependency on Superpowers — rejected: mechanism does not exist.
- Skip absorbed skills and document a Superpowers prerequisite — rejected: violates standalone requirement.
**Invariants this creates:** INV-002 (the plugin must install and function on a system without Superpowers).
