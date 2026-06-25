---
name: premise-check
description: Use after compass:socratic-interview has produced a transcript
---

# Premise Check

## Overview

Premise-check does three things, in this order: (1) summarizes the socratic-interview transcript into the framings/assumptions/pivotal question downstream skills consume; (2) validates the premise against the architecture journal (invariants, prior ADRs, session-handoffs, debt-log); (3) categorizes the task so downstream skills know which mandatory steps to invoke.

**Core principle:** The interview produced the reasoning. Premise-check organizes it, checks it against recorded knowledge, and labels it.

**Violating the letter of this skill is violating the spirit of this skill.**

## Required Predecessor — interview transcript must exist

`compass:socratic-interview` must have produced a transcript in `.architecture/interviews/`. If no transcript exists, refuse to proceed and direct to `compass:socratic-interview` first. Premise-check is a summarizer, not a generator — it cannot operate without the source material.

## When to Use

**Always after:**
- `compass:socratic-interview` (mandatory predecessor)

**Always before:**
- `compass:design-archeology`
- `compass:brainstorming`
- Any planning skill

## The Iron Law

```
NO PLAN WITHOUT INTERVIEW TRANSCRIPT + PREMISE-CHECK SUMMARY + VALIDATION + CATEGORIZATION + PERSISTED REPORT
```

All five outputs below, presented to the human, then written to disk. Always. Before any plan.

## The Five Outputs

### 1. Two Alternative Framings (from the interview)

Quote (or closely paraphrase) two distinct framings the human articulated during the interview. If the interview did not produce two distinct framings, the interview was incomplete — return to `compass:socratic-interview` and probe further.

### 2. Load-Bearing Assumptions (from the interview)

List the assumptions the human committed to during the interview, drawn from their answers to the agent's challenge questions. These are not the agent's guesses — they are the human's stated positions.

### 3. One Pivotal Question (from the interview)

The highest-leverage open question the human deferred during the interview. From the transcript's "Open questions" section. If everything was resolved, state that explicitly.

### 4. Premise Validation (agent cross-references the architecture journal)

The agent reads `.architecture/invariants.md`, `.architecture/decisions/` (recent ADRs), `.architecture/session-handoffs/` (recent), and `.architecture/debt-log.md`, then reports three findings with citations:

- **Plausibility:** does the premise contradict any documented invariant or past decision? Cite specific INV-IDs and ADR numbers. If none found, say "none found."
- **Surface-level feasibility:** does the premise ask for something known to be technically impossible or known-to-fail in this codebase? Cite the source. *Scope:* this is the surface check only. Deep technical feasibility (does the code actually support this) comes from `compass:design-archeology` later. Even deeper, plan-writing surfaces what only becomes visible when you try to break the work down. Premise-check catches what is already recorded as known.
- **Prior-art check:** has something similar been attempted? Cite ADRs or session-handoffs. If a similar attempt was reverted, surface the reversion reason — that history is the most valuable input to the current decision.

If the validation surfaces conflicts, present them and wait. The human chooses: revise the premise, override the invariant (which creates a new ADR with `Decided by: H`), or proceed knowing the conflict (which gets documented in the resulting plan and in the persisted premise-check report).

### 5. Premise Categorization (agent classifies the task)

The agent classifies the task on three axes:

- **Domain familiarity:**
  - *novel* — no related ADRs, no patterns in `conventions.md`, no prior work in `session-handoffs/`.
  - *familiar* — clear prior art in the journal.
  - *mixed* — some elements known, some new.
- **Task type:** one of `feature | bug fix | refactor | infrastructure | migration | exploration | other`. This determines which downstream skills are mandatory.
- **Suggested process weight:**
  - *light* — trivial, locally reversible. May skip `compass:tradeoff-matrix` for fully-reversible decisions. Skips `compass:adversarial-review` if the task touches only one file and is fully reversible.
  - *standard* — most tasks. Full pre-planning sequence.
  - *heavy* — novel domain, irreversible decisions, multi-subsystem changes. Invokes `compass:adversarial-review` at every plan iteration, not just at end. Invokes `compass:design-archeology` even when familiar code would normally not warrant it.

The agent *suggests* the weight; the human confirms or overrides. The override gets an ADR with `Decided by: H` and a brief rationale.

Note: the user's involvement preference (per `compass:` ADR 0008) can also affect interpretation. A "heavy" suggested weight under a "hands-off" involvement setting still means heavy ceremony, but the human won't be asked to review every iteration — the agent runs the ceremony and reports.

## Persistence — write the report (per ADR 0014)

After presenting all five outputs to the human and capturing their confirmation/corrections/overrides, write the report to `.architecture/premise-checks/YYYY-MM-DD-HHMM.md` using this structure:

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
**Plausibility:** ...
**Surface feasibility:** ...
**Prior art:** ...

## 5. Categorization
**Domain familiarity:** ...
**Task type:** ...
**Suggested process weight:** ...

## Human's response
<confirmation, corrections, overrides — recorded so the rest of the build can reference what the human actually agreed to>
```

If `.architecture/premise-checks/` does not exist, refuse to proceed and direct to `bootstrap-architecture.sh` (same discipline as `compass:socratic-interview`).

## Process

1. Verify `.architecture/interviews/` has a recent transcript and `.architecture/premise-checks/` is writable. If either fails, refuse.
2. Read the most recent `.architecture/interviews/YYYY-MM-DD-HHMM.md` transcript.
3. Extract outputs 1–3 from the human's words in the transcript.
4. Read the architecture journal files (invariants, decisions, recent handoffs, debt-log).
5. Produce output 4 (validation) with citations.
6. Produce output 5 (categorization) with reasoning grounded in journal entries.
7. Present all five outputs to the human for confirmation.
8. Wait for confirmation, correction, or override.
9. Write the report to `.architecture/premise-checks/YYYY-MM-DD-HHMM.md` per the format above.
10. Hand off to `compass:design-archeology` and `compass:brainstorming`.

## Red Flags - STOP

- About to invoke any downstream planning skill without all five outputs.
- About to invoke premise-check without reading the most recent transcript AND the architecture journal.
- The two alternative framings are the agent's inferences rather than the human's words.
- The load-bearing assumptions include items the human did not actually commit to during the interview.
- The pivotal question is one the agent thought of, not one the human deferred.
- The validation reports "no conflicts" without showing which files the agent read.
- The categorization is asserted without grounding in specific journal entries.
- Suggesting process weight = light on a task that touches multiple files or any one-way door.
- Skipping the persistence step ("I'll just present in chat and not save"). Without the persisted report, INV-019 fails and downstream skills lose the reference.
- Thinking "the request is clear enough to skip the interview" — that decision belongs to the human, not the agent.

**All of these mean: STOP. Produce real outputs. Persist them.**

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The request is unambiguous" | Unambiguous requests still rest on assumptions. Surface them. |
| "I'll just ask one quick question" | Question without framing means you're already biased by the request. |
| "Premise check slows things down" | Solving the wrong problem is the slowest thing you can do. |
| "The user clearly knows what they want" | They know what they think will help. That's not the same. |
| "The validation is taking too long" | Reading four short files is faster than discovering the conflict mid-implementation. |
| "Categorization is subjective" | Suggest a weight with grounded reasoning. The human overrides if needed. The override itself is informative. |
| "I'll save the report later" | "Later" doesn't happen. The session ends; the next session has no report. Save now or the discipline is broken. |
| "The premise-check happened in chat, that's enough" | Chat is ephemeral. Downstream skills look at `.architecture/premise-checks/`. No file, no signal. |

## Bottom Line

Five outputs. Always. Interview-derived (1–3), journal-cross-referenced (4), task-labeled (5). Presented, confirmed, persisted. No exceptions.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24) using itself as the discipline. The first premise-check it ran against itself is back-filled at [`.architecture/premise-checks/2026-06-24-1731.md`](https://github.com/itecob/socratic-compass/blob/main/.architecture/premise-checks/2026-06-24-1731.md) in the Compass plugin repository (browse on GitHub per ADR 0019; not shipped).*
