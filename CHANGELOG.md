# Changelog

All notable changes to the Compass plugin are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] — 0.1.0

### Added (planning, 2026-06-24)
- Design spec at `specs/2026-06-24-compass-design.md` — nine new strategic-programming skills, fourteen workflow skills absorbed from Superpowers, the `.architecture/` cross-session memory mechanism, optional Claude Code hooks, dual-target packaging for Cowork and Claude Code.
- Implementation plan at `plans/2026-06-24-compass-plan.md` — ~50 bite-sized tasks across eight phases.

### Added (architecture bootstrap, 2026-06-24)
- `.architecture/` directory established before any other phase (out of plan order — see `.architecture/debt-log.md` DEBT-004).
- First socratic-interview transcript: `.architecture/interviews/2026-06-24-1717.md`.
- ADRs 0001–0011 (0001–0007 extracted from the plan; 0008–0011 written during the first execution session).
- Invariants INV-001 through INV-014.
- Conventions C-001 through C-008.
- Debt log entries DEBT-001 through DEBT-004 (DEBT-003 resolved).
- Scope-deferred entry SD-001 (plan ordering).
- Validation directory with README for the per-phase adversarial subagent evaluations defined by ADR 0011.
- Success-criteria snapshot at `specs/2026-06-24-compass-design.md.criteria-snapshot` per INV-013.

### Added (Phase 1 — Scaffolding, 2026-06-24)
- Directory skeleton: `skills/`, `templates/architecture/{decisions,interviews,session-handoffs}/`, `hooks/`, `scripts/`.
- Plugin manifest: `plugin.json` (name: `compass`, version `0.1.0`).
- README updated to reflect Phase 1 status.
- CHANGELOG.md created (this file).

### Added (Phase 2 — Architecture template + bootstrap script, 2026-06-24)
- `templates/architecture/` files that `bootstrap-architecture.sh` copies into downstream projects: `manifest.md`, `invariants.md`, `conventions.md`, `debt-log.md`, `scope-deferred.md`, `decisions/0001-example.md`, `interviews/README.md`, `session-handoffs/README.md`, `validation/README.md`.
- `scripts/bootstrap-architecture.sh` — executable POSIX shell, refuses to overwrite existing `.architecture/`, smoke-tested.
- ADR 0013: Extend ADRs 0009 and 0011 mechanisms into the default template for downstream projects (with opt-out).
- ADRs 0009 and 0011 gained "Downstream applicability" addenda referencing ADR 0013.
- Bootstrap script gained an "Opt-outs" section in its printed instructions for `scope-deferred.md` and `validation/`.
- INV-017 and INV-018 added.
- DEBT-006: Bootstrap script silently creates parent directories via `mkdir -p` (3-line fix deferred).
- Phase 2 adversarial review captured at `.architecture/validation/phase-02-2026-06-24-2014.md`.

### Added (Phase 3 — Nine new strategic skills, 2026-06-24)
- `skills/socratic-interview/SKILL.md` — agent interviews human one question at a time until convergence; transcript persisted to `.architecture/interviews/`.
- `skills/premise-check/SKILL.md` — summarizes the interview, validates against the architecture journal, categorizes the task; report persisted to `.architecture/premise-checks/` (new directory per ADR 0014).
- `skills/design-archeology/SKILL.md` — reads existing code for implicit contracts; notes persisted to `.architecture/design-notes/<source-path>.md` with source SHA (new directory per ADR 0015).
- `skills/tradeoff-matrix/SKILL.md` — forces three or more designs compared on named axes.
- `skills/adversarial-review/SKILL.md` — dispatches subagent with fresh context to attack the plan; report in `.architecture/validation/` (per ADR 0011).
- `skills/architecture-journal/SKILL.md` — meta-skill that reads `.architecture/` at session start, prompts to write mid-session, delegates to session-handoff at end.
- `skills/session-handoff/SKILL.md` — structured end-of-session note with H/A/D involvement ratio (per ADR 0008 backseating detection).
- `skills/invariant-scan/SKILL.md` — sweeps `.architecture/invariants.md` and runs each verification command; supports on-demand and scheduled invocation.
- `skills/complexity-budget/SKILL.md` — tracks accumulated shortcuts in `.architecture/debt-log.md`; surfaces them at relevant edit points (per Phase 5 hooks).

### Added (Phase 3 supporting ADRs and invariants, 2026-06-24)
- ADR 0014: Premise-check outputs persist to `.architecture/premise-checks/`. New directory + INV-019.
- ADR 0015: Design-archeology outputs persist to `.architecture/design-notes/<source-path>.md` with SHA. New directory + INV-020.
- ADR 0016: Spec §3.5 amendments formally recorded (spec rewrite deferred to Phase 8 per INV-013); design-archeology output retains spec's "Existing Design Notes" wrapper name. New INV-021, INV-022.
- New debt entries: DEBT-007 (three pre-existing invariants unverifiable as written), DEBT-008 (stale `.bak` files in working tree from sandbox sed runs).
- Back-filled `.architecture/premise-checks/2026-06-24-1731.md` per ADR 0014.

### Meta-validation
- Phase 3 adversarial subagent review captured at `.architecture/validation/phase-03-2026-06-24-2105.md`.
- Three SKILL.md frontmatter descriptions tightened to comply with `writing-skills`' no-workflow-summary rule (the plugin must apply its own discipline to itself).
- `socratic-interview` scope-statement step softened for first-interview-no-plan-yet cases.

### Added (Phase 4 — Fourteen absorbed Superpowers skills, 2026-06-24)
- **Eight verbatim absorptions** (standalone utilities): `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `using-git-worktrees`, `writing-skills`. Each: copy → `superpowers:` → `compass:` namespace rewrite + `Superpowers` → `Compass` prose rewrite + attribution footer.
- **Six coupled absorptions** (planning/execution pipeline): `brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `finishing-a-development-branch`, `using-compass` (renamed from `using-superpowers`). Each: standard absorption + a Compass coupling section in the SKILL.md body that introduces mandatory checks of `.architecture/` artifacts per ADRs 0017 and 0018.
- **Companion files copied**: per-skill prompts, references, and templates (`testing-anti-patterns.md`, `root-cause-tracing.md`, `defense-in-depth.md`, `condition-based-waiting.md`, `code-reviewer.md`, `implementer-prompt.md`, `spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md`, `visual-companion.md`, `anthropic-best-practices.md`, `persuasion-principles.md`, `testing-skills-with-subagents.md`, `graphviz-conventions.dot`, `render-graphs.js`, and the brainstorming + writing-plans reviewer prompts).
- All cross-references to `superpowers:` rewritten to `compass:`; all prose mentions of "Superpowers" as a plugin name rewritten to "Compass"; attribution footer on every absorbed `SKILL.md` cites the upstream source.
- 23 of 23 SKILL.md files now exist (9 new + 14 absorbed).

### Added (Phase 4 supporting ADRs and invariants, 2026-06-24)
- ADR 0017: Cross-platform parity for prerequisite enforcement — discipline lives in SKILL.md bodies (works on Cowork and Code); hooks are Claude Code-only reinforcement.
- ADR 0018: Mandatory-check / conditional-action / documented-decision pattern for coupled absorbed skills.
- INV-023: All 6 coupled skills carry a "Compass coupling" section.
- INV-024: Coupling sections enforce the discipline-keyword pattern.
- INV-001 verification refined to exclude attribution-footer false positives (the literal `superpowers:` appears in citations per ADR 0005; intentional).

### Added (Phase 5 — Hooks, 2026-06-24)
- `hooks/session-start.sh` — prints reminder to invoke `compass:architecture-journal`; lists recent activity in interviews/, premise-checks/, session-handoffs/, validation/ when present.
- `hooks/pre-tool-use-edit.sh` and `hooks/pre-tool-use-write.sh` — when `$TARGET_FILE` is set: prints debt-log entries that reference the target; checks for `.architecture/design-notes/<path>.md`; recommends `compass:design-archeology` when the target directory hasn't been touched this session.
- `hooks/session-end.sh` — when working tree has uncommitted changes, recommends `compass:session-handoff`.
- All hooks: exit 0 always (per ADR 0003); discipline lives in skill bodies, not hooks (per ADR 0017).

### Added (Phase 5 supporting debt, 2026-06-24)
- DEBT-011: PreToolUse `session_start_sha` heuristic is broken (`git log --reverse` returns oldest commit, not session start). Real fix requires SessionStart to capture HEAD into a state file. Deferred.

### Meta-validation
- Phase 5 adversarial subagent review captured at `.architecture/validation/phase-05-2026-06-24-2333.md`.
- 4 concerns surfaced and addressed (set -eu loosened to set -u, pre-tool-use-write header fixed, broken heuristic logged as DEBT-011, phase-validation reminder removed from SessionEnd to respect ADR 0017's "reinforcement, not source" boundary).
- INV-003 re-verified after fixes: all four hooks exit 0.

### Added (Phase 6 — Packaging, 2026-06-25)
- `scripts/package-cowork.sh` — produces `dist/compass.plugin` (zip archive) for Cowork install. Stages files in a tmpdir with `umask 022` so shipped entries are world-readable (644) and scripts world-executable (755); `mv -f` into `dist/` to avoid leftover zip temp files on UWP-mounted filesystems.
- `scripts/package-claude-code.sh` — produces `dist/compass-claude-code/` (plugin directory) for Claude Code install. Uses `rsync -a --delete` so dest mirrors source structurally (stale files from prior runs are removed). Same permission-normalization.
- `LICENSE` — pure MIT, copyright 2026 itecob.
- `NOTICE` — upstream attribution to the Superpowers plugin (`https://github.com/anthropic-experimental/superpowers`), with the full list of absorbed skills and which six carry the Compass coupling section.
- README — added "Building the package" section; phase status updated to Phase 6 Complete; "What Compass does" bullet list completed.

### Added (Phase 6 supporting ADRs and debt, 2026-06-25)
- ADR 0019: Runtime packages exclude `.architecture/`, `specs/`, `plans/` (option B), the human's override of the main session's option-C recommendation. Documents the consequences (in-install citation breakage, lost worked-example value) and the gains (cleaner transferability test for Phase 8, smaller package, symmetry with upstream Superpowers). Also documents the restoration of `set -euo pipefail` (the Phase 5 `set -u` was specific to hooks per INV-003) and the `umask 022` choice.
- DEBT-005: extended to cover the Cowork `.plugin` archive format as well as the manifest schema.
- DEBT-012: in-install citations of `.architecture/` paths inside shipped SKILL.md bodies are dead links post-Option-B. Deferred to Phase 8 spec/citation rewrite alongside INV-021.

### Meta-validation
- Phase 6 adversarial subagent returned FAIL with 14 concerns. 8 load-bearing concerns addressed in this same commit cycle: README truncation completed, CHANGELOG Phase 6 entry written, ADR 0019 written, `set -euo pipefail` restored, `rsync --delete` added, `mv -f` replaces `cp` to avoid temp leftovers, `umask 022` set, LICENSE URL fixed (`obra/superpowers` → `anthropic-experimental/superpowers`) and attribution moved to a separate `NOTICE` file.
- Phase 6 validation file at `.architecture/validation/phase-06-2026-06-25-1156.md`.
- Concerns 8, 10, 13, 14 (cosmetic) acknowledged in the validation file and either fixed or recorded as deferred. The orphaned `dist/ziitB0W1` from the original script's UWP rename-failure persists in the user's `dist/` directory and requires PowerShell `Remove-Item dist/*` to clean (gitignored, will not be committed).

### Still to come
- Phase 7: Dogfood `.architecture/` for the plugin's own design decisions (mostly done in advance during the architecture bootstrap; remaining items to be reconciled at phase boundary).
- Phase 8: Final verification, including INV-014 transferability test per ADR 0011.
