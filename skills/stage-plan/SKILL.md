---
name: stage-plan
description: Use when writing PLAN.md following the Development Plan Standard — the Plan build stage
---

# Stage: Plan

Pilot skill — ported from the 18-stage Build Process's "Plan" stage (`CLAUDE-DEV.md`). Loads on demand instead of riding along with every build-mode prompt.

## Scope

Write PLAN.md following the Development Plan Standard. All sections required (or Reduced Plan for T3-only projects). Specify stage output is embedded in Section 3 and Section 6.

**Done when:** all sections required by the plan type are present (see Plan Structure), and the soft language audit is clean (Section 9).

## Template Applicability

```
WHAT THIS IS:             A standard for producing LLM-coder-executable build plans.
WHAT IT IS NOT:           A design rationale, architecture overview, stakeholder brief,
                          exploratory sketch, tutorial, or standalone post-deploy runbook.
                          Section 12 post-deploy artifacts are embedded in PLAN.md as
                          production exit criteria — they are part of the build
                          specification, not a separate operational document.
APPLIES WHEN:             Building a new component or making a scoped modification with
                          defined acceptance criteria and at least one T1 or T2 component.
DOES NOT APPLY TO:        Hotfixes (< 3 files), exploratory prototypes, infrastructure-only
                          changes, data migrations, post-deployment runbooks.
                          For T3-only projects: use Reduced Plan (see below), or
                          `compass:writing-plans` if the work doesn't need FIAO/PLAN_STATE.md
                          machinery at all (see "Choosing stage-plan vs writing-plans" below).
                          For anything in this DOES NOT APPLY TO list, `compass:writing-plans`
                          is usually the better fit outright.
PROPORTIONALITY:          The planning cost is proportionate to the cost of failure.
                          For T1/T2 work, the plan prevents rework that costs more than
                          the plan itself. The standard is not overhead — it is insurance.
CORRECTNESS GATE:         A plan is publishable only when all six correctness properties
                          hold and the Plan Review Gate finds no defects.
NOT CORRECT WHEN:         Any soft language survives the audit | any T1/T2 FIAO block
                          lacks a "Does NOT" line | any task lacks "MUST NOT modify" |
                          purpose statement is untestable | any structured type is
                          undefined | any "Does NOT" behavior is unassigned in the
                          Responsibility Map.
KNOWN LIMITATION:         The standard enforces structure. The Plan Review Gate enforces
                          semantics. Structure without semantic review produces compliant
                          but empty plans. No template substitutes for the reviewer asking:
                          "Does this Action line specify enough to write the function
                          without inference?"
```

## Choosing stage-plan vs writing-plans

Compass ships two plan-writing skills at different weight classes. They are not
duplicates — pick by the same criteria as Template Applicability above:

- **`compass:stage-plan`** (this skill) — full Development Plan Standard: FIAO blocks
  with epistemic labels, tier classification, `PLAN.md`/`PLAN_STATE.md` split, Plan
  Review Gate, Test Contract, and (for T1/T2) mandatory red-teaming and a staging test
  suite. Use when the work has at least one T1/T2 component, or when it must feed into
  `compass:stage-code` / `compass:stage-rt-spec`'s FIAO-based pipeline.
- **`compass:writing-plans`** — lighter checkbox-task plans (`docs/compass/plans/*.md`)
  for `compass:executing-plans` / `compass:subagent-driven-development` to run. Use for
  hotfixes, exploratory prototypes, infrastructure-only changes, or any T3-only work
  where the FIAO/tier/red-team machinery isn't needed.

Do not mix formats: a plan written by `writing-plans` has no FIAO blocks for
`stage-code` to implement against, and a `PLAN.md`/`PLAN_STATE.md` pair from this skill
is not what `executing-plans` expects.

## Correctness Definition

A specification artifact is correct when all six properties hold:

1. **Purpose is explicit** — states a testable purpose: measurable outcome + evaluation condition + pass/fail threshold. "The system handles sessions" is not testable. "Returns a valid SessionRecord within 200ms for 99% of requests under 100 concurrent users" is testable. Completeness is measured against the stated purpose only.

2. **Complete** — every function, input, action, output required by the purpose is present.

3. **Sound** — what is specified is correct. Two modes:
   - **Pre-build**: verified against a prototype, an analogous system, or a written first-principles reasoning chain. The reasoning chain must appear inline in the relevant FIAO Action note or as a named appendix — unwritten reasoning is not a verification basis. Pre-build soundness must be re-verified post-build.
   - **Post-build**: verified against the actual running system.
   The Plan State Header declares which mode applies. "Assumed sound" is not valid.

4. **Minimal** — no specification removable without affecting the executor's ability to fulfill the purpose. Strategic repetition that counteracts context-window loss is structural, not waste.

5. **Temporally valid** — specifies when the plan becomes invalid, what event triggers that condition, what action is required, and who owns it. A plan that silently drifts is not correct.

6. **Execution-fit** — usable by the intended executor within its reliable working context (not theoretical maximum). Default: 6,000–8,000 tokens per task section. Override documented in Plan State Header with justification.

Complete but unsound = not correct. Sound but not execution-fit = not correct.

## Reduced Plan (T3-only projects)

A project composed entirely of T3 components (pure functions, no external state) uses:
- Section 1: Plan Header
- Section 2: Naming Conventions
- Section 3: Data Dictionary
- Section 4: Directory Layout
- Section 6: Component Specs (typed signature + one-line behavior per function)
- Exit conditions per component

Sections 5 and 7–11 apply only when at least one T1 or T2 component is present.

## Plan Files

Every plan uses two files:

**PLAN.md** — the published specification. Immutable after the Plan Review Gate passes. Used for: original design intent, Plan Review Gate audit, post-project review.

**PLAN_STATE.md** — the execution log. Updated by Plan Sync after each task. Contains: current state, full updated FIAO blocks (complete overrides, not diffs), deviations log, discovered functions, changelog.

**During execution: PLAN_STATE.md is the single authoritative source.** PLAN.md is the baseline for review and audit only. An executor reading only PLAN.md during active implementation is working from a potentially stale spec.

## Plan Structure

Every PLAN.md contains these sections in this order. A plan missing any section is incomplete — do not begin implementation.

### SECTION 0: PLAN STATE HEADER *(lives in PLAN_STATE.md, not PLAN.md)*

The first thing a new session reads when resuming. Updated by Plan Sync after every task.

```
plan_version:                   <integer; incremented on publish and each Plan Change>
soundness_mode:                 pre-build | post-build
soundness_basis:                <prototype name | analogous system | "first-principles —
                                 see Appendix A"> — never left blank
soundness_verified_post_build:  false  ← must become true with evidence before closure
parallelism:                    single-executor | multi-agent
plan_owner:                     parent session | <agent ID> | n/a (single-executor)
executor_context:               <known token limit for reliable attention | default 6k–8k>

last_completed:                 T<n> | none
in_progress:                    T<n> | none
blocked:                        T<n> — <reason> | none
deviations_count:               <integer>
fiao_updated:                   [function names updated since original publish]
```

### SECTION 0a: ENVIRONMENT PREREQUISITES *(in PLAN.md)*

Checked before T1 starts. Every external dependency the plan assumes exists. A missing dependency discovered at implementation time is a plan defect.

```
Dependency:   <name>
Type:         database-schema | installed-package | running-service | config-file |
              api-key | environment-variable | filesystem-path
Version:      <required version or range | any>
Verify:       <exact command that confirms the dependency exists and is correct version>
If missing:   <exact remediation command — not "install it">
```

```
Requirement:  Reproducible build
Type:         build-discipline
Rule:         All dependency versions must be exact (not ranges). A lock file
              (requirements.txt with pinned versions and hashes, package-lock.json,
              poetry.lock, or equivalent) must exist and must be the sole source of
              dependency versions used in the build. The build must be reproducible
              from the lock file alone — a fresh environment installing only from the
              lock file must produce an identical runtime to the original build
              environment.
Verify:       pip-compile --generate-hashes ... (see If missing) — then:
              pip install -r requirements.txt --require-hashes --dry-run exits 0
If missing:   pip install pip-tools && pip-compile --generate-hashes pyproject.toml
              -o requirements.txt (or equivalent for project's build system).
              Note: `pip freeze > requirements.txt` does NOT generate hashes and
              does NOT satisfy the reproducible build requirement.
NOT acceptable: version ranges (>=1.0, ~=2.0, ^3.0) in the lock file; "latest" as
                a version; undeclared transitive dependencies;
                requirements.txt without per-package hashes; any lock file that allows
                pip to resolve different versions on different machines
```

```
Requirement:  Property-based testing library
Type:         installed-package
Version:      hypothesis>=6.0 (Python); fast-check>=3.0 (TypeScript); or equivalent
              for project language
Verify:       python3 -c "import hypothesis; print(hypothesis.__version__)"
If missing:   pip install hypothesis
```

```
Requirement:  Staging environment
Type:         staging-environment
Rule:         A staging environment is the deployment target for the staging test suite.
              It must be separate from localhost/test-runner environments.
              Minimum requirements must be stated per-plan — there is no universal default.
Verify:       <plan-specific command that confirms staging is running and reachable>
If missing:   <plan-specific setup steps>
NOT acceptable: localhost; in-process test mocks substituting for a running service;
                any environment where the load or chaos tests cannot actually stress
                the system
```

### SECTION 1: PLAN HEADER

```
project:               <name>
purpose:
  statement:           <one sentence>
  measurable_outcome:  <what is measured>
  evaluation_condition: <under what condition>
  pass_threshold:      <what constitutes pass vs. fail>
domain:                established | novel
domain_basis:          <one sentence — specific prior art or pattern>
red_team_tier:         T1 | T2 | T3
plan_type:             greenfield | modification
in_scope:              [explicit list]
NOT IN SCOPE:          [explicit list — FIAO Actions touching these are plan defects]
applies_when:          <preconditions>
does_not_apply_when:   <explicit exclusions>
components:            [list]
```

`plan_type` default is `brownfield`. A repo is `greenfield` only when it contains exclusively base files: `__init__.py`, `.gitignore`, `README.md`, `requirements.txt`, `setup.py`, `pyproject.toml`, `config.yaml`, `PLAN.md`, `PLAN_STATE.md` — and no substantive modules. When using echo-dev-mcp: `detect_repo_state()` determines this automatically. Manual override must be documented in `domain_basis`.

`plan_type: brownfield` requires Section 5 (Existing Interface Inventory).
`plan_type: greenfield` omits Section 5 but must state "confirmed by detect_repo_state".

### SECTION 2: NAMING CONVENTIONS

Every name-bearing element type must have an explicit row. "Follow the pattern" is not a convention statement. Unlisted element types: derive from closest match and document the derivation inline.

| Element | Convention | Example |
|---|---|---|
| Python files | snake_case | session_store.py |
| Classes | PascalCase | SessionStore |
| Public methods | snake_case | get_session |
| Private methods | _snake_case | _check_expiry |
| Constants | SCREAMING_SNAKE | MAX_SESSION_AGE_SECS |
| Config keys | snake_case | max_session_age_secs |
| Test functions | test\_\<what\>\_\<condition\> | test_get_session_expired |
| DB tables | snake_case plural | sessions, audit_events |
| DB columns | snake_case | session_id, expiry_ts |
| Event names | \<component\>.\<verb\>.\<noun\> | session.validated.ok |
| API route paths | /kebab-case | /session-validate |
| Log field names | snake_case | session_id, error_code |
| Plan files | PLAN.md, PLAN_STATE.md | — |
| Issue files | YYYYMMDD_HHMMSS\_\<slug\>.md | — |

### SECTION 3: DATA DICTIONARY

See `compass:stage-specify` — Data Dictionary entries for every structured type, domain object, and project-specific term referenced in any FIAO block.

### SECTION 4: DIRECTORY LAYOUT

Every file listed. No "and so on." No implicit files.

```
<project-root>/
  <component>/
    __init__.py     # exports: ClassName, function_name  ← complete list
    <module>.py     # contains: class ClassName
    tests/
      test_<module>.py
  config.yaml       # keys: key1, key2  ← complete list

MUST NOT create: any file not listed above
```

### SECTION 5: EXISTING INTERFACE INVENTORY *(modification plans only)*

Functions and types in the existing codebase this plan depends on but does not modify. Each receives a read-only FIAO derived from reading the existing code, marked `frozen: true`. A frozen FIAO cannot be deviated from — if it is wrong, the plan is wrong, not the code.

```
Component:  <existing component name>
File:       <exact path>
Frozen interfaces:
  [FIAO block with frozen: true for each function this plan calls or depends on]
```

### SECTION 6: COMPONENT SPECS

Repeat for every component this plan creates or modifies:

```
Component:           <name>
File:                <exact/path/to/file.py>
Tier:                T1 | T2 | T3
Responsible for:     <one sentence — what it OWNS>
NOT responsible for: <adjacent concerns it explicitly does not own>
Applies when:        <preconditions for valid use>
Does not apply when: <explicit exclusions>

Positive invariants (must always be true):
  - <condition>

Negative invariants (must never be true):
  - <condition>
  - <dependency prohibition: this component must never import from X>

Negative invariants (must never be true) — mandatory for T1/T2 in addition to
component-specific invariants:
  - Every failure path in this component emits an observable signal: a log entry at
    ERROR level or higher, a metric increment, or a raised exception that propagates
    synchronously to the direct caller, is captured and re-raised within the same async
    task before the task completes, or is published to the component's named error event
    channel if an async boundary exists. Fire-and-forget async patterns (tasks with no
    exception handler and no error channel) do not satisfy this invariant. No failure
    path is swallowed silently. A component that fails without an observable signal
    violates this invariant regardless of how unlikely the failure is.
    [This invariant must appear explicitly in every T1/T2 component spec. Omitting it
    is a plan defect, not an implicit guarantee.]

Interfaces:
  [FIAO block for each public method]
```

FIAO block format itself: see `compass:stage-specify`.

### SECTION 7: TASK BREAKDOWN

Tasks are ordered. Dependencies named by output, not task number alone. Each task has exactly one verifiable exit condition.

```
Task:              T<n> — <name>
Depends on:        T<n-1> outputs: <exact files or named objects that must exist>
                   none  (if first task)
Files to create:   <exact list | none>
Files to modify:   <exact list | none>
MUST NOT modify:   <files where accidental modification causes silent failure — explicit>
                   All unlisted files are implicitly excluded; high-risk files named here.
MUST NOT create:   any file not in "Files to create" above
Functions:         [FIAO block for each new or modified function]
Temporal validity:
  condition:       <what makes this task's output stale>
  trigger:         <event that causes the condition — specific, not "requirements change">
  action_required: <exact step when triggered>
  owner:           <who detects and acts>
  n/a when:        this task's output is consumed immediately by T<n+1> and not referenced again
Exit condition:    <one shell command that exits 0 iff this task is done correctly>
Spec compliance:   <3–5 things a reviewer confirms by reading the code, not running it>
```

Plan Sync process: see `compass:stage-code` — mandatory at end of every task, before starting T\<n+1\>.

### SECTION 8: TEST CONTRACT

Test suites are organized in two groups matching the build process stages:

**Pre-staging suite** (runs before Verify and Deploy to staging):
- Unit tests — individual function behavior
- Integration tests — component interaction and data flow
- Property-based tests — invariant verification across auto-generated inputs; required for any function with a non-trivial input space. A function has a non-trivial input space when it: accepts a string, integer, float, or collection with no fixed cardinality; has two or more parameters that interact; or has correctness that depends on ordering or boundary conditions.

**Staging suite** (runs after Deploy to staging; required when system contains T1/T2):
- Load tests — system behavior under expected and peak load; pass threshold: state in plan (e.g., "p99 latency < 500ms at 100 req/s")
- Chaos / fault injection tests — system behavior when dependencies fail; pass threshold: system recovers to known-good state within the Recovery Time Objective (RTO) and Recovery Point Objective (RPO) stated in the Test Contract entry for this test type. If no RTO/RPO has been stated, the test cannot be marked passing — they must be declared in the plan before the test runs.
- DAST — dynamic security scan of running HTTP surfaces; pass threshold: zero P0/P1 findings; P2/P3 findings logged as issues before promotion
- Scenario / journey tests — end-to-end execution of named user/caller journeys including wrong-order steps, retries, and edge-case sequences; "what actually happens when a real caller goes through this" — not just the happy path

T3-only systems (Reduced Plan): pre-staging suite only; staging suite not required; this exception must be stated in PLAN.md NOT IN SCOPE with justification.

For each test in every suite:

```
Test file: <exact/path/test_module.py>

test_<what>_<condition>:
  Setup:       <exact state before the call>
  Call:        <exact function call with exact arguments>
  Assert:      <exact assertion — value, type, or exception type + message pattern>
  NOT testing: <what this test explicitly does not cover>
```

No "test the happy path." Every case is a named scenario. `NOT testing` prevents a passing suite from being mistaken for complete coverage.

### SECTION 9: SOFT LANGUAGE AUDIT

Search for every string below before publishing. Resolve every hit.

```
"appropriate", "as needed", "standard", "reasonable", "etc.", "handle",
"manage", "process", "validate", "similar", "relevant", "necessary",
"latest", "active", "current", "default", "and so on", "for example",
"typical", "normal", "usually", "generally", "often"
```

Add domain-specific ambiguous terms before running. Any term requiring a definition in this project's context is added to the list before the audit runs.

### SECTION 10: RESPONSIBILITY MAP

Populated before Plan Review Gate Step 3. Mechanical extraction, not a reading task: grep all "NOT responsible for" fields and all FIAO "Does NOT" lines, extract each behavior verbatim, find its owner by scanning "Responsible for" fields and FIAO Actions.

| Behavior (verbatim from "NOT responsible for" or "Does NOT") | Assigned to |
|---|---|
| \<extracted behavior\> | \<Component.method \| "Known Gap: P\<n\>"\> |

Any row with an empty "Assigned to" is a P1 gap that blocks plan publication.

### SECTION 11: KNOWN GAPS

```
Gap:                <name>
Severity:           P0 | P1 | P2 | P3
Blast radius:       <what fails downstream if this gap is triggered>
Mitigating control: <what reduces risk in the meantime>
Resolution path:    <exact change that closes this gap>
```

P0/P1 gaps block plan publication. P2/P3 gaps are logged; plan proceeds.

### SECTION 12: POST-DEPLOY ARTIFACTS

Post-deploy artifacts are exit criteria for the "Deploy to production" build stage. Production deploy is blocked until all three artifact types exist, are reviewed, and are committed alongside the code they describe.

These are living documents — they must be updated whenever the system's behavior, failure modes, or operational requirements change. A stale runbook is a P2 defect.

**Runbook**

Format for each operational state the system can enter:

```
State:          <name — what the system is doing or experiencing>
Symptom:        <exactly what is observable: alert name, log pattern, or metric threshold>
Preconditions:  <what must be true before this procedure applies>
Steps:
  1. <exact command or action>
  2. <exact command or action>
  ...
Expected outcome: <what the system looks like after the procedure completes>
Escalate if:    <condition under which this procedure is insufficient — who to contact>
Does NOT cover: <adjacent states explicitly excluded from this runbook entry>
```

Minimum required runbook entries:
- Service start and stop (clean)
- Service start failure
- High error rate (definition: p99 error rate > threshold stated in alerting spec)
- Dependency unavailable (each named external dependency gets one entry)
- Rollback procedure — verified by executing the rollback command against the staging deployment and confirming the system returns to the prior known-good state (defined as: the operational health check command exits 0). Test execution and outcome must be documented in the runbook entry itself under a `Tested:` field: `Tested: <ISO date> against staging commit <sha> — outcome: <pass/fail>`

**Alerting Spec**

```
Alert:          <name>
Metric:         <exact metric name and source>
Condition:      <exact threshold expression — no soft language>
Severity:       P0 | P1 | P2 | P3
Owner:          <who receives this alert>
Runbook entry:  <State name from runbook above>
NOT alerting on: <adjacent conditions explicitly excluded to prevent false positives>
```

**Incident Response Playbook**

```
Severity: P0
  First action:    <exact step — not "investigate">
  Communication:   <who is notified, in what order, via what channel, within what SLA>
  Rollback trigger: <exact condition that triggers rollback>
  Rollback command: <exact command — tested, not assumed>
  Post-mortem:     mandatory; within 48 hours; output feeds back to Specify stage

Severity: P1
  First action:    <exact step>
  Communication:   <same format>
  Rollback trigger: <exact condition>
  Rollback command: <exact command>
  Post-mortem:     mandatory; within 5 business days

Severity: P2/P3
  First action:    Log as issue file in workspace/issues/OPEN/ per the Issue Resolution
                   Process; assign to the project backlog.
  Post-mortem:     not required; pattern review if 3+ P2 incidents share a root cause
```

**Operational Health Check**

A single command that verifies the system's critical invariants are holding:

```
Command:   <exact shell command>
Frequency: <how often this is run — cron expression or interval>
Pass:      exits 0
Fail:      exits non-zero; output names which invariant failed
On fail:   <exact next step — not "investigate">
```

## Plan Review Gate

Runs after all sections pass the soft language audit. The plan is publishable when all 8 steps find no defects.

**Step 1 — Purpose alignment:**
Every section, component, and FIAO block serves the stated measurable outcome. Remove anything that does not.

**Step 2 — Scope enforcement:**
No FIAO Action in any component touches its own "NOT responsible for" concerns. No FIAO Action anywhere touches the NOT IN SCOPE list.

**Step 3 — Responsibility Coverage Check:**
Review the Responsibility Map. Every row has a non-empty "Assigned to". Empty rows are P1 gaps — log in Known Gaps before proceeding.

**Step 4 — Boundary type cross-reference (scoped):**
For each task T\<n\>: FIAO Output types match T\<n+1\>'s Input types for consumed outputs. For each intra-component call: caller's expected Input type matches callee's Output type. Full exhaustive cross-reference is not required; boundary cross-reference is mandatory.

**Step 5 — Exit condition sufficiency:**
For each task exit condition: can it pass if the FIAO spec is violated? If yes: add a spec compliance item that catches the violation.

**Step 6 — Execution fit:**
Each task section fits within the executor's reliable working context. If no: split into stage documents (see Plan Size Rule).

**Step 7 — Soundness declaration:**
Plan State Header has soundness_mode and soundness_basis filled. `soundness_verified_post_build: false` is a visible open item for every future session.

**Step 8 — Temporal validity:**
Every task's temporal validity block names a specific trigger event, a specific action, and an owner. "Becomes stale when requirements change" is soft language — flag and resolve. `n/a` is valid only for tasks whose output is consumed immediately by T\<n+1\>.

## Parallelism Rule

**Single-executor (default):** Plan Sync run by the executor after each task.

**Multi-agent:**
Plan Owner = the parent/orchestrating session by default. Only the Plan Owner updates FIAO blocks in PLAN_STATE.md, runs Plan Sync, and updates the Plan State Header. Sub-agents report deviations to the Plan Owner before starting their next task. If the Plan Owner session becomes unavailable, all agents stop — the plan resumes in the next session using PLAN_STATE.md for current state. Multi-agent builds without a named Plan Owner are not covered by this standard.

## Plan Change Protocol

When a requirement changes after T1 has started:

1. Check Data Dictionary for any type affected — update entries before any FIAO block
2. Identify all sections in PLAN.md affected
3. Update all affected sections before the next task starts
4. If the change invalidates a completed task's exit condition: re-run it
5. Increment `plan_version` in Plan State Header
6. Append to PLAN_STATE.md Changelog: `- <ISO timestamp> Plan Change v<n>: <one-line description>. Author: <session>.`
7. Re-run Plan Review Gate on affected sections only

A change not logged in the Changelog did not happen.

## Plan Size Rule

Each task section must fit within the executor's reliable working context. Default: 6,000–8,000 tokens per task section. Override: document in Plan State Header (`executor_context`) with justification.

When a plan exceeds the size limit: split into stage documents. Each stage is self-contained — includes relevant Data Dictionary entries, naming conventions, and component specs inline without cross-referencing other stage files.

**Known limitation:** the canonical verification project (echo-system Stage 5) exercises T1 + T2 components, 3+ tasks with dependencies, and one deviation case. For plans with significantly different characteristics (20+ components, pure T3, very large scale), a second walkthrough against a more representative project is recommended but not blocking.

## Plan Closure

When all tasks are complete and verified:

1. Update `soundness_verified_post_build: true` with evidence (test output, manual check)
2. Update `last_completed` to the final task
3. Move both PLAN.md and PLAN_STATE.md to `workspace/plans/CLOSED/<project>_<YYYYMMDD>/`
4. Commit the move

Completed plans are not deleted — they are the permanent design record for the system.

## PLAN_STATE.md Structure

```markdown
# PLAN_STATE.md — <project name>

## Plan State Header
[Section 0 fields]

## Current FIAO Overrides
[Full updated FIAO blocks for functions that deviated — complete blocks, not diffs]

## Discovered Functions
[FIAO blocks for functions discovered during implementation, in component order]

## Deviations
[Deviation entries in task order]

## Changelog
- <ISO timestamp> Plan published v1. Author: <session>.
```

## Model routing for this stage

Per `CLAUDE.md` → Model Default: **Sonnet 5** (`claude-sonnet-5`) is the default for most Plan work — established-domain planning and writing a PLAN.md from an existing design (see `compass:brainstorming`). 

**Escalate to Opus 4.8** (`claude-opus-4-8`) as a sub-agent only when the domain is genuinely novel — no known architecture or pattern exists yet, requiring synthesis rather than transcription of a known design. The Plan stage is explicitly called out in `CLAUDE-DEV.md` Model Usage Policy as the ONE stage where novel-domain work escalates to Opus for thorough exploration. Opus sub-agents are spawned for novel-domain planning only, never for writing an established design into template form.

Most Plan work is transcription of an already-brainstormed design into the Development Plan Standard, which is Sonnet-tier work.

## Next stage

After Plan, before the Plan Review Gate: proceed to `compass:stage-rt-spec` (RT(spec) →
Harden loop) to apply the tier × lens matrix to the specification. Continues until exit
condition holds — all findings Resolved at all severity levels.

Only after RT(spec) exits clean does the Plan Review Gate run (all 8 steps find no
defects). Code does not start until the Gate passes.
