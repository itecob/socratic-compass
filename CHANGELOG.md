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

### Still to come
- Phase 4: The fourteen absorbed Superpowers skills, with namespace rewrites and attribution footers per ADRs 0001/0005.
- Phase 5: Optional Claude Code hooks (reminders, not blockers, per ADR 0003).
- Phase 6: Packaging scripts for both Cowork (.plugin archive) and Claude Code (plugin directory).
- Phase 7: Dogfood `.architecture/` for the plugin's own design decisions (mostly done in advance during the architecture bootstrap; remaining items to be reconciled at phase boundary).
- Phase 8: Final verification, including INV-014 transferability test per ADR 0011.
