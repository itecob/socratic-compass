# ADR 0006: Human is the driver; agent is the foil

**Status:** accepted (scope refined by ADR 0008 on 2026-06-24 — applies to pre-planning phase only; execution and downstream phases use the per-project involvement setting defined in ADR 0008)
**Date:** 2026-06-24
**Decided by:** H
**Context:** A risk surfaced after the first design pass: every pre-planning skill (premise-check, design-archeology, tradeoff-matrix, adversarial-review) had the agent generate the artifact and the human approve it. This is procedurally fast but offloads the cognitive work to the agent. The user retains veto power, not driver's seat. For projects where the user explicitly wants their own knowledge and judgment to compound, that is a structural failure.
**Decision:** Add a `socratic-interview` skill that runs first on any non-trivial task. The agent conducts a one-question-at-a-time interview that probes the human's reasoning until the agent has no further substantive objection. The transcript is authored by the human in their own words. `premise-check` is demoted from generator to summarizer over that transcript. Decision authority is tracked in every ADR via a `Decided by:` field (H/A/D). The session-handoff reports the ratio so backseating is visible structurally.
**Consequences:** Easier — the human's reasoning, not the agent's inference, is the source of truth for planning. Decision authority is auditable. Backseating is detectable. Harder — every non-trivial task takes longer at the front; the user must engage rather than approve.
**Alternatives considered:**
- Keep the agent-generates / human-approves flow — rejected: it is exactly the offloading we want to prevent.
- Add the interview as a section inside premise-check — rejected: conflates interview-the-human with structure-the-output; the two have different rules and run at different times.
- Use "adversarial-interview" as the name — rejected on the user's preference for "socratic-interview" because the goal is mutual understanding, not opposition.
**Invariants this creates:** INV-006 (every plan has a corresponding interview transcript).
