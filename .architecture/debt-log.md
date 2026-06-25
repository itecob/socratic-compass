# Debt Log

Known shortcuts in this repository. Each entry has files affected, what was deferred, why, when it will bite, and cost-to-fix (S/M/L/XL).

## DEBT-001: Plugin-dependency mechanism not yet supported
**Files:** `plugin.json` (when created)
**Deferred:** Declaring Superpowers as a runtime dependency.
**Reason:** No such mechanism exists in either Cowork or Claude Code plugin systems as of 2026-06-24.
**Will bite when:** Upstream Superpowers updates a workflow skill in a way that changes behavior; this plugin's absorbed copy drifts and the user wants to resync.
**Cost to fix:** L (requires upstream change once a mechanism exists; then a re-pinning sweep).
**Logged:** 2026-06-24

## DEBT-002: Hook environment variable for the target file path is unconfirmed
**Files:** `hooks/pre-tool-use-edit.sh`, `hooks/pre-tool-use-write.sh` (when created)
**Deferred:** Confirming the exact environment variable name Claude Code uses to pass the target file to a PreToolUse hook.
**Reason:** Not documented in any source accessible at the time of plan writing.
**Will bite when:** A user installs the plugin in Claude Code and the hook silently no-ops because the variable is named differently.
**Cost to fix:** S (one sed once the name is confirmed).
**Logged:** 2026-06-24

## DEBT-003: (Resolved 2026-06-24) Narrative "Superpowers" mentions in absorbed skill bodies
**Files:** `skills/*/SKILL.md` (absorbed only — once written)
**Deferred:** Originally, only `superpowers:` prefixes were rewritten; prose references to "Superpowers" as a proper noun remained.
**Reason:** Blanket replacement was initially considered unsafe for citations.
**Will bite when:** *(Was a risk; now resolved.)*
**Cost to fix:** *(Was M; now zero.)*
**Logged:** 2026-06-24
**Resolved:** 2026-06-24 — see ADR 0005. The `rewrite()` function now does blanket "Superpowers" → "Compass" substitution in absorbed skill bodies, and Task 31a appends a labeled attribution footer to each absorbed SKILL.md. INV-005 verifies the footer is present.

## DEBT-004: Plan ordering puts `.architecture/` setup in Phase 7, but it must exist earlier
**Files:** `plans/2026-06-24-compass-plan.md`
**Deferred:** Reordering the plan so `.architecture/` is set up before Phase 1 (it's needed by every other skill).
**Reason:** Discovered mid-build (2026-06-24 interview session). The plan listed `.architecture/` dogfood as Phase 7 — too late, because the architecture-journal skill we write in Phase 3 references files that need to exist by Phase 0. The current build sidesteps this by creating `.architecture/` immediately (this session) before any other phase.
**Will bite when:** Anyone follows the plan literally from a fresh clone — they'll build skills that reference `.architecture/` content that doesn't exist yet.
**Cost to fix:** S (rewrite the plan's phase ordering, or add a Phase 0 to the plan explicitly).
**Logged:** 2026-06-24

## DEBT-005: Plugin manifest schema is unverified
**Files:** `plugin.json`
**Deferred:** Confirming the exact schema Cowork and Claude Code expect for the plugin manifest.
**Reason:** No authoritative documentation available at the time of writing. Used a reasonable conventional set of fields (`name`, `version`, `description`, `author`, `license`, `homepage`, `skills_dir`, `hooks_dir`).
**Will bite when:** Attempting to install the plugin into either Cowork or Claude Code — the loader may reject the manifest or ignore fields silently.
**Cost to fix:** S (one pass against authoritative docs or against a known-working plugin's manifest; correct field names as needed).
**Logged:** 2026-06-24

## DEBT-006: Bootstrap script silently creates parent directories via `mkdir -p`
**Files:** `scripts/bootstrap-architecture.sh`
**Deferred:** Adding an explicit `[ -d "$TARGET" ]` pre-check before `mkdir -p "$TARGET/.architecture"`.
**Reason:** Phase 2 reviewer flagged this as a small surprise — a user with a typo in the target path will get a `.architecture/` directory at an unexpected filesystem location. The current behavior is convenient (`mkdir -p` semantics) but not user-friendly to typo recovery.
**Will bite when:** A user runs the bootstrap with a misspelled path; the script succeeds, but the `.architecture/` lands somewhere unexpected.
**Cost to fix:** S (three-line pre-check; no design impact).
**Logged:** 2026-06-24

## DEBT-007: Three invariants are unverifiable as written (INV-002, INV-007, INV-008)
**Files:** `.architecture/invariants.md`
**Deferred:** Cleaning up three pre-Phase-3 invariants flagged by the Phase 3 adversarial review:
- INV-002 uses prose "Manual: install in a clean environment..." instead of the literal `manual` token that `compass:invariant-scan` recognizes.
- INV-007 has `Verification: —, Expected: —, On failure: —` — it's not a real invariant; should be deleted or marked informational.
- INV-008's verification grep targets a Compass-build-specific filename; the invariant as worded ("Every project has a recorded involvement setting") is supposed to generalize to downstream projects but the verification doesn't.
**Reason:** Pre-Phase-3 problems; Phase 3 added enough new invariants that the broken ones now stand out. Fixing requires per-invariant judgment (delete vs reword vs generalize).
**Will bite when:** `compass:invariant-scan` runs against this project; INV-007 returns BROKEN_VERIFICATION; INV-002 silently skips; INV-008 returns a fragile pass.
**Cost to fix:** S (15 minutes; three small edits).
**Logged:** 2026-06-24

## DEBT-008: Stale `.bak` files in the working tree
**Files:** `.architecture/manifest.md.bak`, `scripts/bootstrap-architecture.sh.bak`, `templates/architecture/manifest.md.bak`
**Deferred:** Deleting them. Sandbox rm fails with "Operation not permitted" on the mounted Windows folder.
**Reason:** UWP packaged-app filesystem quirk. User-side `Remove-Item` from PowerShell works; sandbox-side `rm` doesn't.
**Will bite when:** They get committed (currently they're untracked but would be picked up by a `git add -A`); polluted greps; readers confused about which file is canonical.
**Cost to fix:** Trivial (30 seconds) — `Remove-Item -Force .architecture/manifest.md.bak scripts/bootstrap-architecture.sh.bak templates/architecture/manifest.md.bak` in PowerShell.
**Logged:** 2026-06-24
