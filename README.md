# socratic-compass

Repository for the **Compass** plugin — strategic-programming skills with persistent architectural memory for Claude Code and Cowork.

## Status

**Phase 3 of 8 complete — Nine new strategic skills.** The plugin is being built incrementally against the implementation plan, using the plugin's own discipline (socratic-interview, scope-bounded mini-interviews, adversarial subagent at phase boundaries). Phases 0–3 are complete: the architecture journal, scaffolding, template + bootstrap, and all nine new strategic skills exist. The plugin is not yet installable — Phase 4 absorbs the Superpowers workflow skills; Phases 5–8 add hooks, packaging, and verification.

| Phase | Status | Contents |
|---|---|---|
| 0 (Architecture bootstrap) | Complete | `.architecture/` — interview transcript, ADRs 0001–0011, invariants, conventions, debt log, scope deferred, validation. Done out of plan order; see `DEBT-004`. |
| 1 (Scaffolding) | Complete | Directory skeleton, `plugin.json`, README, CHANGELOG. |
| 2 (Architecture template) | Complete | `templates/architecture/` files that `bootstrap-architecture.sh` copies into user projects. |
| 3 (Nine new skills) | Complete | `socratic-interview`, `premise-check`, `design-archeology`, `tradeoff-matrix`, `adversarial-review`, `architecture-journal`, `session-handoff`, `invariant-scan`, `complexity-budget`. |
| 4 (14 absorbed Superpowers skills) | Pending | Imported verbatim with namespace rewrite + attribution footer. |
| 5 (Hooks) | Pending | Claude Code `SessionStart`, `PreToolUse`, `SessionEnd` reminders. |
| 6 (Packaging) | Pending | `package-cowork.sh`, `package-claude-code.sh`. |
| 7 (Dogfood reconcile) | Pending | Reconcile plugin's own `.architecture/` with what was bootstrapped early. |
| 8 (Final verification) | Pending | Invariant scan + INV-014 transferability test. |

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
- `arc