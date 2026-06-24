# socratic-compass

Repository for the **Compass** plugin — strategic-programming skills with persistent architectural memory for Claude Code and Cowork.

## Status

This repository currently contains **planning artifacts only**: a design spec and an implementation plan. The plugin itself has not yet been built. The next step is to execute the implementation plan, ideally after running the plugin's own `socratic-interview` skill on the build itself.

## What's in here

- `specs/2026-06-24-compass-design.md` — design spec for the Compass plugin: nine new strategic-programming skills, fourteen workflow skills absorbed from Superpowers, the `.architecture/` cross-session memory mechanism, optional Claude Code hooks, dual-target packaging.
- `plans/2026-06-24-compass-plan.md` — implementation plan: ~50 bite-sized tasks across eight phases that build the plugin from an empty repo.

## What Compass does

The plugin closes gaps the existing **Superpowers** plugin leaves open in the during-task loop:

- `socratic-interview` — the agent interviews the human one question at a time until convergence; the transcript is authored by the human.
- `premise-check` — summarizes the interview, validates the premise against the architecture journal, categorizes the task.
- `design-archeology` — reads existing code for implicit contracts before any change.
- `tradeoff-matrix` — forces three or more designs compared on named axes.
- `adversarial-review` — dispatches a subagent to attack the plan.
- `architecture-journal` — manages a per-project `.architecture/` directory (ADRs, invariants, conventions, debt log, interview transcripts, session handoffs).
- `session-handoff` — structured end-of-session note for the next session.
- `invariant-scan` — verifies documented invariants still hold.
- `complexity-budget` — tracks and surfaces accumulated shortcuts.

Plus fourteen workflow skills absorbed from Superpowers (TDD, debugging, code review, planning, etc.) so the plugin works standalone.

## Naming

- **Repository:** `socratic-compass` (this repo).
- **Plugin:** `compass` (declared in `plugin.json`).
- **Skill namespace:** `compass:` (e.g., `compass:socratic-interview`).

The repository name reflects the philosophy — Socratic interview drives the planning — while the plugin namespace stays short and readable.

## Attribution

Fourteen of the twenty-three skills are adapted from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin with namespace rewrites and labeled source-attribution footers. The underlying TDD-for-documentation discipline, rationalization tables, red-flag patterns, and workflow choreography all originated with Superpowers. The nine new skills (`socratic-interview`, `premise-check`, `design-archeology`, `tradeoff-matrix`, `adversarial-review`, `architecture-journal`, `session-handoff`, `invariant-scan`, `complexity-budget`) are original to Compass.

## License

MIT (see LICENSE when added).