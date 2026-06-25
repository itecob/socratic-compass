---
name: tradeoff-matrix
description: Use during brainstorming when an approach is being defended without explicit comparison to alternatives - forces three or more designs compared on named axes before any plan is approved
---

# Tradeoff Matrix

## Overview

Two-option comparisons collapse to vibes. Three-option comparisons on named axes make the tradeoff legible enough that a reviewer can disagree on substance.

**Core principle:** If you cannot fill in the matrix, you have not explored the design space.

## When to Use

**Always during brainstorming when:**
- A single approach is being defended.
- The proposed approach has obvious one-way-door qualities (data migrations, schema changes, public API changes).
- The task touches multiple files or multiple subsystems.

**Skip when:**
- The decision is fully reversible and cheap (a local refactor inside a single function).
- The categorization output of `compass:premise-check` recommended *light* process weight AND the decision is fully reversible.

## The Matrix

| Design | Reversibility | Complexity cost | Blast radius | Time to build | Operational cost | Future flexibility |
|---|---|---|---|---|---|---|

Rules:
- At least three designs. One may be "do nothing" if that's plausible.
- Every cell has one sentence of justification, not a number alone.
- The recommendation is the last row, with the tradeoff stated.

## Axes (default set)

- **Reversibility:** can we undo this in a week? a month? not at all?
- **Complexity cost:** how much does this add to the system's surface area?
- **Blast radius:** if this is wrong, how much breaks?
- **Time to build:** rough order of magnitude.
- **Operational cost:** ongoing run/maintain cost.
- **Future flexibility:** does this make likely next steps easier or harder?

Substitute axes when the situation warrants (security, latency, vendor lock-in, regulatory). Always name them.

## Process

1. List at least three candidate designs.
2. Fill in every cell with a one-sentence justification.
3. Make a recommendation. State the tradeoff you're accepting.
4. Surface the matrix to the human before planning continues. The matrix output is part of the brainstorming session's record (saved via brainstorming's own output mechanism) — it doesn't get its own persistence directory.

## Where the output goes

The completed matrix is included in the brainstorming session's design document. It does not need a separate `.architecture/` subdirectory — its lifespan is the brainstorming-to-plan cycle. After the plan is written, the matrix lives in the plan's "Alternatives considered" section or equivalent.

## Red Flags — STOP

- Fewer than three designs.
- Cells with just numbers and no justification.
- Cells marked "same for all designs" (then it isn't a discriminating axis; remove it).
- Recommendation with no stated tradeoff.
- Recommendation chosen on a single axis (almost always wrong).
- Skipping the matrix because "the right answer is obvious" — that's exactly when this skill catches the most.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "There's really only one reasonable approach" | Then the matrix takes five minutes to confirm. Do it. |
| "The user already chose" | The user chose with less information than you have now. |
| "Axes are subjective" | The point is to make the subjectivity visible. |
| "We can iterate" | Reversibility is one of the axes. If it's high, that's your justification. |

## Bottom Line

Three designs. Named axes. Stated tradeoff. Always.

---

*This skill was authored by the Compass plugin's own first execution session (2026-06-24).*
