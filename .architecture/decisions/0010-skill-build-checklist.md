# ADR 0010: Skill Build Checklist — standard question template for per-skill mini-interviews

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** Per ADR 0008's hybrid setting and ADR 0009's scope discipline, each skill in the Compass plugin is built as a focused mini-interview. Without a question template, each interview risks either being too shallow (we miss important design considerations) or too long (we exhaust ourselves on minor details). The template needs to cover the load-bearing questions for any skill, while remaining a checklist (areas to probe) rather than a script (steps to follow linearly).

**Decision:** The Skill Build Checklist below is the standard set of question areas for any per-skill mini-interview. Each interview probes one area at a time, ends when the agent has no further substantive objection, and may exit early once the major decisions are settled. For simple skills, 5–8 areas may suffice; for complex skills, all 15 may apply.

## The Checklist

### A. Identity
1. **Name** — exact hyphen-separated identifier (matches the directory name).
2. **Purpose** — one-sentence statement of what the skill does.

### B. Necessity
3. **Existence justification** — is this skill genuinely needed, or could an existing/proposed skill cover it?
4. **Value contribution** — what specific value does it add the plugin would lose without?

### C. Triggering
5. **Invocation mode** — agent automatically, human explicitly, or both?
6. **Trigger conditions** — phrased for the YAML `description` field; symptom-oriented, no workflow summary.
7. **Always-loaded vs on-demand** — should this skill be in the agent's standard context, or loaded only when its description triggers?

### D. Behavior
8. **Precondition** — what must be true before this skill runs?
9. **Postcondition** — what artifact or state exists after?
10. **Process** — how do we get from precondition to postcondition? (high-level; the SKILL.md body has the detail)
11. **Companion files** — does this skill need templates, scripts, reference docs, or prompts in the same directory?

### E. Portability
12. **Platform parity** — does this skill behave identically in Cowork, Claude Code, and chat? If not, what platform-specific notes apply?

### F. Structure
13. **Skill type** — discipline / technique / pattern / reference. Determines SKILL.md body shape.
14. **Required sections** — does this skill need an Iron Law, a rationalization table, a red-flags list? (Discipline skills need all three; reference skills usually need none.)

### G. Failure modes
15. **Skip cost** — what goes wrong if this skill is poorly written or skipped?
16. **Rationalizations** — what excuses might lead a future agent to skip the skill? (Becomes the rationalization table content.)

## Application rules

- **One area at a time.** Per the socratic-interview discipline, do not dump the whole checklist. Probe one area, read the answer for gaps, decide the next probe.
- **Terminate on convergence.** When the agent has no further substantive objection across the unprobed areas, stop. Don't run the rest of the checklist for the sake of completeness.
- **Scope-discipline applies.** Per ADR 0009, every per-skill interview opens with a scope statement and routes drift to scope-deferred.md or escalation.
- **Output is the SKILL.md content.** The interview produces the skill itself. There's no separate write-up — the answers populate the YAML frontmatter and body sections per `writing-skills` conventions.

**Consequences:** Easier — every skill gets the same depth of scrutiny on the load-bearing questions; absorbed Superpowers skills can use the checklist as a review template; the per-skill cycle has a known shape.

Harder — the checklist itself has 15 items and could feel ceremonial; agent must remember to probe one at a time rather than batch.

**Alternatives considered:**
- No template, ad hoc per skill — rejected: misses load-bearing questions inconsistently.
- A linear script (ask all 15 questions in order) — rejected: defeats the convergence-based termination of socratic-interview.
- Fewer categories (e.g., only A, B, D) — rejected: portability, structure, and failure-modes are real and consequential.

**Invariants this creates:**
- INV-011: Every new skill in this plugin is built via a mini-interview that probes the Skill Build Checklist areas. Skipping the checklist requires explicit justification recorded with the skill.

## Note for absorbed Superpowers skills

The 14 skills absorbed from Superpowers (Phase 4 of the plan) were designed and tested by the Superpowers project, not by this build. They do not require a full Skill Build Checklist interview. They may receive a light review against the checklist if the user wants to learn the concept — but the bar is "understand what you're absorbing," not "redesign the skill."
