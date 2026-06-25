---
name: invariant-scan
description: Use on demand before a release, after a significant refactor, or when debugging a regression - sweeps the codebase to verify documented invariants in .architecture/invariants.md still hold by running each invariant's verification command; can also be scheduled via mcp__scheduled-tasks
---

# Invariant Scan

## Overview

Invariants drift silently. The only way to catch the drift is to run their verification commands periodically.

**Core principle:** Documented invariants are only as good as the most recent verification.

## Required Predecessor — `.architecture/invariants.md` must exist with verifiable entries

If `.architecture/invariants.md` is missing or empty, refuse and direct to `bootstrap-architecture.sh` (to create the template) and then to writing the project's first INV-001.

## When to Use

**On demand:**
- Before any release or tag.
- After a significant refactor that may have invalidated invariants.
- When debugging a regression (an invariant violation may be the cause).
- At any phase boundary in a multi-phase build (in addition to the adversarial-review at that boundary).

**Scheduled:**
- Daily or weekly via `mcp__scheduled-tasks__create_scheduled_task` in Cowork.
- Via CI on every PR in Claude Code projects.

Either mode produces the same output format; the difference is who triggers it.

## Process

1. Read `.architecture/invariants.md`.
2. For each entry with ID `INV-NNN`:
   a. Read the `Verification:` field (an exact shell command, per convention C-004).
   b. Read the `Expected:` field.
   c. Run the command.
   d. Compare output to expected.
   e. Classify: HOLDS, DRIFTED, or BROKEN_VERIFICATION.
3. Produce a report (format below).
4. If any DRIFTED, propose a session to investigate. Do not silently auto-fix drift.
5. If any BROKEN_VERIFICATION (the command itself errored or returned unparseable output), surface that separately — the verification command is itself a bug to fix.

## Report format

```markdown
# Invariant Scan — YYYY-MM-DD HH:MM

| ID | Status | Notes |
|---|---|---|
| INV-001 | HOLDS | — |
| INV-007 | DRIFTED | <one line: what's wrong, which ADR to revisit> |
| INV-012 | BROKEN_VERIFICATION | <verification command failed to run: error> |

**Action items:**
- <For each DRIFTED: which file, which ADR, suggested next step>
- <For each BROKEN_VERIFICATION: fix the verification command>

**Summary:** N HOLDS, M DRIFTED, K BROKEN_VERIFICATION (total <total>).
```

When run via scheduled-tasks, the report can be sent to the user via the scheduled task's output mechanism (chat message, email, etc., per the scheduled-tasks tool's options).

When run on demand, the report is presented in chat.

## Manual vs automated verifications

Per convention C-004, every invariant should have an exact shell command in its Verification field — not "manually check." But some invariants are genuinely not automatable (e.g., "every absorbed skill carries an attribution footer that reads as a human-meaningful citation"). For those:

1. Mark `Verification: manual` in the invariants.md entry.
2. The scan skips these and reports them as `Status: MANUAL` with a count.
3. Periodic manual review is the human's job; the scan tracks how long since last manual verification (via a "Last verified: YYYY-MM-DD" addendum the human writes after manually verifying).

## Red Flags — STOP

- About to claim all invariants hold without showing the commands ran.
- Skipping an invariant because the verification command "looks fine."
- Auto-fixing drifted invariants instead of investigating.
- Treating BROKEN_VERIFICATION the same as DRIFTED (they're different problems — one is the code drifting from the invariant, the other is the verification command being buggy).
- Suppressing the report when everything HOLDS (the all-clear is a real signal worth recording).

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The tests would catch invariant violations" | Tests cover what someone thought to test. Invariants cover what must always be true. |
| "I just touched that area, it's fine" | The drift might predate your change. |
| "The invariant is too generic to verify" | Then it isn't a real invariant. Either refine it or remove it. |
| "Running all the verifications is slow" | Then the verifications are slow; fix them or run a subset. The discipline is to run something. |

## Bottom Line

Run the commands. Read the output. Report the drift. Investigate, don't auto-fix.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24).*
