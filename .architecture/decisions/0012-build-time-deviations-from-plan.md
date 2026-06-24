# ADR 0012: Build-time deviations from the implementation plan — manifest content, README/CHANGELOG form, commit cadence

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The Phase 1 adversarial subagent review (`.architecture/validation/phase-01-2026-06-24-1836.md`) surfaced three deviations from the implementation plan that were made silently during execution. None block subsequent phases; all warrant explicit recording so future maintainers (including future Claude sessions) can audit the decisions. The reviewer recommended either documenting each deviation in DEBT entries or writing an ADR. ADR was chosen because two of the three are intentional design decisions, not deferred work.

## The three deviations

### Deviation 1 — Plugin manifest content

Plan Task 2 specified:
- `"author": "Compass"`

Shipped `plugin.json` has:
- `"author": "itecob"` (matches the GitHub org and the actual publisher)
- `"homepage": "https://github.com/itecob/socratic-compass"` (extra field not in plan)

**Decision:** Author is `itecob` (the GitHub org publishing the plugin). The `homepage` field is added because it improves discoverability for users browsing plugin metadata. Both choices are intentional. DEBT-005 already flags the manifest schema as unverified — these specific content choices are aligned with conventional manifest fields used by similar plugin systems (npm, vscode-extension, etc.).

### Deviation 2 — README and CHANGELOG forms during the build

Plan Task 3's README draft is a forward-looking install-and-use document ("drag `compass.plugin` onto the Cowork window"). Plan Task 4's CHANGELOG draft is a release-style stub.

Shipped README and CHANGELOG are progress documents — the README has a phase-by-phase status table; the CHANGELOG is a build-log with sections for planning, architecture bootstrap, and each phase.

**Decision:** During the build (Phases 1–8), README and CHANGELOG are *progress documents* that reflect what's actually true in the working tree. After Phase 8, both files are rewritten to the shipped forms specified in the plan's Task 3 and Task 4 drafts (install instructions in the README; release-style entries in the CHANGELOG).

Rationale: an install-focused README for a plugin that isn't installable yet is a lie to anyone visiting the repo. A release-style CHANGELOG for a project that hasn't released anything is a lie. The build is public on GitHub; documents must match reality.

The transition is part of Phase 8 verification: rewrite README + CHANGELOG to the plan-drafted forms before any release tag.

### Deviation 3 — Commit cadence

Plan Steps 1.3, 2.2, 3.2, and 4.2 specified one `git commit` per task with prefixes like `scaffold: plugin manifest`. Phase 1 was executed in a single conversational pass, then handed off to the user for committing.

**Decision:** Commit cadence collapses from one-per-task to one-per-phase. Each phase produces a single consolidated commit with a multi-line message enumerating the tasks completed.

Rationale: the human (not the agent) is the one running `git commit` because git operations from the Cowork sandbox hit UWP filesystem permission issues with the index.lock file. Four separate hand-offs per phase multiplies friction without proportional value. The phase boundary is the natural review/checkpoint unit (per ADR 0008's hybrid involvement setting); the commit boundary should align with it.

Cost: incremental-revert at the task level is lost. If a specific task within a phase later needs to be undone, it's harder than `git revert <task-commit>` — requires manual file-level revert. Accepted because the plan is highly linear and phase-level revert (`git revert <phase-commit>`) covers most realistic failure modes.

## Consequences

**Easier:** Each phase has a single clean commit with a meaningful message. Manifest content reflects reality (real author, real homepage). README and CHANGELOG are honest about build state. The plan's Task 3 and Task 4 drafts remain as a future-state checklist for Phase 8.

**Harder:** Task-level revert is no longer free. New maintainers reading the plan literally and the actual git history will see mismatched cadence — they should be pointed to this ADR. The README and CHANGELOG carry an additional rewrite burden in Phase 8.

## Alternatives considered

- **Write four separate `scaffold:` commits per phase** — rejected: friction in the human-driven commit flow outweighs the incremental-revert benefit.
- **Move the plan to match the actual cadence (rewrite Steps X.3 commit messages)** — rejected: the plan is the source of intent; deviations should be documented as deviations, not normalized into the plan.
- **Use DEBT entries instead of an ADR** — rejected: two of the three deviations are intentional design decisions, not deferred work. DEBT-005 still covers schema *uncertainty* (which fields exist), but field *content* choices are decisions and warrant an ADR.

## Invariants this creates

- **INV-015:** README and CHANGELOG match the plan's Task 3 and Task 4 drafts at Phase 8 completion (before any release tag). Verification: at release time, diff the shipped README/CHANGELOG against the plan-drafted forms and confirm convergence.
- **INV-016:** Each phase from 1 forward produces exactly one consolidated commit. Verification: `git log --oneline` shows one commit per phase boundary, prefixed with `phase-NN:` or similar.
