# Architecture Manifest

This directory is the project's architectural memory. Claude reads it at session start; humans read it at onboarding.

## Contents

- `decisions/` — ADRs, one per file, sequentially numbered. Use the format in any existing ADR (or in `decisions/0001-example.md`).
- `invariants.md` — what must remain true. Each invariant has an ID, the ADR that established it, and a verification command.
- `conventions.md` — non-obvious idioms a newcomer would not infer from the code or skill files alone.
- `debt-log.md` — known shortcuts, where they will bite, when to revisit.
- `scope-deferred.md` — mid-build insights that are out of scope right now but might matter later (per the [Compass plugin's ADR 0009](https://github.com/itecob/socratic-compass/blob/main/.architecture/decisions/0009-scope-discipline.md)).
- `interviews/` — `compass:socratic-interview` transcripts. One per planning session. Authored by the human, hardened by the agent.
- `premise-checks/` — `compass:premise-check` reports. One per planning cycle. Parallel to interviews/.
- `design-notes/` — `compass:design-archeology` outputs, mirroring source tree at `<path>.md`.
- `session-handoffs/` — time-ordered notes written at session end by `compass:session-handoff`.
- `validation/` — adversarial subagent evaluations at phase boundaries, plus end-of-project transferability tests (per `compass:` ADR 0011).

## How to use

**Starting a session:** read this manifest, then load the relevant subset of ADRs, invariants, and conventions for the current task. Do not load everything.

**During a session:**
- Making a structural decision → propose an ADR (use the format in `decisions/0001-example.md`).
- Establishing an invariant → add to `invariants.md` with a verification command.
- Taking a shortcut → log it in `debt-log.md`.
- Mid-build insight that's out of current scope → log it in `scope-deferred.md`.

**Ending a session:** write a structured handoff to `session-handoffs/YYYY-MM-DD-HHMM.md`.

**At each phase or milestone boundary:** dispatch an adversarial subagent (per `compass:adversarial-review`) and capture its evaluation in `validation/phase-NN-YYYY-MM-DD-HHMM.md` or `validation/milestone-NAME-YYYY-MM-DD.md`.

## Top-level summary

*(Replace this paragraph with one description of the system's shape: major components, their boundaries, how data flows. Update only when the shape changes. The point of this paragraph is that a newcomer can read it and understand what they're looking at in two minutes.)*

## Quick index of ADRs