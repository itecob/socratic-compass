# ADR 0014: Premise-check outputs persist to `.architecture/premise-checks/`

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The `premise-check` skill produces five outputs (two framings, load-bearing assumptions, pivotal question, validation, categorization). The skill's spec (§3.2) said "present all five outputs to the human" but did not say where the outputs persist after presentation. Downstream skills depend on them: `design-archeology` needs the categorization; `brainstorming` needs the framings; `adversarial-review` needs the validation results. Without persistence, downstream skills either re-derive (waste) or re-ask (friction).

The per-skill mini-interview for `premise-check` surfaced this as the load-bearing gap.

## Decision

Each `premise-check` invocation produces an artifact at `.architecture/premise-checks/YYYY-MM-DD-HHMM.md`. The artifact contains all five outputs in a structured form, plus a reference to the originating interview transcript at `.architecture/interviews/`.

### Artifact format

```markdown
# Premise-Check — YYYY-MM-DD HH:MM

**Source interview:** `.architecture/interviews/YYYY-MM-DD-HHMM.md`
**Task:** <one-line task description from the interview's problem statement>

## 1. Two alternative framings
<from the interview, in the human's words>

## 2. Load-bearing assumptions
<numbered list from the interview>

## 3. Pivotal question
<from the interview's "Open questions deferred">

## 4. Validation against the architecture journal
**Plausibility:** <conflicts with documented invariants/ADRs — cite INV-IDs and ADR numbers, or "none found">
**Surface feasibility:** <known-impossible or known-failed — cite source, or "none found">
**Prior art:** <similar past attempts — cite ADRs or session-handoffs, or "none found">

## 5. Categorization
**Domain familiarity:** novel | familiar | mixed
**Task type:** feature | bug fix | refactor | infrastructure | migration | exploration | other
**Suggested process weight:** light | standard | heavy

## Human's response
<confirmation, corrections, overrides — recorded so the rest of the build can reference what the human actually agreed to>
```

### Schema implications

- New directory: `.architecture/premise-checks/` is canonical (added to the spec §3.5 layout via this ADR).
- Bootstrap template adds a `premise-checks/README.md` placeholder so the directory survives in fresh projects.
- `bootstrap-architecture.sh` printed instructions list the new directory.
- `.architecture/manifest.md` template lists it under Contents.

## Consequences

**Easier:** downstream skills mechanically read a known file path. No re-derivation, no re-asking, no chat-only fragility. The premise-check becomes an auditable record alongside the interview.

**Harder:** one more directory in the schema (so one more thing to maintain). Future tools that re-run premise-check must either append a new dated file (preferred) or version within the file (avoid; mutation is fragile).

## Alternatives considered

- **No persistence.** Rejected: makes downstream skills fragile; loses the audit trail.
- **Append to the interview transcript.** Considered. Cleaner conceptually (one file per planning cycle), but appending is a mutating operation; multiple premise-checks on the same interview would require versioning within the file. The discrete-file pattern (per-invocation timestamp) avoids the mutation issue.

## Invariants this creates

- **INV-019:** Every premise-check invocation produces a file in `.architecture/premise-checks/` named with the date-time of the invocation. Verification: at session end, the count of premise-checks files matches the count of premise-check invocations recorded in the session-handoff.

## Back-fill

The premise-check conducted earlier in the 2026-06-24 interview session (before this ADR was written) is back-filled to `.architecture/premise-checks/2026-06-24-1731.md` to maintain consistency.
