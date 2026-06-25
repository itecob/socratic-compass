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

## DEBT-009: ADR 0008 (involvement setting) is not in the bootstrap template; coupling gracefully degrades in user projects
**Files:** `templates/architecture/`, `skills/executing-plans/SKILL.md`, `skills/subagent-driven-development/SKILL.md`
**Deferred:** Copying ADR 0008 (or a downstream-applicable equivalent) into the bootstrap template so user projects have an involvement setting to read.
**Reason:** ADR 0008 is plugin-specific (it describes the Compass build's own involvement choices). A downstream user project should declare its own involvement setting via an ADR, not inherit Compass's. But coupling sections in `executing-plans` and `subagent-driven-development` reference ADR 0008 as if it exists in the user's `.architecture/`.
**Will bite when:** In a user project freshly bootstrapped, the coupling-section's "involvement-setting" check fails to find the ADR. Per ADR 0018's documented-decision leg the agent handles this gracefully (notes the absence and proceeds), but the first user invocation will produce a confusing "could not find ADR 0008" note.
**Cost to fix:** S (write a generic ADR-0008-template-stub into `templates/architecture/decisions/0008-involvement-setting-example.md` that a user can adopt, or update the coupling sections to reference an abstract "your project's involvement-setting ADR" instead of literal "ADR 0008").
**Logged:** 2026-06-24

## DEBT-010: Two extra companion files absorbed beyond spec §4 table
**Files:** `skills/brainstorming/spec-document-reviewer-prompt.md`, `skills/writing-plans/plan-document-reviewer-prompt.md`
**Deferred:** Either (a) removing them, or (b) amending spec §4 to list them.
**Reason:** The Phase 4 absorption copied all companion files from each upstream skill directory, not only the ones listed in spec §4. These two are real upstream templates (reviewer-prompt files); they contain Compass-aligned content after the rewrite pass; they are harmless if kept and informative-but-undocumented if so. The spec §4 rewrite for Phase 8 (per INV-021) should address this.
**Will bite when:** A user audits the spec against the shipped files and finds extras. Or upstream Superpowers adds more companion files; the absorption logic needs an explicit allow/deny list.
**Cost to fix:** S (decide keep-or-remove; update spec §4 in Phase 8).
**Logged:** 2026-06-24

## DEBT-011: PreToolUse design-archeology heuristic is broken (session-start SHA is wrong)
**Files:** `hooks/pre-tool-use-edit.sh`, `hooks/pre-tool-use-write.sh`
**Deferred:** Fixing the "no commits this session in <dir>" heuristic in the PreToolUse hooks.
**Reason:** The current implementation uses `git log --reverse --format=%H -n 1` to get the "session start SHA" — but that command returns the OLDEST commit in the repository, not the session start commit. As a result, the heuristic almost always fires (suggesting design-archeology on every file edit) on young repositories. Phase 5 adversarial review caught this. The real fix requires the SessionStart hook to capture `git rev-parse HEAD` into a state file (e.g., `.architecture/.session-start-sha`) and the PreToolUse hook to read it. Non-trivial; defers cleanly.
**Will bite when:** A user installs the plugin and gets a "consider compass:design-archeology" reminder on every Edit/Write, even when they've already touched the file this session. Noise that trains users to ignore the hook.
**Cost to fix:** M (need to add SessionStart write of `.session-start-sha`, PreToolUse read of same, .gitignore entry; coordinate across 3 hook files; test that the state file gets cleaned up).
**Logged:** 2026-06-24
