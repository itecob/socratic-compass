# ADR 0018: Coupled absorbed skills use the mandatory-check / conditional-action / documented-decision pattern

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** Phase 4 absorbs 14 Superpowers skills. Six of them participate in the planning/execution pipeline and benefit from reading the strategic discipline's artifacts (premise-checks, design-notes, debt-log, involvement settings). The other eight are standalone utilities. The user-stated requirement (Phase 4 interview): the check for relevant prerequisites must be non-optional ("I really want to, as much as possible, make it so they can't be ignored"); the action taken on what the check finds is judgment.

## Decision

For the six coupled absorbed skills, inject a "Compass coupling" section into the SKILL.md body using this three-part pattern:

**1. Mandatory check.** The skill text instructs the agent to perform a specific check (read a journal file, scan a directory, etc.). The check is not optional. The agent must do it.

**2. Conditional action.** Based on what the check returns, the agent chooses an action from a defined set. The set typically includes: consume the artifact; refresh the artifact via the producing skill; proceed without and explicitly note why; or recognize the project lacks `.architecture/` and proceed without.

**3. Documented decision.** Whichever action the agent takes, it documents the choice in the skill's output. The user can audit later that the agent considered the artifact and explain why it did or didn't consume it.

The six coupled absorbed skills and what each must check:

| Skill | Must check |
|---|---|
| `brainstorming` | most recent `premise-checks/`; relevant `design-notes/` for any files being discussed (with SHA freshness) |
| `writing-plans` | most recent `premise-checks/`; the brainstorming session output; relevant `design-notes/`; `invariants.md` for constraints |
| `executing-plans` | the plan being executed; `debt-log.md` for any files the plan touches; involvement setting from ADR 0008 |
| `subagent-driven-development` | same as `executing-plans` (subagents need the same context); plus the H/A/D ratio in recent session-handoffs to know whether to surface the involvement question |
| `finishing-a-development-branch` | must trigger `session-handoff` before finalizing; must run final `invariant-scan`; must not skip these even on a clean-tests-passing path |
| `using-compass` (renamed from `using-superpowers`) | must invoke `architecture-journal` at session start in any project with `.architecture/`; surfaces the involvement-ratio signal from recent handoffs |

The other eight absorbed skills (`test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `using-git-worktrees`, `writing-skills`) are absorbed verbatim with only the standard namespace rewrite and attribution footer. They are standalone utilities; mandatory checks are not justified for them.

## Consequences

**Easier:** Coupled skills enforce the discipline regardless of platform (per ADR 0017). The agent cannot silently skip the check. Documented decisions create an audit trail for what was considered and why.

**Harder:** Six skill bodies carry a Compass-specific section that doesn't exist in the upstream Superpowers source. Each upstream update to those skills requires manual reconcile to preserve the coupling section. The verbatim diff with upstream is non-zero for those six skills; the attribution footer flags this for auditors.

## Alternatives considered

- **Document-only coupling (no mandatory check).** Rejected per user requirement.
- **Block-on-missing-artifact (skill refuses to run unless the artifact exists).** Considered. Rejected as too rigid for legitimate cases (e.g., the very first brainstorming session in a greenfield project where no premise-check exists yet). The mandatory-check pattern handles this case via the "documented decision" leg.
- **Coupling for all 14 skills, not just 6.** Rejected. Test-driven-development, debugging, code-review, etc. are standalone utilities; forcing them to check journal artifacts adds friction without benefit. The pipeline skills are where coupling matters.

## Invariants this creates

- **INV-024:** Coupled skills' "Compass coupling" sections instruct the agent to perform the check and document the decision. Verification: for each of the 6 coupled skills, `grep -E "(mandatory|must check|document.*decision)" skills/<name>/SKILL.md` returns a match.

## Relationship to upstream Superpowers

The original Superpowers SKILL.md files do not contain Compass coupling. The post-absorption modification is the price of the dual-target enforcement. Each absorbed skill's attribution footer notes that the body has been modified beyond the standard namespace rewrites and lists the modifications (per ADR 0005's attribution discipline).
