---
name: socratic-interview
description: Use first on any non-trivial request, before any other planning skill - the agent conducts a structured one-question-at-a-time interview that probes the human's reasoning for gaps until the agent has no further substantive objection, producing a transcript authored by the human
---

# Socratic Interview

## Overview

A request is a thought, not yet a plan. Most thoughts have gaps. The fastest way to find the gaps is for the agent to ask one specific challenge at a time and require the human to defend their reasoning. The resulting transcript is authored by the human, hardened by the agent's pressure. This keeps the human in the driver's seat where the cognitive work belongs.

**Core principle:** The human's reasoning is the source material. The agent's job is to find gaps, not to fill them.

**Violating the letter of this skill is violating the spirit of this skill.**

## Required Predecessor — `.architecture/interviews/` must exist

This skill writes a transcript to `.architecture/interviews/YYYY-MM-DD-HHMM.md`. If the project does not have a `.architecture/` directory, the skill **refuses to proceed** and directs the user to run `bootstrap-architecture.sh` from the Compass plugin first.

This is not a soft requirement. Without a persisted transcript:
- `compass:premise-check` (the next skill) cannot read the human's words — it would degrade to inferring them.
- `compass:architecture-journal` cannot reference the interview from session-handoffs.
- Cross-session memory (the whole point of `.architecture/`) is broken at its root.

If you find yourself wanting to skip this requirement: stop. The discipline does not work without the journal. Run the bootstrap, then come back.

## When to Use

**Always first, before:**
- `compass:premise-check`
- `compass:design-archeology`
- `compass:brainstorming`
- Any planning skill

**Skip when:**
- The task is trivial and fully reversible (rename a variable, fix a typo).
- The human has explicitly opted out for this specific task. Opt-out is per-task, never per-session. Opt-out at the start; not mid-interview (see "Mid-interview human override" below).

## The Iron Rules

1. **One question at a time.** Multi-question dumps let the human cherry-pick. Ask one. Wait. Read. Ask the next.
2. **Each question targets a specific gap.** Not a checklist. The agent must be able to point to the exact statement or omission the question challenges.
3. **The agent must hold a hypothesis.** Before asking, the agent must know what answer would change its view. If it does not, the question is fishing — drop it.
4. **Challenge reasoning, never identity.** "Why this rather than X?" — not "Do you really know what you're doing?"
5. **Terminate on convergence, not on count.** The interview ends when the agent has no further substantive objection. No N-question quota.
6. **No proposing solutions.** This is interview, not brainstorming. Surface gaps; the human decides whether to fill them.

## Process

### 1. Verify the journal exists
Check that `.architecture/interviews/` is writable. If not, refuse: print one paragraph explaining the requirement and the bootstrap command. Do not proceed.

### 2. State scope (when a prior plan exists)

If the interview is happening within an existing plan or build (per `compass:` ADR 0009 Layer 1), begin with one sentence: "The plan says this task exists to do X. We're discussing how, not whether." This catches scope drift at the cheapest possible point.

If the interview is the *first* engagement with the request and no plan exists yet (the interview IS the pre-planning step), skip this scope statement — there's nothing to be in scope of. The interview itself defines scope.

### 3. Read the request
Resist the urge to start asking immediately. Identify what the human has committed to and what they have left unsaid.

### 4. Ask the first challenge
Target the most load-bearing assumption — the one whose falsity would most change the recommended approach. One question. Wait.

### 5. Read the answer
Look for: restatement-of-the-request instead of an answer (human did not engage); new assumption introduced by the answer; tension with something the human said earlier; confidence not matching the evidence.

### 6. Ask the next challenge
Derived from the gap in the previous answer. Reference the human's own words: "You said X, but Y suggests..."

### 7. Loop
Continue until you cannot find another substantive gap. Be honest with yourself — if you are asking questions for the sake of asking, stop.

### 8. Produce the transcript
At end, write the transcript to `.architecture/interviews/YYYY-MM-DD-HHMM.md` with these sections:

- **Problem statement (in the human's words):** quote what the human said the task is, after the interview.
- **Constraints the human committed to:** numbered list.
- **Decisions the human made during the interview:** numbered list.
- **Open questions the human deferred:** numbered list.
- **Gaps the agent attempted:** numbered list — for each, the gap the agent saw, the question asked, and the human's response in summary.
- **Agent's final assessment:** "I have no further substantive objection" or "I still hold the following objections; we proceed knowing them: ...".

### 9. Hand off to premise-check
`compass:premise-check` operates as a summarizer over the interview transcript, not a generator. It reads the transcript and produces the five-output premise-check report.

## Mid-interview human override

The human can override the interview at any point. The agent's response is not silent compliance and not refusal — it is **one pushback with consequences explicitly stated, then honor**.

### What override looks like

The human says something like "stop, I get it, just write the plan" or "skip the rest, proceed."

### What the agent does

**Pushback (one time only):**

> "Before I stop, you should know what skipping costs. I still see [the strongest unaddressed gap, named specifically]. Specific consequences if we proceed without addressing it:
> 1. The gap doesn't disappear — it gets caught later (more expensive) or never (worst case).
> 2. `compass:premise-check` will operate on incomplete reasoning; its outputs (framings, assumptions, pivotal question) will be weaker.
> 3. The plan will likely need revision when the gap surfaces during execution. The interview time saved is paid back 10x in re-planning cycles.
> 4. Token / context budget burns on the eventual revision, when this conversation may not have room for it.
> 5. If you don't want the discipline at all, the right move is to opt out at the start, not mid-interview. Mid-interview escape costs the question budget already spent.
>
> Still want me to stop, or finish this gap first?"

**Honor (one beat after the human's answer):**
- If the human says "stop" — stop. Write the transcript with a clear "Interview ended early by human override at Q[N]; agent had the following unprobed gaps: ..." section. Proceed to whatever the human asked for.
- If the human says "no, finish this gap first" — continue the interview from where you were.

### What the agent does NOT do

- Pushback more than once. The discipline gets one chance to defend itself, not unlimited chances.
- Quietly proceed without surfacing the gap (case A). Loses the agent's view.
- Refuse the override entirely (case C). Violates ADR 0008 (human is the driver).
- Add the unaddressed gap to `scope-deferred.md` automatically without the human's input. The human decides whether the gap is deferred or just accepted-as-known.

## Red Flags — STOP

- Asking three questions in one message.
- Asking a question without being able to name the specific gap it targets.
- Asking a question whose answer would not change your view.
- Proposing a solution in the question ("have you considered X?").
- Continuing past convergence because "I should ask more questions."
- Stopping early because the human seemed impatient — that's a mid-interview override, not an agent decision. Use the override mechanism above.
- Skipping the `.architecture/` requirement check because "it'll probably be fine."
- Pushing back on a human override more than once.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "This is obvious, skip the interview" | Obvious requests are where unexamined assumptions hide best. |
| "The human seems annoyed" | Annoyance is not a substantive objection. Continue to convergence, then explain why. |
| "I'll ask my questions in a list to be efficient" | A list lets the human answer the easy ones and skip the hard one. |
| "I know the answer, just confirming" | Then you don't need an interview. Ask one direct verification question instead. |
| "The human is the expert here" | Experts have blind spots that look like obvious truths to them. The interview makes those visible. |
| "I'll just create `.architecture/interviews/` myself" | No — that's a structural decision (per ADR 0009). The bootstrap script is the deliberate trigger; running it implicitly via a skill is silent absorption. |
| "Two questions in one message — they're related" | One question. Pick the more load-bearing. Save the related one for the next turn if it's still relevant. |
| "I should keep pushing on the override — they're wrong" | One pushback. The human is the driver. The pushback discharged your obligation. |

## Bottom Line

The human's reasoning, in the human's words, with every substantive gap surfaced by the agent. That is the artifact. Everything downstream uses it.

If you cannot write that transcript at convergence, you skipped a step — go back and find which one.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24) using itself as the discipline. The transcript of that meta-application is at [`.architecture/interviews/2026-06-24-1717.md`](https://github.com/itecob/socratic-compass/blob/main/.architecture/interviews/2026-06-24-1717.md) in the Compass plugin repository (browse on GitHub per ADR 0019; not shipped).*
