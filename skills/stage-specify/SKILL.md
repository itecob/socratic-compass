---
name: stage-specify
description: Use when moving from a plain-language problem statement (Ideate) to typed interfaces and FIAO blocks, before writing PLAN.md — the Specify build stage
---

# Stage: Specify

Pilot-series port of the "Specify" stage (`CLAUDE-DEV.md` Stage Definitions + Section 3
Data Dictionary + FIAO Block Format). Loads on demand instead of riding along with every
build-mode prompt. See `compass:stage-code` for the sibling skill this stage feeds into.

## Scope

Formal FIAO and Data Dictionary work. Identify all structured types, draft FIAO blocks
for T1/T2 interfaces using available knowledge. Mark each Action step with an epistemic
label. Identify `[speculative]` steps requiring prototype work.

**Output:** typed interfaces and data types.
**Done when:** no T1/T2 interface has an unlabeled Action step and no `[speculative]`
step lacks a prototype plan.
**Does NOT produce:** a full plan document — that's `compass:writing-plans` /
the Plan stage, which embeds this stage's output in its own Section 3 and Section 6.

## Data Dictionary (Section 3)

Every structured type, domain object, and project-specific term referenced in any FIAO
block must have an entry. A FIAO referencing an undefined type is a plan defect
equivalent to soft language.

```
TypeName:
  field_name: type — <what it IS; constraints; who sets it; nested type ref if applicable>
  invariants:
    positive: [must always be true about this type]
    negative: [must never be true about this type]
```

## FIAO Block Format

**T1/T2 components — full format:**

```
Function:               method_name(param: type, param2: type) -> ReturnType
trust_boundary:         true
                        ← include only when this function sits on a trust boundary:
                          receives external input, enforces policy, handles auth/authz.
                          Functions with trust_boundary: true receive full T1 lens
                          treatment in red-teaming regardless of component tier.
                          Omit this line entirely when false — do not write "false".
frozen:                 true
                        ← include only for Section 5 interfaces. Omit elsewhere.
Input:                  param — <what it IS; constraints; caller guarantees;
                                 Data Dictionary type ref if structured>
                        param2 — <same>
Action:                 1. [verified] <exact algorithmic step — not a label>
                        2. [inferred] <exact algorithmic step>
                           // Basis: <analogous system or pattern> → <why it applies here>
                        3. [speculative] TBD — prototype required: <what is unknown>
Output:                 <value> if <condition> | <value> if <condition> |
                        raises <ExactErrorType> if <exact condition>
                        ← every return path named; no omissions
Does NOT:               <explicit non-behaviors the caller might incorrectly assume>
                        Be specific: "Does NOT refresh expiry_ts" not "Does NOT do extra things"
Caller must NOT assume: <specific misuse patterns this spec forbids>
                        Be specific: "True return does NOT imply authorization for any action"
Side effects:           <DB tables written, events emitted, caches invalidated, files written>
                        ← omit this line entirely for pure functions; never write "none"
```

**T3 components:** typed signature + one-line behavior description only.

### Epistemic labels — required on every Action step

| Label | Meaning |
|---|---|
| `[verified]` | Confirmed against a prototype, running system, or empirical test. No reasoning chain required. Becomes the default after post-build verification. |
| `[asserted]` | Plan author states this is correct based on knowledge or belief; not yet empirically tested. Post-build verification note required — must appear as a deviation entry in `PLAN_STATE.md` after the task containing this function completes, updating the step's label to `[verified]`. An `[asserted]` step not relabeled after its task completes is a plan defect equivalent to an open TBD. |
| `[inferred]` | Derived by reasoning from an analogous system or known pattern. Inline reasoning chain required: `// Basis: <analogous system/pattern> → <why it applies here>`. The `//` prefix is a traceability annotation, not a code comment — required regardless of surrounding document type. |
| `[speculative]` | Uncertain. Blocks task promotion. Must be resolved before the function is promoted. |

Omitting a label is not permitted — an unlabeled Action step is treated as
`[speculative]` and blocks promotion. Lens 13 (Ambiguity, see `compass:adversarial-review`)
applies to every Action step during RT(spec) regardless of epistemic label.

**Superseded syntax — do not use:** bare `TBD — prototype required: <what is unknown>`
without the `[speculative]` label; `// Soundness basis: <reasoning chain>` instead of
the `[inferred]` basis-comment format. (The Plan State Header `soundness_basis` field is
a separate, plan-level field and is unchanged by this — it documents the overall
soundness basis, not individual steps.)

`TBD` Action lines block task promotion — must be resolved from prototype findings
before the function is promoted. Outstanding TBD lines = incomplete plan.

### Soft language — NEVER allowed in any FIAO line

`appropriately`, `as needed`, `handle`, `manage`, `process`, `validate`, `etc.`,
`standard approach`, `reasonable`, `similar`, `relevant`, `necessary`, `latest`,
`active`, `current`, `default`, `and so on`, `typical`, `normal`, `usually`, `generally`

Extend this list with domain-specific ambiguous terms before the soft language audit.
This applies to every FIAO line — Action, Output, Does NOT, Caller must NOT assume,
Side effects.

## Model routing for this stage

Per `CLAUDE.md` → Model Default: **Sonnet 5** for established-domain specify work.
Escalate to an **Opus 4.8** sub-agent only if the domain is genuinely novel — no known
architecture or pattern exists yet, requiring synthesis rather than transcription of a
known design. Most Specify work is transcription of an already-brainstormed design
(see `compass:brainstorming`) into typed form, which is Sonnet-tier.

## Next stage

Once every T1/T2 interface has fully labeled FIAO blocks and Data Dictionary entries
exist for every referenced type: proceed to the Plan stage (write `PLAN.md` — Specify's
output is embedded in its Section 3 and Section 6).
