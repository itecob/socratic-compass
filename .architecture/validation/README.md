# Validation

Adversarial subagent evaluations of the Compass plugin build, per ADR 0011.

## Contents

- `phase-NN-YYYY-MM-DD-HHMM.md` — one file per phase boundary. Captures the subagent's prompt, evaluation output, and how the main session responded.
- `transferability-YYYY-MM-DD.md` — end-of-build test where Compass is applied to a problem unrelated to building Compass.

## How the evaluation runs

At the end of each phase:
1. Main session collects: relevant spec section, list of phase artifacts (paths + contents), relevant ADRs/invariants.
2. Dispatches a Claude subagent (`general-purpose`) with the evaluation prompt template.
3. Subagent returns its evaluation. Main session writes it to `phase-NN-YYYY-MM-DD-HHMM.md`.
4. If the subagent identifies issues, main session either revises the phase or documents why the objection is acceptable in the same file.

The subagent must not inherit the main session's conversation. It evaluates artifact-against-spec with fresh context.

## Snapshot for INV-013

`specs/2026-06-24-compass-design.md.criteria-snapshot` is created at the start of the build to lock in §11's success criteria. Any change to §11 must produce a supersede ADR.
