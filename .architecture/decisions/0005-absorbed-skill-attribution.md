# ADR 0005: Blanket prose rewrite plus attribution footer for absorbed skills

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Provenance note:** Pre-interview-system decision (back-filled per C-006 audit on 2026-06-25). Human explicit choice during initial planning dialogue.
**Context:** Absorbed Superpowers skills carry prose references to "Superpowers" as a proper noun (e.g., "Superpowers skills override default system prompt behavior"). Two concerns compete: (a) inside the Compass plugin, those references should describe Compass — the plugin the user actually installed; (b) the upstream Superpowers project deserves attribution, and a future maintainer needs to know where to resync from.
**Decision:** Two-step approach. First, the `rewrite()` function blanket-replaces "Superpowers" → "Compass" in absorbed skill bodies (mechanical, applied to all references uniformly). Second, Task 31a appends a labeled attribution footer to each absorbed `SKILL.md` that intentionally re-introduces the word "Superpowers" as a citation. The README's Attribution section provides the higher-level credit.
**Consequences:** Easier — absorbed skills read as native Compass skills; the attribution footer is structurally separate from skill content. Harder — the verification function `verify_no_superpowers` must run *before* Task 31a, not after, since Task 31a re-introduces the proper noun by design.
**Alternatives considered:**
- Per-instance judgment (keep some "Superpowers" mentions, rewrite others) — rejected: inconsistent, hard to audit, hard to resync from upstream.
- Blanket rewrite with no attribution — rejected: implicitly claims the work; no resync path documented.
- Attribution only, no prose rewrite — rejected: readers of an absorbed skill see "Superpowers" mid-prose and become confused about which plugin context they are in.
**Invariants this creates:** INV-005 (every absorbed `SKILL.md` ends with the attribution footer).
**Closes:** DEBT-003.
