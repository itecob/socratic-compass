# Conventions

Non-obvious idioms used in this repository. Things that newcomers will not infer from reading the code or skill files alone.

## C-001: ADR files use sequential numbering; never reused on supersede
When an ADR is superseded, the new one gets a new number; the old one stays in place with a `Status: superseded by NNNN` line added. The number itself is permanent. This means `decisions/0006-...` always exists even after ADR 0008 refined its scope.

## C-002: Skill cross-references use the `**REQUIRED SUB-SKILL:**` marker
Inherited from Superpowers. Always lowercase the skill name; always prefix with `compass:`. Example: `**REQUIRED SUB-SKILL:** Use compass:test-driven-development`. The marker indicates the dependent skill must be invoked before continuing.

## C-003: Hooks print, never block
Established by ADR 0003. Every hook script ends with `exit 0`. Hooks are *reminders* (text Claude sees) not *gates* (exit non-zero to block). This keeps Cowork (which lacks hooks) at functional parity with Claude Code.

## C-004: Verification commands in invariants.md are exact shell commands
Not pseudocode, not "manually check." If a verification cannot be automated, label it `Verification: manual` and provide the exact procedure. The goal: a future agent running `invariant-scan` should be able to execute every verification command without invention.

## C-005: Per-skill interviews open with the scope statement
Established by ADR 0009 Layer 1. Every per-skill mini-interview begins with the agent stating: "The plan says this skill exists to do X. We're discussing how, not whether." This catches scope drift at the cheapest possible point.

## C-006: Decided by codes in ADRs are H / A / D
Established by ADR 0006 and refined by ADR 0008. Every ADR has a `Decided by:` field with one of three values:
- `H` — human decided the substance; agent surfaced options.
- `A` — agent proposed; human explicitly approved.
- `D` — delegated to agent without explicit human review.

The session-handoff reports the ratio at session end. Many consecutive `A` or `D` entries are a signal that the human has been backseated and should reassess the involvement setting (ADR 0008).

## C-007: Absorbed Superpowers skills get an attribution footer, not a name change
Established by ADR 0005 with one exception (ADR 0004 — `using-superpowers` is renamed to `using-compass` because of the meta-skill loop). For all other absorbed skills, the skill keeps its original name; only the cross-references and prose mentions of "Superpowers" are rewritten to "Compass," and a labeled attribution footer is appended.

## C-008: Plugin name (`compass`) and repo name (`socratic-compass`) are intentionally different
The plugin's identity (skill namespace, `plugin.json` name) is `compass` — short and readable. The repository name is `socratic-compass` — reflects the philosophy that drives the planning. Don't unify them; the distinction is deliberate.
