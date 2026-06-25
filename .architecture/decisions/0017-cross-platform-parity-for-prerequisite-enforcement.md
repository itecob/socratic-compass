# ADR 0017: Prerequisite enforcement lives in SKILL.md bodies (cross-platform); hooks are Claude Code-only reinforcement

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The plugin ships to both Cowork and Claude Code per spec §2. Cowork does not support the hook mechanism that Claude Code uses (per ADR 0003). The Phase 4 entry-condition decision surfaced a design risk: if Compass's strategic-discipline coupling (the mandatory checks that ensure premise-check artifacts get consumed by brainstorming, etc.) lived only in hooks, Cowork users would silently miss the discipline. That violates the dual-target promise.

The user-stated requirement (Phase 4 interview): "we need to make sure that both are eligible, both are working one hundred percent as intended rather than just say, like, this doesn't work here."

## Decision

**Prerequisite enforcement lives in SKILL.md bodies, not in hooks.** The SKILL.md is platform-agnostic Markdown that any compliant agent reads on invocation. Both Cowork and Claude Code get the same enforcement because both read the SKILL.md.

**Hooks (Phase 5) become Claude Code-only reinforcement.** They print reminders before tool use (per ADR 0003's "hooks are reminders") that re-emphasize what the SKILL.md already requires. They are not the source of truth and are not required for the discipline to work. Their absence in Cowork degrades the user experience slightly but does not break the enforcement.

This means the upstream-sync cost (every Superpowers update to an absorbed skill requires manual reconcile of the coupling) is accepted. The benefit — discipline that actually reaches the user in both platforms — justifies the cost.

## Consequences

**Easier:** Cowork and Claude Code have identical enforcement behavior. The plugin's promise of dual-target parity is real. Hook authoring (Phase 5) becomes a smaller, more focused task: the hooks know they're reinforcement, not source.

**Harder:** SKILL.md bodies for the coupled skills (per ADR 0018) carry coupling instructions that must be maintained when upstream Superpowers updates the skill. Each absorbed skill modification must be documented for resync auditing.

## Alternatives considered

- **Hook-only enforcement.** Rejected: leaves Cowork users without enforcement. Violates dual-target promise.
- **using-compass meta-skill carries all coupling.** Considered. Would centralize the coupling in one always-loaded skill, but creates a giant meta-skill text that mixes concerns across all skills. Per-skill body coupling is more discoverable and more localized.
- **Document-only coupling (skill body just describes the discipline; no mandatory check).** Rejected per the user's Phase 4 interview: "I really want to, as much as possible, make it so they can't be ignored."

## Invariants this creates

- **INV-023:** Every coupled absorbed skill (the 6 identified in ADR 0018) carries a "Compass coupling" section in its SKILL.md body, applied via post-absorption edit. Verification: `grep -l "Compass coupling" skills/brainstorming/SKILL.md skills/writing-plans/SKILL.md skills/executing-plans/SKILL.md skills/subagent-driven-development/SKILL.md skills/finishing-a-development-branch/SKILL.md skills/using-compass/SKILL.md | wc -l` returns 6.

## Relationship to ADR 0003

This ADR does not supersede ADR 0003. ADR 0003 said hooks print reminders, never block. That remains true. This ADR adds: hooks are *not* where the discipline lives. The discipline is in the skill body; the hook is a friendly reminder of what the skill already enforces.
