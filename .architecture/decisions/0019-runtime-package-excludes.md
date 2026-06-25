# ADR 0019: Runtime packages exclude `.architecture/`, `specs/`, `plans/`

**Date:** 2026-06-24
**Status:** Accepted
**Decided by:** Human (override of main session's recommendation of option C)
**Supersedes:** None
**Superseded by:** None
**Related:** ADR 0012 (build-time deviations get an ADR), DEBT-005 (manifest schema unverified), INV-014 (transferability test)

## Context

Phase 6 of the implementation plan (`plans/2026-06-24-compass-plan.md` Tasks 36
and 37) instructed the packaging scripts to exclude only `.git/`, `dist/`, and
`*.bak`. Following the plan literally would ship the plugin's own `.architecture/`
(18 ADRs, 24 invariants, ~50 KB of dogfood material), `specs/`, and `plans/`
inside both the Cowork `.plugin` archive and the Claude Code plugin directory.

During the Phase 6 mini-interview, three options were considered:

- **A.** Ship everything except `.git/`, `dist/`, `*.bak` (the plan as written).
- **B.** Exclude `.architecture/`, `specs/`, `plans/` from the shipped package.
- **C.** Exclude `specs/` and `plans/` only; keep `.architecture/` as worked
  examples of the discipline.

The main session recommended option C. The human chose option B.

## Decision

The two packaging scripts (`scripts/package-cowork.sh` and
`scripts/package-claude-code.sh`) exclude `.architecture/`, `specs/`, `plans/`,
`.gitignore`, `.git/`, `dist/`, `*.bak`, and `.DS_Store` from the shipped
package. The shipped runtime set is:

- `plugin.json` (manifest)
- `README.md`, `CHANGELOG.md`, `LICENSE`, `NOTICE`
- `skills/` (all 23 SKILL.md + companion files)
- `hooks/` (4 hook scripts)
- `templates/architecture/` (the bootstrap source — required by
  `bootstrap-architecture.sh`)
- `scripts/` (`bootstrap-architecture.sh` + the two packaging scripts)

## Rationale

The human's rationale for option B: a clean runtime install with no in-install
ambiguity between the user's `.architecture/` (which the bootstrap script
creates fresh in their target project) and the plugin's own dogfood
`.architecture/`. The plugin's `.architecture/` remains publicly visible on
GitHub (`https://github.com/itecob/socratic-compass`) for users who want to
read it as an example.

Three other arguments support the choice:

1. **Cleaner transferability test.** Per ADR 0011 / INV-014, Phase 8 will
   verify that a fresh install + `bootstrap-architecture.sh` produces a clean
   `.architecture/` in a target project. Option B removes a potential
   contamination source — the user's bootstrapped `.architecture/` cannot
   inadvertently inherit content from the plugin's own dogfood.
2. **Smaller package.** ~30% size reduction (162 KB vs ~230 KB for the zip).
3. **Symmetry with upstream Superpowers.** Superpowers doesn't ship its own
   `.architecture/` (it doesn't have one). Compass shipping its dogfood would
   be unusual.

## Consequences

1. **In-install citations are dead.** Several shipped SKILL.md files cite
   `.architecture/` paths inside the plugin's own journal — e.g.,
   `skills/socratic-interview/SKILL.md` cites the first interview transcript,
   `skills/adversarial-review/SKILL.md` cites validation-file naming, etc.
   These citations are informational, not operational. A user following them
   finds nothing in the install. The README will eventually document that
   the plugin's own `.architecture/` is on GitHub. **DEBT-012 logged for
   the citation-cleanup follow-up.**
2. **No worked-example value in-install.** Users who would have benefited
   from reading our ADRs as examples now must visit GitHub.
3. **Cowork `.plugin` format risk unchanged.** Shipping a renamed zip is the
   plan's assumption; whether Cowork actually accepts that format is not
   verified by these scripts. **DEBT-005 extended to cover the `.plugin`
   archive format risk.**
4. **`set -euo pipefail` restored.** Both packaging scripts use full strict
   mode (the Phase 5 hooks use `set -u` only because INV-003 requires hooks
   to exit 0; packaging scripts have no such constraint and should fail loud
   on rsync/zip errors).
5. **umask 022 set explicitly.** Without this, the sandbox's umask 077 ships
   files as `rwx------`, breaking multi-user installs after unzip.

## Verification

- INV-001 (`superpowers:` exclusion) re-verified after Phase 6.
- Smoke test: both scripts exit 0; the produced artifacts contain zero
  entries from `.architecture/`, `specs/`, `plans/`; all 23 SKILL.md present.
- Phase 6 validation file (`.architecture/validation/phase-06-*`) captures
  the reviewer's concerns and the response.

## Tracked debt

- **DEBT-005 (extended):** the `.plugin` format assumption also covers the
  Cowork side, not only the Claude Code manifest schema.
- **DEBT-012:** in-install citations of `.architecture/` paths are dead links;
  rewrite to qualify with GitHub URLs in a follow-up pass (Phase 8 spec
  rewrite is the natural moment per INV-021).
