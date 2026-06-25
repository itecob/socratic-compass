# socratic-compass

Repository for the **Compass** plugin — strategic-programming skills with persistent architectural memory for Claude Code and Cowork.

## Status

**v0.1.0 — Phase 8 of 8 complete.** The plugin is built. Eight phases ran against the implementation plan using the plugin's own discipline (socratic-interview, scope-bounded mini-interviews, adversarial subagent at every phase boundary, transferability test at the end). Nineteen ADRs, twenty-four invariants (nineteen verifiable; four `manual:`; one informational), eight conventions, thirteen debt entries (three resolved). The plugin's own `.architecture/` is the dogfood; the runtime package ships without it per ADR 0019.

| Phase | Status | Contents |
|---|---|---|
| 0 (Architecture bootstrap) | Complete | `.architecture/` — interview transcript, ADRs 0001–0011, invariants, conventions, debt log, scope deferred, validation. Done out of plan order; see `DEBT-004`. |
| 1 (Scaffolding) | Complete | Directory skeleton, `plugin.json`, README, CHANGELOG. |
| 2 (Architecture template) | Complete | `templates/architecture/` files that `bootstrap-architecture.sh` copies into user projects. |
| 3 (Nine new skills) | Complete | `socratic-interview`, `premise-check`, `design-archeology`, `tradeoff-matrix`, `adversarial-review`, `architecture-journal`, `session-handoff`, `invariant-scan`, `complexity-budget`. |
| 4 (14 absorbed Superpowers skills) | Complete | Imported with namespace rewrite, attribution footer, and Compass-coupling sections on the six that participate in the planning/execution pipeline. |
| 5 (Hooks) | Complete | Claude Code `SessionStart`, `PreToolUse`, `SessionEnd` reminders. |
| 6 (Packaging) | Complete | `package-cowork.sh` (zip), `package-claude-code.sh` (rsync). LICENSE + NOTICE added. Runtime excludes `.architecture/`, `specs/`, `plans/` per ADR 0019. |
| 7 (Dogfood reconcile) | Complete | INV-006/013 verifications fixed; ADR 0019 template normalized; Decided-by back-filled on ADRs 0001–0005; consolidated session-handoff written; DEBT-007 extended. |
| 8 (Final verification) | Complete | All 24 invariants accounted for (19 PASS, 4 manual, 1 informational, 0 FAIL); INV-014 transferability test run on a non-Compass problem (config-loading library); spec §3.3 + §3.6 + §4 rewrites; DEBT-012 citation cleanup; DEBT-008/009/010 resolved; DEBT-011 broken heuristic disabled in hooks for v0.1.0; ship-gate review documented. |

## What's in here right now

- `specs/2026-06-24-compass-design.md` — design spec (nine new skills, fourteen absorbed, `.architecture/` memory mechanism, optional Claude Code hooks, dual-target packaging).
- `plans/2026-06-24-compass-plan.md` — implementation plan (~50 bite-sized tasks across eight phases).
- `.architecture/` — the architecture journal that the plugin itself uses on itself (dogfood). Nineteen ADRs, twenty-four invariants, eight conventions, thirteen debt entries, six phase-validation reports, the consolidated build session-handoff, and the transferability test result.
- `plugin.json` — plugin manifest declaring `compass` as the plugin name.
- `CHANGELOG.md` — chronicle of what's been added.
- `LICENSE` — MIT.
- `NOTICE` — upstream attribution to Superpowers.

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

## Known limitations for v0.1.0

- **INV-014 transferability test was synthetic** (agent played both sides). DEBT-013 logged for a real-user re-run in v0.1.1.
- **DEBT-011** — the PreToolUse design-archeology session-touched heuristic in `hooks/pre-tool-use-edit.sh` and `hooks/pre-tool-use-write.sh` was disabled for v0.1.0 because the `git log --reverse` approach returned the oldest commit (not the session start) and trained users to ignore the hook. A real fix requires SessionStart to capture HEAD into a state file; deferred to v0.1.1.
- **DEBT-002** — the `$TARGET_FILE` env var name the Claude Code PreToolUse hooks read is unverified; hooks may silently no-op if Claude Code uses a different name. Easy fix once confirmed.
- **DEBT-005** — both the `plugin.json` field schema and the Cowork `.plugin` archive format are unverified against authoritative documentation.
- **DEBT-012** — six SKILL.md citations of the plugin's own `.architecture/` paths were rewritten to GitHub URLs; the URLs hardcode the `itecob/socratic-compass` location and break silently on any repo move.

## Attribution

Per `NOTICE`: this plugin absorbs fourteen workflow skills from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin (MIT-licensed). Per-skill source attribution is preserved in each absorbed SKILL.md's footer.
