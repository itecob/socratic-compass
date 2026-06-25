# ADR 0003: Hooks print reminders, never block

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** A
**Provenance note:** Pre-interview-system decision (back-filled per C-006 audit on 2026-06-25). Author-drafted during initial spec/plan creation; human ratified at spec submission.
**Context:** Claude Code hooks can be advisory (print) or blocking (non-zero exit). Cowork has no hook mechanism.
**Decision:** All hooks print reminders and exit 0. Never block.
**Consequences:** Easier — Cowork parity at the skill level; users who disagree with a hook are not stuck. Harder — hooks have no enforcement teeth; skill descriptions carry the triggering load.
**Alternatives considered:** Blocking hooks — rejected: creates parity gap with Cowork; punishes users who deliberately opt out.
**Invariants this creates:** INV-003 (every hook script exits 0 regardless of detection).
