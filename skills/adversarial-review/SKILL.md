---
name: adversarial-review
description: Use after a plan is drafted but before execution begins, or at the end of each phase in a multi-phase build
---

# Adversarial Review

## Overview

The model that proposed a plan tends to defend it. Separating the attacker from the proposer surfaces objections that self-review misses. Adversarial review is the mechanism that makes meta-validation non-circular.

**Core principle:** Plans deserve a hostile reader before they deserve an implementer.

**REQUIRED SUB-SKILL:** Use `compass:dispatching-parallel-agents` to dispatch the reviewer subagent.

## Required Capabilities

This skill requires a subagent dispatch capability:
- **Claude Code:** `Task` tool with `general-purpose` agent type.
- **Cowork:** `Agent` tool with `general-purpose` subagent_type.
- **Plain chat (no IDE, no subagent capability):** **refuse and direct to a context that supports subagents.** A self-review-pretending-to-be-adversarial defeats the entire purpose; do not attempt the fallback.

## Required Predecessor — `.architecture/validation/` must exist

The evaluation result is written to `.architecture/validation/phase-NN-YYYY-MM-DD-HHMM.md` (for phase boundaries) or `.architecture/validation/milestone-NAME-YYYY-MM-DD.md` (for ad-hoc milestones). If `.architecture/` doesn't exist, refuse and direct to `bootstrap-architecture.sh`.

## When to Use

**Always:**
- At the end of each phase in a multi-phase plan (per ADR 0011 Mechanism 2).
- Before executing a plan with one-way-door qualities (irreversible migrations, schema changes, public API changes).
- Before any release or ship action (the end-of-build transferability test is a special case; see `compass:` ADR 0011 for the discipline).

**Especially when:**
- The plan involves a one-way door.
- The plan touches multiple subsystems.
- The plan is being executed by subagents (errors compound).
- The categorization output of `compass:premise-check` was *heavy* — heavy weight means adversarial review at every plan iteration, not just at end.

**Skip when:**
- The task was *light* per premise-check categorization AND touches only one file AND is fully reversible.

## The Process

1. **Identify the artifact under review.** Most commonly the artifacts produced by the just-completed phase. Could also be a specific plan, a single skill, a specific design choice.
2. **Package the inputs the reviewer needs:**
   - The relevant spec/plan section(s).
   - The artifacts (paths + contents, or paths and let the reviewer read).
   - Relevant `.architecture/` ADRs and invariants that apply.
   - The names and one-line summaries of any rejected alternatives (from tradeoff-matrix).
3. **Dispatch a Claude subagent** (`general-purpose` agent type) with the prompt template (below).
4. **Receive the evaluation.** Read it carefully.
5. **Save to `.architecture/validation/phase-NN-YYYY-MM-DD-HHMM.md`** with the evaluation verbatim plus a "Main session's response" section documenting how each concern was addressed (fixed now, deferred, logged as DEBT, written into a new ADR).
6. **Either revise the artifact or document the override.** If the reviewer's objection is acceptable as-known, that's a deliberate choice that goes into the resulting artifact (plan, ADR, etc.) and the validation file.

## Subagent prompt template

```
You are an adversarial reviewer for [PROJECT NAME]. Your job is to evaluate whether [ARTIFACT] is correct. Do not assume the build was done well — look for what's missing, what's wrong, what's stretched, and what's actually right. Be direct.

## Context

[2-3 sentences describing the project and what the artifact is]

## Your inputs

Read these files first:
1. [Spec section]
2. [Plan section]
3. [Relevant ADRs]
4. [Relevant invariants]

Then look at the artifacts produced:
- [List of files with brief descriptions]

## Evaluation prompt

Produce a written evaluation with these sections:
### 1. What's missing
### 2. What's wrong
### 3. What's stretched
### 4. What's actually right
### 5. Verdict (Pass | Pass with concerns | Fail)
### 6. Recommendations

## Constraints

- Be technical, not stylistic. Don't critique tone or word choice; critique correctness.
- Reference specific files and line numbers where applicable.
- If you cannot answer something definitively, say so explicitly rather than guessing.
- Do not be sycophantic. If the artifact is solid, say so without padding. If it has problems, surface them clearly.

Return your evaluation in plain Markdown.
```

The subagent **must not** inherit the main session's conversation context. The whole point is fresh-context evaluation. Construct the prompt with all needed information embedded; do not rely on shared state.

## What the main session does with the result

**Pass:** proceed to the next phase. Save the validation file with the subagent's verdict + a brief "main session's response" noting no action required.

**Pass with concerns:** address each concern in one of four ways:
- *Fix now* — quick correction before the commit.
- *Log as DEBT* — known limitation, deferred with cost-to-fix estimate.
- *Write an ADR* — substantive design decision the concern surfaced.
- *Document as known and accept* — concern is real but the tradeoff is acceptable; record in the validation file's "Main session's response."

Then commit.

**Fail:** do not proceed to the next phase. Revise the artifact, then re-run adversarial-review. Do not paper over a Fail verdict.

## Sycophancy check

Adversarial reviewers can soft-pedal. If the evaluation is uniformly positive or the concerns are stylistic, re-dispatch with the prompt re-emphasizing: "Be technical, not stylistic. Do not be sycophantic." A real adversarial review will find something — even excellent work has tradeoffs to surface.

## Red Flags — STOP

- About to proceed past a phase boundary without dispatching adversarial-review.
- Reviewing your own work in the same context (defeats the purpose).
- Subagent returns "Pass" with no specific findings (sycophancy — re-dispatch).
- Skipping the persistence step ("I'll just read the evaluation in chat"). Without the file, INV-012 fails and there's no audit trail.
- Treating a "Fail" as "Pass with concerns" because revising would be inconvenient.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The plan is small" | Small plans hide their failure modes better. |
| "I already self-reviewed" | The proposer cannot be the adversary. |
| "We'll find issues in code review" | Code review is too late; the design is locked. |
| "The reviewer will just nitpick" | Constrain the prompt to technical objections only; sycophantic findings get re-dispatched. |
| "I don't have subagent access right now" | Then run this skill from a context that has subagents. Do not fake it. |

## Bottom Line

No phase advances without a real attack on it first. Subagent dispatch, fresh context, technical findings, persisted to validation/, response documented.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24). The mechanism is established by ADR 0011. The first two times it was applied — to Phase 1 and Phase 2 of the Compass build itself — are at `.architecture/validation/phase-01-2026-06-24-1836.md` and `.architecture/validation/phase-02-2026-06-24-2014.md` in the Compass plugin repository.*
