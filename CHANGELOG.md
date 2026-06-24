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

### Still to come
- Phase 2: Architecture template files (`templates/architecture/manifest.md`, `invariants.md`, `conventions.md`, `debt-log.md`, example ADR) + `scripts/bootstrap-architecture.sh`.
- Phase 3: The nine new skills, built via per-skill mini-interviews per ADR 0010.
- Phase 4: The fourteen absorbed Superpowers skills, with namespace rewrites and attribution footers per ADRs 0001/0005.
- Phase 5: Optional Claude Code hooks (reminders, not blockers, per ADR 0003).
- Phase 6: Packaging scripts for both Cowork (.plugin archive) and Claude Code (plugin directory).
- Phase 7: Dogfood `.architecture/` for the plugin's own design decisions (mostly done in advance during the architecture bootstrap; remaining items to be reconciled at phase boundary).
- Phase 8: Final verification, including INV-014 transferability test per ADR 0011.
