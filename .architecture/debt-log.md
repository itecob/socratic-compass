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
