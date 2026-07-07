---
name: stage-rt-spec
description: Use when red-teaming the specification (after Plan, before Plan Review Gate) — the RT(spec) build stage
---

# Stage: RT(spec) → Harden loop

Pilot-series port of the "RT(spec)" stage (`CLAUDE-DEV.md` Red Team Matrix + RT Execution Rules). Loads on demand instead of riding along with every build-mode prompt.

## Scope

Apply tier × lens matrix to the specification document. Continue iterating rounds until the exit condition holds: all findings at all severity levels (P0, P1, P2, P3) are Resolved.

**Done when:** Resolution Threshold condition is met — every finding for every applicable lens at every severity level is demonstrably eliminated by a code or design change in the commit being promoted.

**Harden:** After each red-team round completes, make a single combined edit pass to the specification addressing all triaged findings. Do not apply findings piecemeal or sequentially. Do not run another model on a partially-hardened version.

**Loop:** After each harden, run the next red-team round (if any) in parallel on the fully-hardened version. Stop when the union of all sub-agents' findings contains zero unresolved P0 or P1 items.

## Tier Classification

Assign before red-teaming begins. Take the highest matching tier. Never argue a component down to reduce scope.

| Tier | Assign when the component… |
|---|---|
| **T1 — High** | Handles auth, authorization, or session state; sits on a trust boundary (external network, inter-service API, webhook, user input entry point); writes to an audit log or enforces a security invariant; processes identity, payment, or access-control data; is the sole enforcement point for any policy |
| **T2 — Medium** | Is an internal API or controller with side effects (writes to DB, sends messages, modifies shared state); orchestrates other components; is a data pipeline that transforms or routes records; has retry or queue logic |
| **T3 — Low** | Is a pure function, utility helper, or config parser with no side effects; does not call external services; output is only consumed locally within the same component |

## Lens Definitions

| # | Lens | The question you are answering |
|---|---|---|
| 1 | Input & boundary | What breaks if input is malformed, empty, oversized, injected, or at edge values? |
| 2 | State & concurrency | What breaks under concurrent access, partial writes, interrupted transactions, or dirty state? |
| 3 | Trust & authorization | What can a caller do that they shouldn't? Can privilege be escalated or confused-deputy'd? |
| **4** | **Assumptions** | **What does this code silently assume? (file exists, caller is honest, order is guaranteed, network is up) — which of those can be false?** |
| 5 | Dependency failure | What if a downstream service is slow, down, returns garbage, or is compromised? |
| **6** | **Second-order & cascade** | **What does this component *enable* that wasn't intended? What emergent behavior comes from composing it with other components?** |
| 7 | Resource exhaustion | Can this be made to consume unbounded CPU, memory, disk, file descriptors, or connections? |
| 8 | Operational | What happens during deploy, rollback, partial upgrade, config change, or split-brain? |
| 9 | Data integrity & audit | Can data be tampered, replayed, or forged? Can the audit trail be bypassed or back-filled? |
| 10 | Business logic | Does the logic match the intent? Can valid operations be combined in ways that violate invariants? |
| 11 | Silent failure | Can failures happen with no observable signal — swallowed exceptions, missing events, wrong-but-no-error? |
| 12 | Threat model | Who would want to abuse this, what's their capability, and what's the blast radius if they succeed? |
| **13** | **Ambiguity** | **What is ambiguous enough that an LLM executor would fill the gap with a plausible-but-wrong pattern? What behavior is implied but not stated? What terms require inference to interpret?** |

## Tier × Lens Matrix

`M` = Mandatory. `-` = Not required (may be applied at discretion).

| Lens | T1 High | T2 Medium | T3 Low |
|---|---|---|---|
| 1 Input & boundary | M | M | M |
| 2 State & concurrency | M | M | - |
| 3 Trust & authorization | M | - | - |
| **4 Assumptions** | **M** | **M** | **M** |
| 5 Dependency failure | M | M | - |
| **6 Second-order & cascade** | **M** | **M** | **M** |
| 7 Resource exhaustion | M | M | - |
| 8 Operational | M | M | - |
| 9 Data integrity & audit | M | - | - |
| 10 Business logic | M | M | - |
| 11 Silent failure | M | M | - |
| 12 Threat model | M | - | - |
| **13 Ambiguity** | **M** | **M** | **M** |

T1: all 13 lenses. T2: 10 lenses (1, 2, 4, 5, 6, 7, 8, 10, 11, 13). T3: 4 lenses (1, 4, 6, 13).

## Resolution Threshold

A red-team round is **clean** when every finding for every applicable lens at every severity level (P0, P1, P2, P3) is **Resolved**. The "repeat until clean" loop in the phase table does not exit until this condition holds.

**Resolved** — A code or design change demonstrably eliminates the attack path. The change must exist in the commit being promoted. "Documented for later" is not resolved. "Unlikely in practice" is not resolved.

**"Accepted-with-risk" is not available.** Every finding at every severity level must be resolved before promotion. Low-severity findings that are left unresolved compound into blocking problems at later stages. There are no exceptions to this rule.

| Severity | Must be resolved before promotion? |
|---|---|
| P0 — Critical | Yes |
| P1 — High | Yes |
| P2 — Medium | Yes |
| P3 — Low | Yes |

## Red-Team Findings → Issue Files

Every finding not resolved in the same working session becomes an issue file. Use the standard Issue Resolution Process with these additions to the header:

```
red_team_tier: T1|T2|T3
red_team_lens: <number and name>
```

All unresolved findings at all severity levels block promotion. No finding may carry over to the next stage without being resolved.

## Final Adversarial Sweep

The Opus final sweep ("what did we miss") applies the full T1 lens set (all 13 lenses) regardless of the component's assigned tier — it is a completeness check, not a proportional one.

## RT(spec) — target and application details

**Applied at:** after Plan, looping until clean, before Plan Review Gate.

**Techniques:** 
- tier × lens matrix applied to the plan text
- soft language audit
- Responsibility Map review
- FIAO completeness check
- Lens 13 (Ambiguity) applied to every Action step regardless of epistemic label — ambiguity is orthogonal to correctness; a `[verified]` step can still be ambiguously worded.

**Exit condition:** same as Resolution Threshold above — all findings Resolved at all severity levels.

**Does NOT:** examine code (none exists yet); check runtime behavior.

## RT Execution Rules

**NOTE:** These rules are shared by every RT-family stage (RT(spec), RT(impl), RT(system), RT(operational)). Future stage skills for those should cross-reference this section rather than duplicate it.

### Rule 1 — Sub-agent delegation is mandatory.

Every red-team activity MUST be executed via a sub-agent with a self-contained prompt, NOT inline in the main conversation. The main session's role during RT is limited to launching sub-agents, triaging findings returned by sub-agents, and applying fixes. Inline RT in the main chat contaminates the analysis with conversation context (prior framings, the author's mental model of what the code "should" do) and produces less objective findings.

**Activities that count as RT under this rule:**
- Applying the tier × lens matrix to a plan, code, or running system
- Any "adversarial review" or "what did we miss" pass
- Any cross-reference of a spec against a dependency's actual source
- The final adversarial sweep — even though it is a completeness check

**Activities that do NOT count (may be done in main session):**
- Triaging findings returned by sub-agents
- Applying fixes in response to findings
- Plan Review Gate (structured review, not adversarial)
- Non-adversarial code review or PR review

### Rule 2 — External CLI tool coverage is mandatory.

Every RT round MUST include passes by BOTH Gemini CLI and Codex CLI:

1. Gemini CLI: `gemini -m "gemini-2.5-flash" -p "<objective rt prompt>"`
2. Codex CLI: `codex exec --dangerously-bypass-approvals-and-sandbox - < <rt_prompt_file>`

Both tools must produce findings on the same artifact before the round is complete. This cross-checks each tool's blind spots. The CLI tools are invoked BY sub-agents (per Rule 1), not directly by the main session.

### Rule 3 — Fallback when CLI tools are unavailable — 100% documentation.

If either Gemini CLI or Codex CLI is unavailable (out of quota, credentials expired, tool broken, network failure, any other reason), the RT round may proceed with whatever is available. The fallback path is:
- Both unavailable → Claude Code sub-agents alone
- Exactly one unavailable → the available CLI + Claude Code sub-agents (do not skip the available CLI)
- Both available → both, per Rule 2 (the default, not a fallback)

**Every fallback case MUST be documented in PLAN_STATE.md under `## Deviations` with these fields — no silent fallback, ever:**
- Which tools were unavailable (Gemini, Codex, or both)
- Why each was unavailable (observed error message, quota status, or connectivity check result)
- Timestamp of attempted invocation (ISO 8601)
- Diagnostic step taken to confirm unavailability (e.g., `gemini --help` exited 0 but `gemini -p test` returned quota error)
- Whether the root cause is known and being pursued, or unknown
- Whether the round will be re-run when the tool becomes available
- The RT round's identifier (RT(spec) round N on artifact X)

Documenting single-CLI fallbacks (not just both-unavailable) is mandatory because every RT round's provenance must be reconstructable after the fact. A round that silently used only Codex because Gemini was quota-blocked is indistinguishable from a round that was supposed to use only Codex — without the deviation entry, auditability is broken.

If the unavailability reason is known and a resolution is available (expired credentials → refresh, misconfigured path → correct it, wrong model name → fix it), it is appropriate to attempt the resolution inline before falling back. Document both the attempt and its outcome in the deviation entry.

If the unavailability reason is unknown and cannot be diagnosed in a reasonable time budget, the RT round proceeds with the fallback path and the deviation entry records "root cause unknown — fallback accepted, re-run when resolved."

### Rule 4 — Sub-agent model selection for RT.

Follow the Model Usage Policy table. For RT specifically:
- Iterative RT rounds (spec, impl, system, operational): Sonnet sub-agent
- Final adversarial sweep ("what did we miss"): Opus sub-agent, one pass
- Cross-reference validation against real source: Opus sub-agent

External CLI tool models are fixed by the tool and not subject to the policy.

### Rule 5 — Sub-agent prompts must be self-contained.

A sub-agent starts with fresh context. Its prompt must include all files to read (absolute paths), the task stated explicitly, the lens set, the output format, any known-resolved items to exclude, severity rubric, and explicit read-only constraints when the task is analysis-not-fix.

### Rule 6 — RT findings flow through sub-agents.

The main session never hand-authors findings during an RT round. When the main session notices something during triage that the sub-agent missed, the correct response is to launch another sub-agent focused on that specific concern — not to add a finding manually.

### Rule 7 — Parallel model execution, single harden per round.

Within a single RT round, all applicable sub-agents run on the SAME artifact version SIMULTANEOUSLY. Findings are collected from every sub-agent, merged into one triage pass, and the artifact is hardened exactly once against the union. The next round (if any) runs on the hardened version, again with all sub-agents in parallel.

Do NOT run one model, harden, then run the next model on the hardened version. The sequential pattern is what produced the recursive failure observed in the echo-memory-distro remediation (2026-04): each inter-round harden introduced new defects, and no model ever reviewed the harden itself before the next round started. Parallel execution eliminates this by auditing the same artifact from multiple independent perspectives before any harden touches it.

**Mechanics per round:**

1. **Launch:** start all applicable sub-agents at once (per Rule 1), each with its own self-contained prompt (per Rule 5). The standard parallel batch is:
   - Gemini CLI sub-agent (per Rule 2)
   - Codex CLI sub-agent (per Rule 2)
   - Claude Code sub-agent (model per Rule 4)

   All three see the same artifact at the same git commit. Fewer sub-agents may run if CLIs are unavailable — see Rule 3 and the degraded execution note below.

2. **Collect:** wait for all sub-agents to return. If one fails or times out, proceed with the others — do NOT retry the failed sub-agent synchronously (it delays the whole round). Document the failure in PLAN_STATE.md deviations per Rule 3.

3. **Triage** (main session): read the union of findings. For each finding:
   - Classify TP (true positive) / FP (false positive) / duplicate
   - Assign severity if not already assigned
   - Cross-reference against findings from other sub-agents — defects flagged by multiple independent sub-agents are high-confidence; defects flagged by only one are model-specific (still addressed, but the uniqueness is useful forensic signal)
   - Group findings that share a single remediation

4. **Harden:** edit the artifact ONCE against the triaged findings. Validate the harden with whatever mechanical checks apply (`scripts/validate_*`, gate scripts, etc.). Hardening happens in the main session; it is not an RT activity (see Rule 1 exclusions).

5. **Advance:** bump artifact version, decide whether another round is needed per the termination rule below, update PLAN_STATE.md.

**Termination rule — when to stop iterating rounds:**

A round is clean when the union of all sub-agents' findings contains zero unresolved P0 or P1 items. P2 and P3 findings that remain must be accepted-with-authorization per the Red Team Matrix Resolution Threshold (explicit user sign-off, documented justification, blast radius, and remediation plan — they do not silently pass).

Three outcomes of triage:
- **Round N found only P2/P3, all acceptable** → STOP, artifact proceeds
- **Round N found any P0/P1** → HARDEN, run round N+1 in parallel
- **Round N+1 found the same defects round N found (no progress)** → ESCALATE. The harden is not converging. Stop iterating and investigate why — likely the harden is missing the root cause, or the finding was misunderstood in triage, or the artifact has a structural flaw that cannot be patched.

**Degraded parallel execution:**

When fewer than three sub-agents are available (Gemini quota exhausted, Codex broken, any other Rule 3 condition), the round proceeds with whatever is available. The parallel methodology still applies: launch all available sub-agents simultaneously, triage the union, harden once. Document the reduced coverage per Rule 3.

A round with zero sub-agents available cannot proceed. If all models are unavailable simultaneously, the RT round is blocked and the build stops until at least one sub-agent becomes available.

**Historical context (not enforcement language).**
The echo-memory-distro remediation (2026-04) exhibited a recursive failure pattern where each plan version corrected the prior version while preserving the same class of defects (hallucinated symbols, invented enum values). The root cause was that RT and authoring happened in the same session with the same mental model. Sub-agent delegation and external CLI coverage break the contamination loop.

## Model routing for this stage

Per CLAUDE-DEV.md's Model Usage Policy Rule 4 (Sub-agent model selection for RT): iterative RT rounds (spec/impl/system/operational) run on a Sonnet sub-agent; the final adversarial sweep ('what did we miss') runs on an Opus sub-agent, one pass; cross-reference validation against real source runs on an Opus sub-agent. External CLI tool models are fixed by the tool itself and not subject to this policy. Per Rule 1, sub-agent delegation for RT rounds is mandatory — do not red-team from the main session's own context.

## Next stage

After the RT(spec) loop reaches its exit condition — every finding at every severity (P0, P1, P2, P3) is Resolved; "accepted-with-risk" is not available, there are no exceptions — proceed to the Plan Review Gate. Cross-reference: see `compass:stage-plan` § Plan Review Gate for the 8-step gate content (it is already ported there; do not duplicate it here).
