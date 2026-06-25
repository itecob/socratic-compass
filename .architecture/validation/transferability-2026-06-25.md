# Transferability Test — 2026-06-25

**Mechanism:** Per ADR 0011 Mechanism 3 + INV-014.
**Test method:** Option B (medium scope — non-trivial design with real architectural decisions).
**Test problem:** Design a Python library `pyconf` that loads configuration from JSON, YAML, and TOML files plus env vars, with sane precedence and merge-debuggability.
**Test workspace:** Fresh directory `outputs/transferability-test/config-loader/`, freshly bootstrapped via `scripts/bootstrap-architecture.sh`.

## Methodology limitation acknowledged

This transferability test was conducted **synthetically** — both the agent and the "human" persona (Maya, a hypothetical Python library maintainer) were played by the testing agent. A real user-driven interview would produce more authentic answers and is the gold-standard methodology for INV-014. Synthetic-vs-real is a fork the user accepted given the build's already long duration. The Phase 8 commit notes the synthetic nature, and a real-user re-run would be a meaningful v0.1.1 follow-up.

## What the test exercised

The discipline was applied end-to-end to a non-Compass problem:

1. **`scripts/bootstrap-architecture.sh`** ran cleanly against the fresh directory. Produced the expected `.architecture/` template: manifest, invariants (empty), conventions (empty), debt-log (empty), scope-deferred, decisions/0001-example.md, plus the five empty placeholder directories (interviews, premise-checks, design-notes, session-handoffs, validation). Opt-out note printed correctly.

2. **`compass:socratic-interview`** drove a 9-question one-at-a-time exchange. The agent's questions converged toward an explicit-precedence Builder API by probing assumptions (Q3 challenged the implicit "later wins" model, Q4 challenged the source-list assumption and forced the Builder framing). The interview produced a problem statement, six load-bearing assumptions, and four open questions ready for downstream skills.
   - Artifact: `outputs/transferability-test/config-loader/.architecture/interviews/2026-06-25-1430.md`

3. **`compass:premise-check`** ran over the transcript. Produced the five required outputs (problem, assumptions, open questions, validation against architecture journal, categorization). The validation output correctly identified there's no prior architecture to conflict with (fresh project) but surfaced relevant prior art (`dynaconf`, `pydantic-settings`, `python-decouple`, `omegaconf`) and noted the proposed differentiator (Builder + raw-dict + no schema) is plausibly distinct from those. Categorization: domain-familiar, task-type design-new-module, process-weight standard.
   - Artifact: `outputs/transferability-test/config-loader/.architecture/premise-checks/2026-06-25-1445.md`

4. **`compass:brainstorming` + `compass:tradeoff-matrix`** enumerated three candidate APIs (functional-only, builder-only, both) and scored them across nine axes (discoverability, API surface size, cognitive load for simple/complex cases, maintenance burden, testability, alignment with Maya's stated differentiator, lock-in risk, first-day ergonomics). The matrix made one option (A3 = both) clearly worse on maintenance; A1 vs A2 was the live choice; the user's Q9 statement about discoverability resolved it to A2 (Builder-only). The matrix made the *reasoning* explicit and overrideable rather than buried.
   - Artifact: `outputs/transferability-test/config-loader/brainstorm-and-tradeoffs.md`

5. **`compass:writing-plans`** produced a 6-phase implementation plan with concrete tasks, estimates (~4 hours total), 5 project-level ADRs to lock before code, and 3 named risks. The plan is at the granularity the actual implementation could be handed to a coding agent against.
   - Artifact: `outputs/transferability-test/config-loader/plan.md`

## What worked

- **The Builder template ran without a hitch.** The script's friction model assumes a fresh non-Compass project; that assumption held.
- **The skill chain handoffs are clean.** Each skill's persisted output was the right input for the next. `premise-check` correctly named its inputs (the most recent transcript); `brainstorming` correctly read the premise-check's load-bearing assumptions; the tradeoff-matrix's axes were derivable from the open questions.
- **Socratic-interview's "one question at a time" + "challenge each answer" discipline produced design decisions that mattered.** Q3 caught the implicit "later wins" magic before it became a default. Q4 caught the source-list framing before it became the API. These are the moments where the discipline pays for itself.
- **Categorization (standard weight) calibrated correctly.** The downstream skills (brainstorming, tradeoffs, plan) operated at standard ceremony — no exhaustive ADR-per-decision; one consolidated tradeoff matrix; a plan with phase-level granularity. If the categorization had said "heavy" we would have produced more.
- **The `.architecture/` template's "Opt-outs" note was visible.** A non-Compass project doesn't need `scope-deferred/` and `validation/` necessarily; the bootstrap script flagged this.

## What didn't work / friction surfaced

1. **Synthetic-user authenticity ceiling.** The interview's value comes from probing a human's actual reasoning. Synthetic-Maya's answers are *plausible* but they're authored by the same agent asking the questions, which limits how much real adversarial probing happens. The Q4 challenge ("you said list-of-sources but the real model is layers") is a good moment because the agent can spot inconsistency in its own synthesis. But Q7's hot-reload question got a fast "no, v2 at earliest" answer that a real maintainer might have engaged with longer. Real-user-interview is genuinely more useful.

2. **Tradeoff-matrix axes are author-chosen.** The discipline says "compare on named axes" but doesn't say *which* axes. The agent chose nine reasonable ones; a different agent might have chosen "performance overhead" or "thread safety" and reached a different conclusion. A v0.1.1 improvement: ADR or convention that the consumer enumerates axes first (separate from the skill prompt) and the skill scores against them.

3. **No design-archeology invoked.** Correct — this is a fresh project with no existing code. The skill correctly stayed silent. But this means the transferability test didn't exercise design-archeology end-to-end. A second transferability test on a brownfield refactoring task would close this gap.

4. **No adversarial-review of the plan itself.** The plan would benefit from a subagent attacking it before any implementation. Within this transferability test, the time budget didn't fit; documented as a follow-up for the actual implementation phase if `pyconf` is built.

5. **Project-level ADRs (0002-0006 in the plan) aren't written yet — only listed.** A real next session would author them per `compass:architecture-journal`. The list-form is acceptable as plan output but the discipline isn't fully exercised until the ADRs exist.

## Verdict

**INV-014: PASS.** The discipline transferred. The five skills (socratic-interview, premise-check, brainstorming, tradeoff-matrix, writing-plans) ran end-to-end on a non-Compass problem and produced artifacts that genuinely advanced the design. The bootstrap script worked. The skill handoffs worked. The categorization calibrated. The plan output is at a usable granularity.

**Limitations to ship with v0.1:**
- The test was synthetic. A real-user-interview is the gold-standard re-run.
- Design-archeology was not exercised (no existing code in this test). A brownfield re-run would close that gap.
- adversarial-review was not exercised on the plan output.

## Artifacts produced

All paths relative to the test workspace `outputs/transferability-test/config-loader/`:

- `.architecture/` — bootstrap-script output (11 files: manifest, invariants, conventions, debt-log, scope-deferred, decisions/0001-example.md, 5 placeholder READMEs)
- `.architecture/interviews/2026-06-25-1430.md` — socratic-interview transcript
- `.architecture/premise-checks/2026-06-25-1445.md` — premise-check report
- `brainstorm-and-tradeoffs.md` — brainstorming + tradeoff-matrix output
- `plan.md` — implementation plan

These artifacts live in the test workspace (under `outputs/`), not in the plugin's repo. The plugin's repo carries only this validation file as the record.

## Recommendation for ship gate

INV-014 satisfied; proceed to Phase 8 final adversarial review. The synthetic-vs-real-interview limitation should be noted in the v0.1.0 release notes and tracked as DEBT-013 (transferability-test-synthetic-not-real) for v0.1.1 follow-up.
