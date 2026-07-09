---
name: stage-code
description: Use when implementing a task from a published PLAN.md — the Code build stage (per-task FIAO implementation, Discovered Function Protocol, mandatory Plan Sync)
---

# Stage: Code

Pilot skill — ported from the 18-stage Build Process's "Code" stage (`CLAUDE-DEV.md`). Loads on demand instead of riding along with every build-mode prompt.

## Scope

Implement the current task's FIAO block(s) exactly as specified in `PLAN.md` / `PLAN_STATE.md`. This stage does **not** include: writing the plan (`compass:writing-plans`), red-teaming the implementation (`compass:adversarial-review`), or running the test suites (`compass:test-driven-development`) — those are separate stages/skills.

**Done when:** all tasks in scope are complete AND Plan Sync has been run after every completed task.

## Before starting a task

Read the task's block in `PLAN.md`:

```
Task:              T<n> — <name>
Depends on:        T<n-1> outputs: <exact files or named objects that must exist>
Files to create:   <exact list | none>
Files to modify:   <exact list | none>
MUST NOT modify:   <explicit list>
MUST NOT create:   any file not in "Files to create" above
Functions:         [FIAO block for each new or modified function]
Exit condition:    <one shell command that exits 0 iff this task is done correctly>
Spec compliance:   <3-5 things a reviewer confirms by reading the code>
```

Do not touch files outside `Files to create` / `Files to modify`. Do not implement a function whose FIAO block doesn't exist yet — see Discovered Function Protocol below.

## Discovered Function Protocol

When implementation requires a function not in the plan:

1. Stop at the function boundary — do not write the function body yet
2. Write the full FIAO block using what the implementation context revealed
3. Add the FIAO to `PLAN_STATE.md` under `## Discovered Functions`
4. Update `fiao_updated` in the Plan State Header
5. Write the function body

Implementing a function before writing its FIAO is a plan violation.

## Soft language ban

Never use these words in a FIAO Action line: `appropriately`, `as needed`, `handle`, `manage`, `process`, `validate`, `etc.`, `standard approach`, `reasonable`, `similar`, `relevant`, `necessary`, `latest`, `active`, `current`, `default`, `and so on`, `typical`, `normal`, `usually`, `generally`. Extend with domain-specific ambiguous terms as needed.

## Plan Sync — mandatory at end of every task, before starting T\<n+1\>

Compare what was built against every FIAO in this task. For any deviation, append to `## Deviations` in `PLAN_STATE.md`:

```
Deviation: T<n> — <function name>
Original FIAO Action:      <exact original text>
Actual implementation:     <what was built>
Reason:                    <why the spec was wrong or a different approach was needed>
FIAO updated:              yes | no
If no:                     <reason and blast radius of leaving FIAO stale>
Downstream tasks affected: [T<x>, T<y>] | none
Downstream specs updated:  yes | no | n/a
```

Whether or not there was a deviation, update the full FIAO in `PLAN_STATE.md` `## Current FIAO Overrides` AND log the deviation entry if one exists — not one or the other.

Update the Plan State Header, then append to `## Changelog` in `PLAN_STATE.md`:

```
- <ISO timestamp> T<n> complete. Deviations: <count>. FIAO updated: [list]. Author: <agent>.
```

## Model routing for this stage

Per `CLAUDE.md` → Model Default: this stage runs on **Sonnet 5** by default. If a task is mechanical (1-2 files, tight spec, no design judgment), it is a candidate for dispatch to a **Haiku 4.5** sub-agent rather than the main session — but only when the isolation is worth the sub-agent dispatch cost (see `compass:subagent-driven-development` → Model Selection). Do not escalate to Opus for this stage; Opus is reserved for novel-domain planning and adversarial sweeps.

## Next stage

After all tasks in scope are complete and Plan Sync has been run for each: proceed to `compass:adversarial-review` (RT(impl) → Harden loop) before Verify.
