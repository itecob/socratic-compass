---
name: complexity-budget
description: Use when taking a shortcut, reviewing a diff that took a shortcut, or at session start when touching files referenced in debt-log.md - keeps accumulated debt visible so it can be paid intentionally rather than forgotten
---


## Requires `.architecture/` (per ADR 0020)

This skill consumes artifacts from `.architecture/`. If the project hasn't been set up with Compass yet, stop and redirect:

**Check:** `[ -d ".architecture" ]` returns true.

**If `.architecture/` is missing**, output verbatim and stop:

> This project doesn't have `.architecture/` set up yet — Compass needs it for this skill to do its job. Run `compass:using-compass` first to authorize setup. After that completes, your original request will resume automatically.

Then invoke `compass:using-compass` and let its first-load wizard handle the onboarding. Do not proceed with this skill until `.architecture/` exists.

If `.architecture/` exists, proceed with the rest of this skill normally.


# Complexity Budget

## Overview

Shortcuts that vanish into the diff get forgotten. A debt log that is read at the right moment makes shortcuts intentional rather than invisible.

**Core principle:** Debt that no one looks at compounds. Debt that gets surfaced at decision points gets weighed.

## Required Predecessor — `.architecture/debt-log.md` must exist

If `.architecture/` doesn't exist, refuse and direct to `bootstrap-architecture.sh`. The `debt-log.md` template ships with the bootstrap and is ready for the project's first DEBT-001.

## When to Use

**Always:**
- About to take a shortcut → log it before committing the shortcut.
- Touching a file that appears in `.architecture/debt-log.md` → load the entry first (the PreToolUse Edit/Write hook surfaces these automatically when present; without the hook, the agent self-checks).
- At session start when the planned work area overlaps logged debt (delegated by `compass:architecture-journal`).
- Periodically (e.g., monthly, or at major milestones) to review accumulated debt sorted by age, cost, and trigger condition.

## Logging a new debt entry

Append to `.architecture/debt-log.md`. Format:

```markdown
## DEBT-NNN: <one-line summary>

**Files:** `path/to/file.ts:123-145`
**Deferred:** <what was not done>
**Reason:** <why deferred>
**Will bite when:** <trigger condition>
**Cost to fix:** S | M | L | XL
**Logged:** YYYY-MM-DD
```

Rules:
- Number sequentially. Never reuse a number, even when resolved (per convention C-001).
- "Cost to fix" rubric: S = <1 hour, M = <1 day, L = <1 week, XL = larger.
- The trigger condition is mandatory. "When we have more users" is not a trigger. "When concurrent writes to this table exceed 100/sec" is. The trigger must be observable.

## Resolving a debt entry

When the shortcut is paid down, do NOT delete the entry. Add a `Resolved:` line:

```markdown
**Resolved:** YYYY-MM-DD — see <commit hash or ADR>. <One-line note on how it was fixed.>
```

This preserves the historical record. The entry is now closed but visible.

## Surfacing relevant debt

At session start, given the set of files the planned work will touch:

1. `grep -B1 -A6 'Files:.*<target-path>' .architecture/debt-log.md` for each target file.
2. For each match, print the entry to the user.
3. Ask: "Pay it now, or proceed and note the dependency?"

The Phase 5 `PreToolUse` hook (when installed) does the equivalent surface automatically for Edit/Write tool calls. The skill itself encodes the same logic for contexts without the hook.

## Periodic review

When invoked for review (no specific files in mind):

1. List all entries (open + resolved).
2. Sort by `Cost to fix` and by `Logged` date.
3. Highlight open entries older than 90 days.
4. Highlight entries whose `Will bite when` trigger has plausibly fired (the agent checks the trigger condition against current project state where possible).
5. Recommend a paydown order (smallest cost-to-fix first, weighted by trigger proximity).

## Red Flags — STOP

- Took a shortcut without logging it.
- Editing a file in `debt-log.md` without reading the entry first (the hook is one mechanism; self-check is the other; one of them must happen).
- "Cost to fix" classification is vague ("medium" without rubric).
- "Will bite when" is a platitude rather than an observable condition.
- Closing a debt entry by deleting it instead of marking Resolved.
- Skipping the periodic review for >90 days (the longer between reviews, the more compounding).

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "It's a small shortcut, not worth logging" | Small shortcuts compound. Log them. |
| "I'll remember this one" | You won't. The next session won't. The next person won't. |
| "The TODO comment in the code is enough" | Comments don't aggregate. Debt log does. |
| "We never pay down debt anyway" | Then surface that fact in a session-handoff and decide deliberately. Don't make it invisible by not logging. |
| "The trigger condition is hard to articulate" | Then the debt is unclear; clarify what the actual risk is before logging. A vague entry helps no one. |

## Bottom Line

Log it when you take it. Read it when you touch it. Review it periodically. Never delete; mark Resolved.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24). The plugin's own [debt log](https://github.com/itecob/socratic-compass/blob/main/.architecture/debt-log.md) (browsable on GitHub per ADR 0019; not shipped) has twelve entries as of the end of Phase 8, including DEBT-003 (resolved) demonstrating the close-without-delete pattern.*
