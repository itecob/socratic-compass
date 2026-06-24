# ADR 0009: Three-layer scope discipline for mid-build insights

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The Compass build will run as a sequence of per-skill mini-interviews (per ADR 0008's hybrid setting). Each mini-interview is an opportunity for scope creep: "wait, should we change the spec?", "what about a tenth skill?", "this makes me rethink the structure." Following every drift kills the project; killing every drift loses real insight. Neither default is correct.

The mechanism must (a) recognize drift in real time, (b) capture insights so they're not lost, and (c) route them to the right decision-making process — either a deliberate plan revision or a deferred-for-later list.

**Decision:** Three layers, applied in order:

**Layer 1 — Per-skill scope statement (start-of-conversation gate).**
Each per-skill mini-interview opens with one sentence:
> "The plan says this skill exists to do X. We're discussing *how*, not *whether*."
Anything that crosses into "whether" is named as such immediately, by either party. This is the cheap gate that catches most drift.

**Layer 2 — `.architecture/scope-deferred.md` (capture without action).**
When a real insight surfaces that's genuinely out of scope for the current skill but might matter later, append a one-line entry to `scope-deferred.md` with: date, source (which skill we were on), the insight in one sentence, and the suggested resolution category (revise spec / new ADR / discard / revisit at phase boundary). The conversation continues without acting on the insight. The file is reviewed at each phase boundary as candidate ADR material.

**Layer 3 — Hard escalation rule (structural changes only).**
If a mid-skill question would change the plan *structurally* — add or remove a skill, change the `compass:` namespace, alter the directory layout, reorder phases, or contradict an existing ADR — the agent STOPS the per-skill interview and surfaces the question as an ADR-level decision. The human and agent then either:
- write a supersede ADR and revise the plan now, or
- write a `scope-deferred.md` entry with rationale and explicitly continue with the original plan unchanged.

No silent absorption of structural drift. Structural change goes through the ADR mechanism every time.

**Consequences:** Easier — drift is detected early and explicitly; insights aren't lost; structural changes have a recording mechanism; the per-skill interviews stay focused.

Harder — adds a small ceremony (the scope statement) to every per-skill interview; requires the agent to recognize when a question is structural vs. local (judgment call); the `scope-deferred.md` file becomes another artifact to maintain.

**Alternatives considered:**
- No mechanism, trust everyone to stay on topic — rejected: drift is the default failure mode of any per-skill discussion; trust without machinery degrades.
- One layer (just escalate everything) — rejected: most drift is small; escalating it all stalls the build.
- Two layers (scope statement + escalation, no scope-deferred file) — rejected: loses the small insights that could matter at a phase boundary but aren't worth escalating in the moment.

**Invariants this creates:**
- INV-009: Every per-skill mini-interview opens with a scope statement.
- INV-010: Mid-build insights that would change the plan structurally produce an ADR or a `scope-deferred.md` entry. Never absorbed silently.
