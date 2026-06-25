# ADR 0019: Runtime packages exclude `.architecture/`, `specs/`, `plans/`

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Related:** ADR 0012 (build-time deviations get an ADR), DEBT-005 (manifest schema unverified), INV-014 (transferability test)

**Context:** Phase 6 of the implementation plan (`plans/2026-06-24-compass-plan.md` Tasks 36 and 37) instructed the packaging scripts to exclude only `.git/`, `dist/`, and `*.bak`. Following the plan literally would ship the plugin's own `.architecture/` (18 ADRs at the time, 24 invariants, ~50 KB of dogfood material), `specs/`, and `plans/` inside both the Cowork `.plugin` archive and the Claude Code plugin directory. The Phase 6 mini-interview surfaced three options. A: ship everything except `.git/`, `dist/`, `*.bak` (the plan as written). B: exclude `.architecture/`, `specs/`, `plans/`. C: exclude `specs/` and `plans/` only; keep `.architecture/` as worked examples. The main session recommended option C; the human chose option B.

**Decision:** The two packaging scripts (`scripts/package-cowork.sh` and `scripts/package-claude-code.sh`) exclude `.architecture/`, `specs/`, `plans/`, `.gitignore`, `.git/`, `dist/`, `*.bak`, and `.DS_Store` from the shipped package. The shipped runtime set is `plugin.json`, `README.md`, `CHANGELOG.md`, `LICENSE`, `NOTICE`, `skills/` (all 23 SKILL.md + companion files), `hooks/` (4 hook scripts), `templates/architecture/` (the bootstrap source — required by `bootstrap-architecture.sh`), and `scripts/` (`bootstrap-architecture.sh` + the two packaging scripts). The scripts run under `set -euo pipefail` (the Phase 5 `set -u` was hook-specific because INV-003 requires hooks to exit 0; packaging has no such constraint and should fail loud) and set `umask 022` so shipped entries get 644/755 file modes regardless of the host umask.

**Consequences:** Easier — clean runtime install with no in-install ambiguity between the user's `.architecture/` (bootstrap-script-created in their target project) and the plugin's own dogfood `.architecture/`. Cleaner transferability test in Phase 8 (no contamination source). ~30% smaller package. Symmetry with upstream Superpowers (which doesn't ship its own `.architecture/`). Strict-mode + umask choices catch real failure modes (`rm -rf` errors, multi-user-install permission issues) that would otherwise ship silently. Harder — in-install citations of `.architecture/` paths inside shipped SKILL.md bodies become dead links (DEBT-012 logged for citation cleanup at Phase 8). Worked-example value of shipping our own ADRs is lost (users who want it must visit GitHub).

**Alternatives considered:**
- Option A — ship everything except `.git/`, `dist/`, `*.bak` (the plan literal). Rejected: ambiguity between plugin's dogfood and user's bootstrap output; ~30% size cost; not aligned with upstream convention.
- Option C — exclude `specs/` and `plans/` only; keep `.architecture/`. Rejected by human: the worked-example value did not outweigh the in-install confusion risk for users running the bootstrap script.
- Keep `set -u` (matching Phase 5 hooks). Rejected: hooks have INV-003 (exit 0 always), packaging scripts do not; suppressing errors in build scripts hides real failures.
- Leave umask at sandbox default (077). Rejected: ships 0700 entries that break multi-user installs.

**Invariants this creates:** none new directly; reinforces INV-001 (verification on the shipped archive, which excludes the attribution-footer false positives per its existing carve-out).

**Tracked debt:**
- DEBT-005 (extended): the `.plugin` archive format assumption also covers the Cowork side, not only the Claude Code manifest schema.
- DEBT-012: in-install citations of `.architecture/` paths in shipped SKILL.md bodies are dead links post-Option-B. Rewrite to qualify with GitHub URLs in a follow-up pass (Phase 8 spec rewrite per INV-021 is the natural moment).
