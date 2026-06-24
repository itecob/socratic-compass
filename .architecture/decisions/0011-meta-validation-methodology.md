# ADR 0011: Meta-validation methodology — anchor to spec, dispatch adversarial subagent per phase, transferability test at end

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The Compass plugin is being built using Compass's own discipline (per Framing B of the first interview). This is a meta-validation — if the methodology produces a good outcome, that's evidence the methodology works. But it's circular: the same context that drove the build is the context evaluating the build. The user explicitly asked whether the meta-validation can be made non-circular ("validate that it's actually correct without using the existing context to poison the scope or perspective of the results").

The risk of skipping this: we ship a methodology that *feels* validated but only because we built it to validate itself. That's exactly what the discipline was supposed to prevent.

**Decision:** Three mechanisms applied together. No single mechanism is sufficient; the combination is the validation.

**Mechanism 1 — Anchor to pre-set criteria.**
The seven success criteria in spec §11 were written during planning, before this build. They are the contract. At each phase boundary and at the end, evaluation references those criteria literally, without revision. If we discover during the build that a criterion is wrong, we write a new ADR explaining why and either supersede §11's criterion or document the deviation — never silently move the goalposts.

**Mechanism 2 — Adversarial subagent at each phase boundary.**
At the end of each phase, dispatch a Claude subagent (`general-purpose` agent type) with only:
1. The relevant section of `specs/2026-06-24-compass-design.md`.
2. The list of artifacts produced in the phase (paths and contents).
3. The relevant subset of `.architecture/` ADRs and invariants.
4. An evaluation prompt requiring the subagent to identify what's missing, what's wrong, what's stretched, and what's actually right — *not* assume the build was done correctly.

The subagent has no access to the main session's conversation. It evaluates published artifact against published spec. Its output is captured to `.architecture/validation/phase-NN-YYYY-MM-DD-HHMM.md` and the main session either revises the phase or documents why the objection is acceptable.

**Mechanism 3 — Transferability test at end.**
When the plugin is built, run Compass against a problem unrelated to building Compass — a real decision the user is facing, a sample codebase, anything not Compass-shaped. If `socratic-interview` reveals real gaps in the new problem, if `premise-check` validation surfaces a real conflict against a real journal, if `adversarial-review` finds a real objection — the methodology transferred. If Compass falls apart on a new problem, the meta-validation was sycophantic and we revise before shipping.

The transferability test is the only mechanism that fully breaks the build-it-to-like-itself loop. Mechanisms 1 and 2 reduce circularity; Mechanism 3 eliminates it.

**Consequences:** Easier — meta-validation is no longer a feeling; it's three observable checks. Phase boundaries have explicit gates. Shipping is conditional on passing the transferability test, which raises the bar in a way the user wants.

Harder — every phase boundary now includes a subagent dispatch (small cost) and a response cycle (variable cost). The transferability test requires identifying a separate problem to test on (one-time cost). Total added: probably 1–2 hours across the build, plus whatever revisions the adversarial evaluations surface.

**Alternatives considered:**
- *Trust the per-skill interview as sufficient validation.* Rejected: per-skill interviews evaluate "is this skill well-designed" not "does Compass as a system work." Different question.
- *Single end-of-build adversarial review.* Rejected: defers all signal to the end; if Phase 1 is fundamentally wrong, we don't learn until Phase 8. Per-phase catches drift early.
- *Skip the transferability test.* Rejected: would leave the circular validation problem unresolved. The user explicitly asked for this; declining without justification would be sycophantic.

**Invariants this creates:**
- INV-012: Every phase boundary produces an adversarial subagent evaluation captured in `.architecture/validation/`.
- INV-013: The build's success criteria are spec §11's seven criteria, unrevised. Any revision requires a supersede ADR.
- INV-014: Before declaring the plugin ready to ship, the transferability test is run on a non-Compass problem and the result is captured in `.architecture/validation/transferability-YYYY-MM-DD.md`.

**Initial setup:** The first phase boundary evaluation happens at end of Phase 1 (scaffolding). It's a small phase (4 tasks), which makes it a good first run of the mechanism — if subagent dispatch works as expected for Phase 1, we have confidence in the mechanism for the larger phases that follow.

**Downstream applicability:** ADR 0013 extends this mechanism into the default `templates/architecture/` shipped by the Compass plugin's `scripts/bootstrap-architecture.sh`. Downstream projects using Compass receive a `validation/` directory with an instructional README as a default; they may delete it if they do not want the mechanism. The mechanism requires Claude (or a comparable LLM subagent capability) to be available, which is always true for projects using Compass at all. See ADR 0013 for the rationale and opt-out.
