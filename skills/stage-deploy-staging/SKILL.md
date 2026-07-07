---
name: stage-deploy-staging
description: Use after Verify passes, before the staging Test suite — the Deploy to staging build stage
---

# Stage: Deploy to staging

Pilot-series port of the "Deploy to staging" build stage (`CLAUDE-DEV.md` Build
Process flow). Short stage — most of what governs it (the staging-environment
prerequisite entry) is a Section 0a requirement already ported to `compass:stage-plan`.

**Phase name note:** there is a second, later "Deploy" stage (Deploy to production).
To avoid collision, this stage's `PLAN_STATE.md` `Phase:` value is `Deploy(staging)`,
not a bare "Deploy" — the later stage will use `Deploy(production)`.

## Scope

Deploy to a production-equivalent environment meeting the staging environment
requirements declared in `PLAN.md` Section 0a: Environment Prerequisites.

**Requirement:** every plan must include a `Type: staging-environment` prerequisite
entry before the plan is published, specifying the minimum resources, services, and
configuration required. A plan without this entry is incomplete — see
`compass:stage-plan` § Section 0a for that entry's format.

**Applied at:** after Verify (`compass:stage-verify`) passes, before the staging Test
suite (load, chaos, DAST, scenario/journey — not yet a ported skill).

**Done when:** the environment is deployed and meets the declared staging-environment
prerequisite entry from Section 0a.

## Model routing for this stage

Per `CLAUDE.md` → Model Default: **Sonnet 5**. Established-domain infrastructure
work — deploying to a pre-specified environment per a declared prerequisite. No
escalation to Opus.

## Next stage

After deployment completes: proceed to the staging Test suite (load, chaos, DAST,
scenario/journey — not yet a ported skill as of this writing; check the
`build-mode-inject-pilot.sh` hook's `PORTED_SKILL` mapping for current status). Use
`Phase: Test(staging)` to distinguish it from the already-ported `Test(pre-staging)`
stage when it is ported.
