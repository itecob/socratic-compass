---
name: stage-test
description: Use when running the pre-staging test suite after RT(impl) passes, before Verify — the Test (unit/integration/property-based) build stage
---

# Stage: Test (unit, integration, property-based)

Pilot-series port of the "Test: unit, integration, property-based" build stage
(`CLAUDE-DEV.md` Build Process flow + Build Standards). This is a short stage — the
substantive content (what each suite must cover) lives in `compass:stage-plan` §
Section 8: Test Contract, which this stage executes against.

## Scope

Run the pre-staging test suite: unit, integration, and property-based tests. All three
types are required for T1/T2 systems. T3-only builds (Reduced Plan) may run the
pre-staging suite only — any exception to running all three types must be documented.

**Applied at:** after `RT(impl) → Harden` loop reaches its exit condition, before
Verify.

**Phase name note:** there is a second, later "Test" stage in the build process (the
staging suite: load, chaos/fault injection, DAST, scenario/journey). To avoid
collision, `PLAN_STATE.md`'s `Phase:` value for THIS stage is `Test(pre-staging)`, not
a bare "Test" — the future staging-test stage will use `Test(staging)`.

**Done when:** all three suite types have run and pass, per the Test Contract defined
in `PLAN.md` Section 8 (see `compass:stage-plan` for that contract's format and
requirements — this stage does not redefine it, only executes against it).

## Testing is not optional

Two suites ship with every T1/T2 build:
- **Pre-staging** (this stage): unit, integration, property-based
- **Staging** (later stage, not yet ported): load, chaos/fault injection, DAST,
  scenario/journey

T3-only builds: pre-staging suite only. Exception must be documented.

## Model routing for this stage

Per `CLAUDE.md` → Model Default: **Sonnet 5** — writing and running tests is
established-domain, mechanical-verification work. No escalation to Opus for this
stage under normal circumstances.

## Next stage

After all pre-staging suites pass: proceed to Verify (`gate.sh` exit 0, no exceptions —
not yet a ported skill as of this writing; check the build-mode-inject-pilot.sh hook's
`PORTED_SKILL` mapping for current status).
