---
name: stage-verify
description: Use after the pre-staging Test suite passes, before Deploy to staging — the Verify build stage
---

# Stage: Verify

Pilot-series port of the "Verify" build stage (`CLAUDE-DEV.md` Build Process flow).
This is the thinnest stage in the whole process — the source defines it in one line,
faithfully reproduced below rather than padded out with invented detail.

## Scope

**Verify** — the verification command exits 0. No exceptions.

**Applied at:** after the pre-staging Test suite (`compass:stage-test`) passes, before
Deploy to staging.

**Done when:** the project's declared verification command exits 0. This is often
called `gate.sh` in existing conventions, but the exact command is project-specific —
it is declared per-project in `PLAN.md` Section 0a: Environment Prerequisites (see
`compass:stage-plan` for that section's format). This stage does not define what the
verification command checks — it only requires that whatever command the plan
declares, it must exit 0 before promotion continues.

**No exceptions** — this stage has no partial-pass, no "acceptable known failures," no
override. A verification command that exits non-zero blocks the next stage.

## Model routing for this stage

Per `CLAUDE.md` → Model Default: **Sonnet 5**. This stage is a mechanical
pass/fail gate check, not a judgment call — running the declared command and reading
its exit code. No escalation to Opus.

## Next stage

After the verification command exits 0: proceed to Deploy to staging (not yet a
ported skill as of this writing; check the `build-mode-inject-pilot.sh` hook's
`PORTED_SKILL` mapping for current status).
