# ADR 0015: Design-archeology outputs persist to `.architecture/design-notes/<source-path>.md`

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The `design-archeology` skill produces "Existing Design Notes" blocks describing implicit contracts, invariants, and smells of files/subsystems before they're modified. Per ADR 0014's precedent for premise-check, downstream skills benefit when outputs persist to disk. But design-archeology differs from premise-check: it runs per-file/subsystem (potentially many times per session) and its output goes stale when the source changes.

The per-skill mini-interview surfaced two real concerns: frequency (many small files vs few large reports) and staleness (notes describe a moment in time; source code drifts).

## Decision

Persist design-archeology output to `.architecture/design-notes/<source-path>.md`, mirroring the source tree under the design-notes directory.

### Path mapping

A source file at `src/api/handlers.ts` produces design notes at `.architecture/design-notes/src/api/handlers.ts.md`. The `.md` extension is appended to the original path so the design-notes tree is a one-to-one mirror of the source tree.

Rationale: mirroring lets a future agent or human navigate from a source file to its design notes by path transformation. Alternatives (flattened with dashes, hashed names) lose navigability.

### Staleness handling

Every design-notes file includes a header:

```markdown
# Design Notes — <source-path>

**Last verified:** YYYY-MM-DD HH:MM against source SHA <short-hash>
**Reviewed by:** `compass:design-archeology` (session: <session-handoff filename or "manual">)

<the four outputs: Implicit contracts, Invariants preserved, Smells, Implications for the proposed change>
```

Before consuming an existing design-notes file, downstream skills check the source SHA against current HEAD. If they differ, the notes are stale; design-archeology re-runs to refresh, or surfaces the staleness to the human and asks whether to use stale notes or refresh.

### Frequency tolerance

Many small files is acceptable. The design-notes/ tree grows alongside the source tree as parts of the codebase get archeology'd. That growth is itself useful — it documents which parts have been examined.

## Consequences

**Easier:** brainstorming and other downstream skills mechanically find design notes by path transformation. Cross-session continuity preserved. Staleness is detectable, not silent.

**Harder:** another structural directory in `.architecture/`. SHA tracking adds a small step to design-archeology. Mirroring the source tree means design-notes/ inherits the source tree's structure (potentially many directories).

## Alternatives considered

- **No persistence.** Rejected: loses cross-session continuity; brainstorming has to re-run archeology or work without it.
- **Flattened path encoding** (e.g., `src-api-handlers.ts.md`). Rejected: collisions possible (`src/api/handlers.ts` and `src-api-handlers.ts` both flatten to the same key); not navigable.
- **Conditional persistence** (save only when brainstorming immediately follows). Rejected: threading dependency between skills is complex; staleness is the same problem regardless.

## Invariants this creates

- **INV-020:** Every `design-notes/<path>.md` file includes the source-path header and the "Last verified" SHA line. Verification: `head -3 .architecture/design-notes/**/*.md` shows the expected header pattern on each file.

## Schema implications

- New directory: `.architecture/design-notes/` is canonical (added to spec §3.5 layout via this ADR).
- Bootstrap template adds `design-notes/README.md` placeholder.
- `bootstrap-architecture.sh` printed instructions list the new directory.
- Plugin and template `.architecture/manifest.md` list it under Contents.
