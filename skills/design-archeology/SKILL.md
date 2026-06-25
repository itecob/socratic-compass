---
name: design-archeology
description: Use when about to modify a file or subsystem you have not authored or recently touched
---

# Design Archeology

## Overview

Code carries contracts that aren't in the type system. Callers depend on side-effect order, invariants the implementation happens to preserve, and idioms that aren't enforced anywhere. Changing code without surfacing those first guarantees a regression.

**Core principle:** Read before you write. Name the implicit before you change the explicit. Persist what you found so the next session doesn't redo the read.

## Required Predecessor — `.architecture/design-notes/` must exist

This skill writes to `.architecture/design-notes/<source-path>.md`. If `.architecture/` doesn't exist, refuse and direct to `bootstrap-architecture.sh`. The `design-notes/` subdirectory is created by the bootstrap or on first use within an existing `.architecture/`.

## When to Use

**Always before:**
- Editing a file you have not authored
- Editing a file you have not touched in this session
- Refactoring across multiple files
- Changing an interface

**Skip when:**
- Creating a new file from scratch in a new directory
- Writing a comment or fixing a typo
- Reading-only operations (no modification planned)

**Re-run when:**
- Existing design notes for the file have a "Last verified" SHA that no longer matches the current source SHA (notes are stale)

## The "Existing Design Notes" block

The four outputs below together form the **"Existing Design Notes" block** referenced in spec §3.3 — the named artifact that downstream skills (brainstorming, planning) consume. The four sub-sections are the canonical structure of that block. (Per ADR 0016, the four-sub-section structure refines the spec's original single-block specification.)

## The Four Outputs

For each target file, produce:

### 1. Implicit Contracts

What do callers rely on that the type system does not enforce?
- Side-effect order ("must call init() before use")
- Return-value invariants ("never returns null, only empty array")
- Concurrency assumptions ("not safe to call from multiple threads")
- Idempotence claims ("safe to call twice")

### 2. Invariants Preserved

What must remain true after every change?
- Data invariants ("the in-flight count never exceeds the configured max")
- State machine constraints ("once closed, never reopens")
- Resource invariants ("every open() has a matching close() on every path")

### 3. Smells

What's already weak?
- Files over 500 lines
- Functions doing more than one thing
- Hidden state (module-level mutables)
- Tangled responsibilities

### 4. Implications for the Proposed Change

Given what the file currently does, what does the proposed change risk breaking? Which contracts/invariants/smells are most relevant to the modification?

## Persistence — write design notes per ADR 0015

After producing the four outputs, write to `.architecture/design-notes/<source-path>.md`, mirroring the source tree. A source file at `src/api/handlers.ts` produces design notes at `.architecture/design-notes/src/api/handlers.ts.md`.

### File format

```markdown
# Design Notes — <source-path>

**Last verified:** YYYY-MM-DD HH:MM against source SHA <short-hash>
**Reviewed by:** `compass:design-archeology` (session: <session-handoff filename or "manual">)

## Implicit contracts
<list from output 1>

## Invariants preserved
<list from output 2>

## Smells
<list from output 3>

## Implications for the proposed change
<output 4 — what the current change risks breaking>
```

### Staleness — check before reuse

Before consuming an existing `design-notes/<path>.md` for any downstream use:

1. Read the file's "Last verified" SHA.
2. Compare against the current source file's SHA (`git hash-object <path>` or equivalent).
3. If they match: notes are fresh; consume.
4. If they differ: notes are stale. Either re-run `compass:design-archeology` to refresh, or surface the staleness to the human and ask whether to use stale notes anyway.

Downstream skills (`compass:brainstorming`, plan-writing) must perform this staleness check. The discipline is enforced at the consumer, not just the producer.

## Process

1. Verify `.architecture/design-notes/` is writable. If not, refuse.
2. Identify the target file(s).
3. For each target file, check if `.architecture/design-notes/<path>.md` exists and is fresh (SHA match). If fresh, surface to the human and ask if they want to refresh anyway or proceed with existing notes.
4. Read the target file completely. No skimming.
5. Read its direct dependents (one or two levels of callers).
6. If the file is large, also read its tests — tests document contracts the source doesn't.
7. Produce the four outputs.
8. Write to `.architecture/design-notes/<path>.md` with the header (date, source SHA, session reference).
9. Surface the "Implications for the proposed change" section to the human as input to brainstorming or planning.

## Red Flags — STOP

- About to propose an edit without having produced or refreshed design notes.
- The implicit contracts list is empty (no code has zero implicit contracts; you missed them).
- The invariants list contains only type-system invariants (those aren't implicit).
- Thinking "I'll figure out the contracts as I edit."
- Consuming an existing `design-notes/<path>.md` without checking the source SHA.
- Skipping the persistence step ("I'll just present in chat"). Without the file, the next session has no record.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "I've seen code like this before" | Different codebases hide different contracts. Read this one. |
| "The function is small" | Small functions are often called from many places with overlapping assumptions. |
| "I'll just be careful" | Care without a list of constraints is luck. |
| "The tests would catch a regression" | Only if the tests cover the contract. Most don't. |
| "The design notes from yesterday are still good" | Check the SHA. If the file changed, the notes may be wrong. |
| "Writing the notes file is overhead" | Re-reading the file every time it gets touched is more overhead. |

## Bottom Line

Four outputs. Every file. Before any edit. Persisted with SHA. Consumed with SHA-check.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24). The `.architecture/design-notes/` directory mechanism is established by ADR 0015 in the Compass plugin's `.architecture/decisions/`.*
