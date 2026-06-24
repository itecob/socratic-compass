# ADR 0008: Human involvement level is a per-project, mutable setting (supersedes the rigid framing of ADR 0006)

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Supersedes:** the rigid framing of ADR 0006 (the principle that "human is the driver" applies always, in all phases). ADR 0006 remains accepted for the pre-planning phase (interview, premise-check, design-archeology, brainstorming); this ADR refines its scope.

**Context:** ADR 0006 baked a preference into a principle. The preference — "human stays in the driver's seat always" — is one specific answer to a deeper question: *how much oversight does the human want for this particular project, and at what stages?* For the pre-planning phase, the answer should be "high oversight" (that's what ADR 0006 was designed for). For execution and downstream phases, the answer depends on the human, the project, and what the human is trying to accomplish (delivery speed vs. learning vs. quality control).

Concretely: a manager working with a trusted employee gives clear intent + autonomy and reviews at milestones. A manager working with a struggling employee gives close oversight and frequent check-ins. The same project can move between these modes as the relationship and the work evolves.

**Decision:** Human involvement is a per-project, mutable setting elicited during the socratic-interview, recorded in `.architecture/`, and respected by all downstream skills. The setting has at minimum these values (the project can introduce others):

- **High oversight** — review at every task boundary; agent surfaces every artifact for approval before writing.
- **Phase-level** — review at phase boundaries; agent drives intra-phase work without interrupting.
- **Hands-off** — agent executes to completion; human reviews at the end.
- **Hybrid / per-skill** — defined by the project (e.g., the Compass build itself uses this).

**Mutability:** the setting can change at any session boundary, or mid-session if the human invokes the change. The trigger conditions include — but are not limited to — "you're doing well, back off" and "this is going sideways, get closer." Each change produces an ADR addendum (`status: amended <date>`) explaining the trigger and the new setting. Old settings are not deleted; they form the history.

**Consequences:** Easier — projects can move at the right speed for their stage; humans aren't forced into a mode that doesn't fit; the relationship between human and agent has explicit machinery for evolving.

Harder — agents must read the current setting before acting (which means the architecture-journal skill must surface it on session start); the human is responsible for noticing when the setting is wrong for the work.

**Alternatives considered:**
- Keep ADR 0006 rigid — rejected: forces high-touch oversight even when delegation is appropriate; treats agent capability as zero.
- Hard-code per-phase involvement (e.g., "high during planning, low during execution") — rejected: doesn't account for project-specific variation or in-flight adjustment.
- Skip recording the setting and let the human signal preference each turn — rejected: setting drifts implicitly; no record for the next session to load.

**Invariants this creates:**
- INV-008: Every project has a recorded involvement setting in `.architecture/`. The setting is read at session start (by architecture-journal) and surfaced to the human before any work begins.

**Initial setting for this project (Compass build):** *Hybrid / per-skill* — each skill is built as a mini-interview conversation, with the human learning the discipline as the build proceeds. Mutable per the above.
