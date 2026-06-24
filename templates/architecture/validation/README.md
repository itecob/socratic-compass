# Validation

Adversarial subagent evaluations at phase boundaries, plus end-of-project transferability tests, per `compass:adversarial-review` and the methodology defined in your project's ADR establishing meta-validation (see the [Compass plugin's ADR 0011](https://github.com/itecob/socratic-compass/blob/main/.architecture/decisions/0011-meta-validation-methodology.md) for the reference pattern).

## Contents

- `phase-NN-YYYY-MM-DD-HHMM.md` — one file per phase or milestone boundary. Captures the subagent's evaluation and the main session's response.
- `transferability-YYYY-MM-DD.md` *(optional)* — end-of-project test where the project's discipline is applied to a problem unrelated to building the project itself. Establishes whether the methodology transfers.

## How the evaluation runs

At the end of each phase or milestone:

1. Main session collects: relevant spec/plan section, list of phase artifacts (paths + contents), relevant ADRs and invariants.
2. Dispatches a Claude subagent (`general-purpose`) with the evaluation prompt.
3. Subagent returns its evaluation. Main session writes it to `phase-NN-YYYY-MM-DD-HHMM.md`.
4. If the subagent identifies issues, main session either revises the phase or documents why the objection is acceptable in the same file.

The subagent must not inherit the main session's conversation. It evaluates artifacts-against-spec with fresh context — that is the whole point.
