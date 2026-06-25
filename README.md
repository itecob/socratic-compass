# socratic-compass

Repository for the **Compass** plugin — strategic-programming skills with persistent architectural memory for Claude Code and Cowork.

## Status

**Phase 7 of 8 complete — Dogfood reconciled.** The plugin is being built incrementally against the implementation plan, using the plugin's own discipline (socratic-interview, scope-bounded mini-interviews, adversarial subagent at phase boundaries). Phases 0–7 are complete. Phase 7 closed by fixing broken invariant verifications (INV-006, INV-013), back-filling the `Decided by:` field on early ADRs, normalizing ADR 0019 to the canonical template, and writing a consolidated session-handoff that captures the H/A/D ratio across the build (per ADR 0008). Phase 8 is the final verification.

| Phase | Status | Contents |
|---|---|---|
| 0 (Architecture bootstrap) | Complete | `.architecture/` — interview transcript, ADRs 0001–0011, invariants, conventions, debt log, scope deferred, validation. Done out of plan order; see `DEBT-004`. |
| 1 (Scaffolding) | Complete | Directory skeleton, `plugin.json`, README, CHANGELOG. |
| 2 (Architecture template) | Complete | `templates/architecture/` files that `bootstrap-architecture.sh` copies into user projects. |
| 3 (Nine new skills) | Complete | `socratic-interview`, `premise-check`, `design-archeology`, `tradeoff-matrix`, `adversarial-review`, `architecture-journal`, `session-handoff`, `invariant-scan`, `complexity-budget`. |
| 4 (14 absorbed Superpowers skills) | Complete | Imported verbatim with namespace rewrite + attribution footer. |
| 5 (Hooks) | Complete | Claude Code `SessionStart`, `PreToolUse`, `SessionEnd` reminders. |
| 6 (Packaging) | Complete | `package-cowork.sh` (zip), `package-claude-code.sh` (rsync). LICENSE + NOTICE added. Runtime excludes `.architecture/`, `specs/`, `plans/` per ADR 0019. |
| 7 (Dogfood reconcile) | Complete | INV-006 and INV-013 verifications fixed; ADR 0019 template normalized; Decided-by back-filled on ADRs 0001–0005; consolidated session-handoff written; DEBT-007 extended. |
| 8 (Final verification) | Pending | Invariant scan + INV-014 transferability test + INV-002 standalone-install verification. |

## What's in here right now

- `specs/2026-06-24-compass-design.md` — design spec (nine new skills, fourteen absorbed, `.architecture/` memory mechanism, optional Claude Code hooks, dual-target packaging).
- `plans/2026-06-24-compass-plan.md` — implementation plan (~50 bite-sized tasks across eight phases).
- `.architecture/` — the architecture journal that the plugin itself uses on itself (dogfood). Eleven ADRs, fourteen invariants, conventions, debt log, scope-deferred, validation, and the first interview transcript.
- `plugin.json` — plugin manifest declaring `compass` as the plugin name.
- `CHANGELOG.md` — chronicle of what's been added.

## What Compass does

The plugin closes gaps the existing **Superpowers** plugin leaves open in the during-task loop:

- `socratic-interview` — the agent interviews the human one question at a time until convergence; the transcript is authored by the human.
- `premise-check` — summarizes the interview, validates the premise against the architecture journal, categorizes the task.
- `design-archeology` — reads existing code for implicit contracts before any change.
- `tradeoff-matrix` — forces three or more designs compared on named axes.
- `adversarial-review` — dispatches a subagent to attack the plan.
- `architecture-journal` — meta-skill that reads `.architecture/` at session start and prompts to write mid-session.
- `session-handoff` — structured end-of-session note capturing structural changes and involvement ratio.
- `invariant-scan` — sweeps `.architecture/invariants.md` and runs each verification command.
- `complexity-budget` — tracks accumulated shortcuts in `.architecture/debt-log.md`.

Plus fourteen workflow skills absorbed verbatim from Superpowers (eight standalone utilities + six with a Compass-coupling section that introduces mandatory `.architecture/` checks). See `NOTICE` for the full absorbed-skill list and source attribution.

## Building the package

The repository ships build scripts that produce both Cowork and Claude Code packages:

- `bash scripts/package-cowork.sh` → `dist/compass.plugin` (zip archive for Cowork).
- `bash scripts/package-claude-code.sh` → `dist/compass-claude-code/` (plugin directory for Claude Code).

Both scripts exclude `.architecture/`, `specs/`, `plans/`, `.git/`, `dist/`, `*.bak`, `.gitignore`, and `.DS_Store` from the shipped artifact (per ADR 0019). The plugin's own `.architecture/` remains visible here on GitHub for users who want to read the dogfood ADRs as examples.

Requirements: `bash`, `zip`, `rsync`. On Windows native, Git Bash with optional Unix tools, or WSL, satisfies this.