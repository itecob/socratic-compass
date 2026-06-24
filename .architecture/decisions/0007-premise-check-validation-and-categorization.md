# ADR 0007: premise-check includes validation and categorization

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Context:** premise-check as defined in ADR 0006 was a pure summarizer over the socratic-interview transcript. Two gaps remained. (a) External validation — the interview catches internal contradictions in the human's reasoning, but not contradictions against the architecture journal's recorded invariants, ADRs, and prior session work. (b) Categorization — every task got the full ceremony or none, with no mechanism to scale process weight to task novelty or blast radius.
**Decision:** Extend premise-check with two additional outputs after the three interview-derived ones. Output 4 is validation: the agent cross-references the premise against `.architecture/invariants.md`, `decisions/`, recent `session-handoffs/`, and `debt-log.md`, reporting plausibility conflicts, surface-level feasibility concerns, and prior art with citations. Output 5 is categorization: domain familiarity (novel/familiar/mixed), task type (one of seven enumerated values), and suggested process weight (light/standard/heavy). The agent's classification is grounded in journal entries; the human reviews and overrides. Overrides get their own ADRs with `Decided by: H`.
**Consequences:** Easier — premises that contradict recorded knowledge fail fast, before any code is touched; process weight scales to task novelty and blast radius; downstream skills know which steps are mandatory; deep technical feasibility still gets caught by `design-archeology` (no false confidence from premise-check). Harder — premise-check now has five outputs and reads four journal files; the categorization is a judgment call the agent must defend with citations.
**Alternatives considered:**
- Separate validation skill — rejected for v1; skill proliferation outweighs reuse value at current scope. Revisit if validation complexity grows.
- Validation in `design-archeology` — rejected; archeology validates against code reality, premise-check validates against recorded knowledge. Different concerns, different timing.
- No categorization, every task gets full ceremony — rejected; user-confirmed need to scale process to task type.
- Categorization as a separate skill — deferred; revisit if it grows beyond the three-axis classification.
**Invariants this creates:** none new directly; reinforces INV-006 (the architecture journal must be readable for premise-check to do validation).
