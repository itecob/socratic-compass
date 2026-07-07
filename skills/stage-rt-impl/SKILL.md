---
name: stage-rt-impl
description: Use when red-teaming the implementation (after Code, before Test suite) — the RT(impl) build stage
---

# Stage: RT(impl) → Harden loop

Pilot-series port of the "RT(impl)" stage (`CLAUDE-DEV.md` Red Team Matrix + RT Execution Rules). Applies the tier × lens matrix to code artifacts, with mandatory SAST scan and adversarial code review, looping until clean.

## Scope

Apply tier × lens matrix to the implementation (code). Continue iterating rounds until the exit condition holds: all findings at all severity levels (P0, P1, P2, P3) are Resolved; SAST scan exits 0 per the tool declared in PLAN_STATE.md; all "Does NOT" lines confirmed absent in code; both Gemini CLI and Codex CLI verification passes find zero unresolved findings.

**Done when:** Resolution Threshold condition is met (see Shared mechanics section) — every finding for every applicable lens at every severity level is demonstrably eliminated by a code change in the commit being promoted.

**Harden:** After each red-team round completes, make a single combined edit pass to the code addressing all triaged findings. Do not apply findings piecemeal or sequentially. Do not run another model on a partially-hardened version.

**Loop:** After each harden, run the next red-team round (if any) in parallel on the fully-hardened version. Stop when the union of all sub-agents' findings contains zero unresolved P0 or P1 items.

## SAST requirement

Static analysis is mandatory before code is promoted.

**For Python:**
```
bandit -r <package_dir> -ll
```
Must exit 0 (no HIGH or CRITICAL findings). Bandit HIGH/CRITICAL findings map to P0/P1.

**For JavaScript/TypeScript:**
```
npm audit --audit-level=high
```
Must exit 0. npm audit high/critical findings map to P0/P1.

**For other languages:**
A SAST tool appropriate to the language must be declared in Section 0a (ENVIRONMENT PREREQUISITES) before the plan is published, with its exact invocation command and explicit severity mapping to P0/P1. A plan with no SAST tool declared for a non-Python/non-JS component is incomplete and blocks promotion.

## RT(impl) — target and application details

**Applied at:** after Code, looping until clean, before pre-staging Test suite.

**Techniques:**
- Tier × lens matrix applied to the code
- SAST scan (static analysis) required — exits 0 per the tool and invocation declared in Section 0a (bandit HIGH/CRITICAL = P0/P1 for Python; npm audit high/critical = P0/P1 for JS)
- Adversarial code review — reviewer applies lenses as an attacker, not a code quality reviewer; cross-check every FIAO "Does NOT" line against the actual implementation

**Exit condition:** all findings Resolved at all severity levels; SAST scan exits 0 per the tool and invocation declared in Section 0a (bandit for Python; npm audit for JS); all "Does NOT" behaviors confirmed absent in code; Gemini CLI and Codex CLI verification passes both find zero unresolved findings (see RT(impl) Verification Passes below).

**Does NOT:** examine the running system; re-examine the spec (spec is locked at this point unless a Plan Change is triggered).

## RT(impl) Verification Passes

**Mandatory after hardening, before promotion:**

After completing RT(impl) hardening, run two independent verification passes in parallel per Rule 7 of the RT Execution Rules (see Shared mechanics section):

1. Gemini CLI pass:
   ```
   gemini -m "gemini-2.5-flash" -p "<objective rt prompt covering all applicable lenses>"
   ```

2. Codex CLI pass:
   ```
   codex exec --dangerously-bypass-approvals-and-sandbox - < <rt_prompt_file>
   ```

The RT prompt must be objective — no steering toward or away from findings. Any finding raised by either tool must be resolved before RT(impl) is declared clean. A finding may be challenged, but the challenge must be documented with explicit reasoning before the finding is closed. Both passes must find zero unresolved findings.

## Shared mechanics — cross-reference note

Tier classification, the 13 lens definitions, the tier × lens matrix, the Resolution Threshold (every severity P0-P3 must be resolved, no "accepted-with-risk" exception), and RT Execution Rules 1-7 are identical to RT(spec). See `compass:stage-rt-spec` for all of these definitions and rules — do not duplicate them here.

The only RT(impl)-specific mechanics are:
- SAST scan requirement (severity mapping per language)
- "Does NOT" behavior cross-check against actual code
- Verification pass invocations (Gemini CLI + Codex CLI)

## Model routing for this stage

Per CLAUDE-DEV.md's Model Usage Policy Rule 4 (Sub-agent model selection for RT): iterative RT rounds (impl) run on a Sonnet sub-agent; the final adversarial sweep ('what did we miss') runs on an Opus sub-agent, one pass; cross-reference validation against real source runs on an Opus sub-agent. External CLI tool models (Gemini, Codex) are fixed by the tool itself and not subject to this policy. Per Rule 1, sub-agent delegation for RT rounds is mandatory — do not red-team from the main session's own context.

See `compass:stage-rt-spec` § Model routing for this stage for complete details.

## Next stage

After the RT(impl) loop reaches its exit condition — every finding at every severity (P0, P1, P2, P3) is Resolved; "accepted-with-risk" is not available, there are no exceptions — proceed to the pre-staging Test suite (unit, integration, property-based tests).

**Note:** The Test suite stage is not yet a ported Compass skill. Consult `CLAUDE-DEV.md` Test stage definition for current requirements.
