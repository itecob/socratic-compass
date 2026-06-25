# Compass — Architecture Manifest

This directory is the project's architectural memory. Claude reads it at session start; humans read it at onboarding.

## Contents

- `decisions/` — ADRs, one per file, sequentially numbered.
- `invariants.md` — what must remain true. Each invariant has an ID and a verification command.
- `conventions.md` — non-obvious idioms a newcomer would not infer from the code.
- `debt-log.md` — known shortcuts, where they will bite, when to revisit.
- `scope-deferred.md` — mid-build insights that are out of scope right now but might matter later (per ADR 0009).
- `interviews/` — socratic-interview transcripts. One per planning session. Authored by the human, hardened by the agent.
- `premise-checks/` — `compass:premise-check` reports. One per planning cycle. Parallel to interviews/.
- `design-notes/` — `compass:design-archeology` outputs, mirroring source tree at `<path>.md`. Per ADR 0015.
- `session-handoffs/` — time-ordered notes written at the end of each session by the agent.
- `validation/` — adversarial subagent evaluations at each phase boundary, plus the end-of-build transferability test (per ADR 0011).

## How to use

**Starting a session:** read this manifest, then load the relevant subset of ADRs / invariants / conventions for the current task. Do not load everything.

**During a session:**
- Making a structural decision → propose an ADR (template: `decisions/0001-example.md`, or any existing ADR).
- Establishing an invariant → add to `invariants.md` with a verification command.
- Taking a shortcut → log it in `debt-log.md`.
- Surfacing a mid-build insight that's out of current scope → log it in `scope-deferred.md` (ADR 0009).

**Ending a session:** write a structured handoff in `session-handoffs/YYYY-MM-DD-HHMM.md`.

## Top-level summary

This is the Compass plugin repository. Compass is a Claude Code / Cowork plugin that adds nine new strategic-programming skills and absorbs fourteen workflow skills from the Superpowers plugin (with namespace rewrites and labeled attribution). The repository contains both the plugin itself (in `skills/`, `templates/`, `hooks/`, `scripts/`, `plugin.json`) and its own dogfooded `.architecture/` directory describing the plugin's design decisions.

The implementation plan lives at `plans/2026-06-24-compass-plan.md`. The design spec at `specs/2026-06-24-compass-design.md`. Execution proceeds per the hybrid involvement setting (ADR 0008) using the Skill Build Checklist (ADR 0010) under the scope discipline mechanism (ADR 0009).

## Quick index of ADRs

- 0001 — Use `compass:` as the skill namespace prefix.
- 0002 — Absorb Superpowers skills rather than declare a dependency.
- 0003 — Hooks print reminders, never block.
- 0004 — Rename absorbed `using-superpowers` to `using-compass`.
- 0005 — Blanket prose rewrite plus attribution footer for absorbed skills.
- 0006 — Human is the driver; agent is the foil. *(Scope refined by ADR 0008.)*
- 0007 — Premise-check includes validation and categorization.
- 0008 — Human involvement level is a per-project, mutable setting (supersedes the rigid framing of 0006).
- 0009 — Three-layer scope discipline for mid-build insights.
- 0010 — Skill Build Checklist — standard question template for per-skill mini-interviews.
- 0011 — Meta-validation methodology: anchor to spec §11, adversarial subagent per phase, transferability test at end.
- 0012 — Build-time deviations from the plan: manifest content, README/CHANGELOG progress-document form, commit cadence collapsed to per-phase.
- 0013 — Extend ADRs 0009 and 0011 mechanisms into the default template for downstream projects (with opt-out).
- 0014 — Premise-check outputs persist to `.architecture/premise-checks/`.
- 0015 — Design-archeology outputs persist to `.architecture/design-notes/<source-path>.md`.
- 0016 — Spec §3.5 amended (formal record only); design-archeology output retains "Existing Design Notes" wrapper name.
- 0017 — Prerequisite enforcement lives in SKILL.md bodies (cross-platform); hooks are Claude Code-only reinforcement.
- 0018 — Coupled absorbed skills use the mandatory-check / conditional-action / documented-decision pattern.
- 0019 — Runtime packages exclude `.architecture/`, `specs/`, `plans/` (option B); LICENSE pure MIT, attribution moved to NOTICE.
