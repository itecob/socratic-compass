# ADR 0016: Spec §3.5 amended to reflect post-spec architecture additions; design-archeology output retains spec's "Existing Design Notes" name as a wrapper

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The Phase 3 adversarial subagent review (`.architecture/validation/phase-03-2026-06-24-2105.md`) surfaced two related concerns:

1. Multiple post-spec ADRs (0011, 0013, 0014, 0015) added new directories to the canonical `.architecture/` layout, but `specs/2026-06-24-compass-design.md` §3.5 was never amended. Spec is the contract; contract diverged from implementation silently across four ADRs.

2. The `design-archeology` SKILL.md produces four named output sections (Implicit Contracts, Invariants Preserved, Smells, Implications for the Proposed Change), but spec §3.3 names the deliverable an "Existing Design Notes" block. The new output (#4) genuinely added value over the spec's three; the spec's block-wrapper name was lost.

Both are silent spec deviations per INV-010 — they need explicit ADR coverage.

## Decision

### Part 1 — Spec §3.6 amendment (formal acknowledgment, no spec file edit)

This ADR is the canonical record of the additions. The spec file itself is **not** edited (per ADR 0011 / INV-013, spec §11 success criteria are locked, and amending one section opens precedent for amending others mid-build). Instead, this ADR explicitly enumerates the post-spec schema:

| Directory or file | Established by | Added by |
|---|---|---|
| `.architecture/scope-deferred.md` | ADR 0009 | Build session 2026-06-24 |
| `.architecture/validation/` | ADR 0011 | Build session 2026-06-24 |
| `.architecture/premise-checks/` | ADR 0014 | Build session 2026-06-24 |
| `.architecture/design-notes/` | ADR 0015 | Build session 2026-06-24 |

At Phase 8 (final verification), spec §3.6 will be rewritten to incorporate these additions before any release tag, per INV-015's parallel pattern for README/CHANGELOG. Until then, this ADR is the authoritative schema reference; the spec is the *original* schema reference. New readers should consult both.

### Part 2 — design-archeology output naming

The four sections (Implicit Contracts, Invariants Preserved, Smells, Implications for the Proposed Change) are the **contents of the spec's "Existing Design Notes" block**, not a replacement for it. The `design-archeology` SKILL.md is updated to make this explicit: the block is named, then divided into four sub-sections; the fourth (Implications) is a Phase-3 addition that focuses the design notes on the change at hand rather than leaving the consumer to derive implications.

Downstream skills consuming design-notes by name will look for the block; the SKILL.md's persisted file format makes the block heading explicit.

## Consequences

**Easier:** Spec-vs-build drift is captured in one auditable ADR instead of being implicit across four. The spec file remains stable until the Phase 8 rewrite. design-archeology's output now carries both the spec name (for compatibility) and the more informative four-section structure (for utility).

**Harder:** Two sources of truth for the schema until Phase 8 (the spec and this ADR). Readers must consult both. The Phase 8 rewrite must address §3.5 as well as §3.3 (the latter for the design-archeology output naming).

## Alternatives considered

- **Edit the spec file directly.** Rejected: violates INV-013's spec-stability principle (§11 success criteria are locked; amending other sections weakens the principle). Phase 8 is the appropriate point for a single coherent rewrite.
- **Rename design-archeology output back to "Existing Design Notes" only (delete the four-section structure).** Rejected: the four-section structure is more useful; "Implications for the Proposed Change" is a real addition that helps the consumer.
- **Document the schema drift only in `scope-deferred.md`.** Rejected: scope-deferred is for things genuinely deferred; this is something we're acting on (the spec rewrite is real, just deferred to Phase 8). ADR is the right form.

## Invariants this creates

- **INV-021:** Spec §3.5 is rewritten before any release tag to include the four post-spec additions (`scope-deferred.md`, `validation/`, `premise-checks/`, `design-notes/`). Verification: at Phase 8, `grep` spec §3.6 for each new directory; all must appear. Failure means do not tag.
- **INV-022:** Spec §3.3's "Existing Design Notes" block is rewritten to enumerate the four sub-sections. Verification: at Phase 8, `grep` spec §3.3 for "Implications for the Proposed Change" (or the renamed equivalent).
