---
name: architecture-journal
description: Use at session start in a project with a .architecture/ directory, and when a structural decision is being made or an invariant is established
---

# Architecture Journal

## Overview

Cross-session memory does not exist in the model. It exists in `.architecture/`. This skill makes sure the directory is read at the start of work, updated when work changes it, and handed off cleanly at the end.

**Core principle:** The model does not need to remember. It needs to be forced to read and forced to write.

## When to Use

**Always at:**
- Session start in any project that has `.architecture/`.
- The moment a structural decision is being made (interface change, dependency addition, data model change).
- The moment an invariant is being established or revised.
- The moment a shortcut is being taken (delegates to `compass:complexity-budget`).

**Skip when:**
- Project has no `.architecture/`. Print a one-time instruction recommending `bootstrap-architecture.sh`; do not silently create.
- Current task is purely tactical inside one well-understood function with no architectural implication.

## Session Start Process

1. Read `.architecture/manifest.md` (always).
2. Identify the area of the codebase the current task touches.
3. Read only the relevant subset:
   - ADRs from `decisions/` whose titles match the area (or that the current task could plausibly contradict).
   - Invariants from `invariants.md` that mention files in the touched area.
   - Conventions from `conventions.md` (load all — small file, high reuse).
   - Debt log entries from `debt-log.md` matching the touched files (per `compass:complexity-budget` integration).
   - The two most recent files in `session-handoffs/`.
   - Existing `design-notes/<path>.md` for touched files, if any (check SHA freshness per `compass:design-archeology`).
   - Existing `premise-checks/<recent>.md` if a planning cycle is in progress.
4. Print a one-paragraph summary to the user of what was loaded and what was taken from it. Do not dump the loaded content; summarize the implications for the current task.

## Mid-Session Process

The agent surfaces opportunities for journal entries as work progresses:

**When a structural decision is being made:**

Propose an ADR. Use this template:

```markdown
# ADR NNNN: <decision title>

**Status:** proposed
**Date:** YYYY-MM-DD
**Decided by:** H | A | D
**Context:** What forced this decision
**Decision:** What was decided
**Consequences:** What gets easier; what gets harder
**Alternatives considered:** Brief, with why-rejected
**Invariants this creates:** Reference to invariants.md IDs (or "none")
```

Number sequentially. Never reuse a number on supersede — use the `Status: superseded by NNNN` field on the old ADR instead.

**Decided by codes:**
- `H` — human decided the substance; agent surfaced options.
- `A` — agent proposed; human explicitly approved.
- `D` — delegated to agent without explicit human review at the time of decision.

**When an invariant is established:**

Add to `invariants.md` using the format demonstrated by existing entries (Established by / Verification / Expected / On failure). Always include a verification command — `manually check` is not a verification.

**When a shortcut is taken:**

Delegate to `compass:complexity-budget` to log a `debt-log.md` entry.

**When a structural insight surfaces but is out of current scope:**

Delegate to the `scope-deferred.md` pattern per `compass:` ADR 0009 Layer 2.

## Session End Process

Invoke `compass:session-handoff`. That skill writes the handoff file; this skill defers to it.

## Decision Authority Tracking

`Decided by` codes (H/A/D) are tracked on every ADR. At session-handoff, the ratio is reported:
- Many consecutive `A` or `D` entries are a structural signal that the human has been backseated.
- The next session should surface that ratio and ask whether the involvement setting (per `compass:` ADR 0008) needs adjustment.

This is the auditable backseating-detection mechanism.

## Bootstrap (no `.architecture/` yet)

If session start detects no `.architecture/`:

1. Print:
   > "This project has no `.architecture/` directory. Compass's memory mechanism is unavailable. To enable it: run `<plugin>/scripts/bootstrap-architecture.sh .` and commit the result. Then re-invoke this skill at next session start."

2. Continue the session without the journal. Do not silently create `.architecture/` — that's a structural decision the human should make deliberately.

## Red Flags — STOP

- About to make a structural decision without proposing an ADR.
- About to establish an invariant without a verification command.
- About to take a shortcut without logging it to debt-log via `compass:complexity-budget`.
- Reading all of `.architecture/` indiscriminately at session start (you should load only what's relevant — full loads waste context and don't help).
- Skipping the manifest read at session start (the manifest is the index; without it you don't know what to load).
- Silently creating `.architecture/` when it doesn't exist.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "This decision is too small for an ADR" | Small decisions compound. The next session won't remember the rationale. |
| "I'll write the ADR later" | Later = never. Write it when the decision is made. |
| "The code documents the decision" | Code shows what; ADRs show why. |
| "The invariant is obvious" | Obvious to you in this session. Not obvious to the next session or a new contributor. |
| "I'll load all of .architecture/ to be safe" | Wastes context. Load only what's relevant. The manifest exists to tell you what's relevant. |
| "The involvement ratio looks bad but the human said go faster" | Surface the ratio and the per-ADR 0008 mechanism for adjustment. Don't ignore the signal. |

## Bottom Line

Read at start (selectively). Write on every structural decision. Hand off at end. The journal is the project's memory; without it, every session starts from zero.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24). The journal it manages is at `.architecture/` in the Compass plugin repository — the plugin uses itself on itself.*
