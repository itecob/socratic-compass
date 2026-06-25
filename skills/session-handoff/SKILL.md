---
name: session-handoff
description: Use before ending any session that modified code or made structural decisions - writes a structured handoff note that the next session reads at start, including the H/A/D involvement ratio for ADR 0008 backseating detection
---

# Session Handoff

## Overview

The next session has no memory of this one. A structured handoff is the only mechanism that survives the gap.

**Core principle:** Capture structural state changes, not work-done summaries.

## Required Predecessor — `.architecture/session-handoffs/` must exist

The handoff is written to `.architecture/session-handoffs/YYYY-MM-DD-HHMM.md`. If `.architecture/` doesn't exist, refuse and direct to `bootstrap-architecture.sh`.

## When to Use

**Always before ending a session that:**
- Modified code.
- Made a structural decision (any new or revised ADR).
- Established or removed an invariant.
- Logged debt.
- Ran an adversarial-review (validation files were created).
- Wrote any premise-check or design-notes.

**Skip when:**
- Session was purely conversational (no file changes, no journal entries).
- Project has no `.architecture/`.

## The Handoff Note

Save to `.architecture/session-handoffs/YYYY-MM-DD-HHMM.md`. Format:

```markdown
# Session Handoff — YYYY-MM-DD HH:MM

## What changed structurally

<List of structural changes: new files, deleted files, interface changes,
moved responsibilities. NOT a list of every file touched.>

## What is now true that wasn't

<Invariants added, conventions adopted, dependencies introduced.
Cross-reference ADR IDs and INV IDs.>

## Involvement ratio (per ADR 0008)

This session produced N ADRs with the following Decided-by distribution:
- H: <count> (human decided the substance)
- A: <count> (agent proposed, human approved)
- D: <count> (delegated to agent without explicit review)

<If many A or D in a row across recent sessions, flag for the next session: "Backseating signal — consider revisiting the involvement setting per ADR 0008.">

## Journal artifacts produced this session

- Premise-checks: <list of files in .architecture/premise-checks/ with one-line description>
- Design-notes: <list of files in .architecture/design-notes/ with one-line description>
- Interviews: <list of files in .architecture/interviews/ with one-line description>
- Validations: <list of files in .architecture/validation/ with one-line description>
- ADRs: <list of new ADRs in .architecture/decisions/ with one-line description>

## What is half-finished

<If anything is incomplete: what's left, in what state, what blocks it.
Include open scope-deferred entries that should be revisited.>

## What the next session needs to know

<Anything that would surprise a fresh session reading the code:
non-obvious assumptions, gotchas, "if you touch X, also touch Y".>

## Open questions

<Decisions deferred to a later session. What we don't know yet.>
```

## Process

1. Verify `.architecture/session-handoffs/` is writable. If not, refuse.
2. Diff against session start. Use `git status` and `git log` since the session's first commit (or use the previous handoff's timestamp as the baseline if no commits yet).
3. Identify *structural* changes — not every line touched, only the ones that change the shape of the system.
4. Count the H/A/D codes from any new ADRs produced this session. Compute the ratio.
5. List the journal artifacts created or modified.
6. Write the note. One sentence per bullet, no padding.
7. Save to `.architecture/session-handoffs/YYYY-MM-DD-HHMM.md`.
8. If the diff includes a new ADR or invariant, ensure it's cross-referenced from the handoff.
9. Commit the handoff with a clear message.

## Backseating detection

The H/A/D ratio is the structural mechanism for detecting whether the involvement setting (ADR 0008) is being respected.

If across the last 3+ session-handoffs, the ratio is dominated by A or D entries (e.g., 80%+ A/D), the agent has been driving more than the involvement setting intended. The next session should:

1. Print the ratio at session start (via `compass:architecture-journal`).
2. Ask the human: "Recent ADR decisions are <X%> agent-driven. The current involvement setting is <Y>. Adjust?"
3. Either revise the setting (with an addendum to ADR 0008) or accept the current pattern (which itself is recorded).

This is how ADR 0008's mutability becomes operationally visible.

## Red Flags — STOP

- About to end a session with code changes but no handoff.
- Handoff that's a chronological log of what you did instead of a structural diff.
- Handoff that omits half-finished work.
- Handoff longer than 500 words for a typical session (you're not summarizing; you're transcribing).
- Omitting the H/A/D ratio when ADRs were produced.
- Skipping the journal-artifacts-produced section (the next session uses this to know what to load).

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The git log is the handoff" | Git log shows commits, not structural meaning. |
| "I'll write it next session when I remember" | You won't remember. That's the problem. |
| "The session was small" | Small sessions accumulate. No handoff = invisible drift. |
| "The user can ask if they need to know" | The next session reads the handoff before the user asks. |
| "The ratio doesn't matter for this project" | Then say so explicitly in the handoff. Don't omit it. |

## Bottom Line

Structural diff, not narrative log. Every session that changed code. Include the ratio.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24).*
