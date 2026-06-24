# Compass Plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `compass:subagent-driven-development` (recommended) or `compass:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a standalone plugin (`compass`) that ships eight new strategic-programming skills, fourteen absorbed Superpowers workflow skills, the `.architecture/` memory mechanism, optional Claude Code hooks, and dual-target packaging for Cowork and Claude Code.

**Architecture:** Single source tree, two build scripts (Cowork `.plugin` archive vs Claude Code plugin directory). All skills under `compass:` namespace. Persistent state lives in a per-project `.architecture/` directory the plugin reads and writes. The plugin uses its own architecture mechanism on itself.

**Tech Stack:** Markdown (SKILL.md files), Bash (hooks and scripts), zip (packaging). No runtime code; the plugin is documentation + executable hook scripts.

**Source for absorbed skills:** Available locally at the installed Superpowers plugin directory (`~/.config/claude/plugins/superpowers/skills/<name>/`) on a machine with Superpowers installed, or from upstream (currently bundled in this session at `C:\Users\kevin\AppData\Roaming\Claude\local-agent-mode-sessions\<session>\rpm\plugin_01RNnvAWwvBz3sHJnAxQudbM\skills\<name>\`). The implementer should resolve `$SP_SRC` at start to whichever path exists.

---

## Pre-flight

- [ ] **Step 0.1: Resolve Superpowers source path**

```bash
# Try several known locations
for candidate in \
  "$HOME/.config/claude/plugins/superpowers/skills" \
  "$HOME/.claude/plugins/superpowers/skills" \
  "$HOME/Library/Application Support/Claude/plugins/superpowers/skills" \
  ; do
  if [ -d "$candidate" ]; then
    export SP_SRC="$candidate"
    break
  fi
done
echo "SP_SRC=$SP_SRC"
[ -n "$SP_SRC" ] || { echo "Cannot find Superpowers source; clone upstream and set SP_SRC manually"; exit 1; }
ls "$SP_SRC" | head
```

Expected: a path is printed and a non-empty directory listing is shown.

- [ ] **Step 0.2: Create plugin worktree**

REQUIRED SUB-SKILL: Use `compass:using-git-worktrees`. (If running this plan inside a fresh empty directory rather than an existing repo, instead initialize: `git init compass && cd compass`.)

---

## Phase 1: Scaffolding (Tasks 1–4)

### Task 1: Directory skeleton

**Files:**
- Create: `skills/`, `templates/architecture/decisions/`, `templates/architecture/session-handoffs/`, `hooks/`, `scripts/`, `.architecture/decisions/`, `.architecture/session-handoffs/`

- [ ] **Step 1.1: Create directories**

```bash
mkdir -p skills templates/architecture/decisions templates/architecture/session-handoffs \
         templates/architecture/interviews \
         hooks scripts .architecture/decisions .architecture/session-handoffs \
         .architecture/interviews
```

- [ ] **Step 1.2: Verify**

```bash
find . -type d -not -path './.git*' | sort
```

Expected: lists the directories above.

- [ ] **Step 1.3: Commit**

```bash
git add -A && git commit -m "scaffold: initial directory layout"
```

### Task 2: Plugin manifest

**Files:** Create `plugin.json`

- [ ] **Step 2.1: Write manifest**

```json
{
  "name": "compass",
  "version": "0.1.0",
  "description": "Strategic-programming skills with persistent architectural memory. Closes the gaps Superpowers leaves: premise-check before planning, design-archeology before changing code, tradeoff-matrix during design, adversarial-review of plans, an .architecture/ directory for cross-session memory, session handoffs, invariant scanning, and a complexity budget.",
  "author": "Compass",
  "license": "MIT",
  "skills_dir": "skills",
  "hooks_dir": "hooks"
}
```

- [ ] **Step 2.2: Commit**

```bash
git add plugin.json && git commit -m "scaffold: plugin manifest"
```

### Task 3: README skeleton

**Files:** Create `README.md`

- [ ] **Step 3.1: Write README**

````markdown
# Compass

Strategic-programming skills + persistent architectural memory for Claude Code and Cowork.

## What it does

Eight skills that fire at the points the during-task loop does not cover:

- **premise-check** — challenge the request before any planning
- **design-archeology** — read existing code for implicit contracts before changing it
- **tradeoff-matrix** — force named-axis comparison of at least three designs
- **adversarial-review** — spawn a subagent to attack the plan
- **architecture-journal** — manage a per-project `.architecture/` directory (ADRs, invariants, conventions, debt)
- **session-handoff** — structured end-of-session note for the next session
- **invariant-scan** — verify documented invariants still hold
- **complexity-budget** — track and surface accumulated shortcuts

Plus fourteen workflow skills absorbed from Superpowers so the plugin works standalone.

## Install

**Cowork:** drag `compass.plugin` onto the Cowork window.

**Claude Code:** `claude plugins install ./compass` (or whatever your platform's install command is).

## First-time setup in a project

```bash
bash <path-to-plugin>/scripts/bootstrap-architecture.sh .
```

This copies `.architecture/` templates into your project. Edit them as you go.

## Coexistence with Superpowers

If you have both Superpowers and Compass installed, fourteen skill names collide. Uninstall one to avoid selection ambiguity. The new eight strategic skills are unique to this plugin.

## Attribution

Fourteen of the twenty-two skills in this plugin are adapted from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin (`brainstorming`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `requesting-code-review`, `receiving-code-review`, `dispatching-parallel-agents`, `using-git-worktrees`, `finishing-a-development-branch`, `writing-skills`, and `using-compass` — the last renamed from Superpowers' `using-superpowers`). Cross-reference prefixes and prose mentions have been rewritten to match the Compass namespace, but the underlying TDD-for-documentation discipline, rationalization tables, red-flag patterns, and workflow choreography all originated with the Superpowers project. Each absorbed `SKILL.md` carries a footer citing this source. The eight new strategic skills (`premise-check`, `design-archeology`, `tradeoff-matrix`, `adversarial-review`, `architecture-journal`, `session-handoff`, `invariant-scan`, `complexity-budget`) are original to Compass.

## Skill reference

See `skills/<name>/SKILL.md` for each. Start with `using-compass`.
````

- [ ] **Step 3.2: Commit**

```bash
git add README.md && git commit -m "scaffold: README"
```

### Task 4: CHANGELOG

**Files:** Create `CHANGELOG.md`

- [ ] **Step 4.1: Write CHANGELOG**

```markdown
# Changelog

## 0.1.0 (unreleased)

Initial release.

- Eight new strategic-programming skills.
- Fourteen workflow skills absorbed from Superpowers (verbatim, with namespace rewrites).
- `.architecture/` directory mechanism with bootstrap script.
- Optional Claude Code hooks for SessionStart, PreToolUse, SessionEnd.
- Dual packaging: `.plugin` for Cowork, plugin directory for Claude Code.
```

- [ ] **Step 4.2: Commit**

```bash
git add CHANGELOG.md && git commit -m "scaffold: CHANGELOG"
```

---

## Phase 2: Architecture Template (Tasks 5–9)

### Task 5: Template `manifest.md`

**Files:** Create `templates/architecture/manifest.md`

- [ ] **Step 5.1: Write manifest template**

```markdown
# Architecture Manifest

This directory is the project's architectural memory. Claude reads it at session start; humans read it at onboarding.

## Contents

- `decisions/` — ADRs, one per file, sequentially numbered.
- `invariants.md` — what must remain true. Each invariant has an ID and a verification command.
- `conventions.md` — non-obvious idioms a newcomer would not infer from the code.
- `debt-log.md` — known shortcuts, where they will bite, when to revisit.
- `interviews/` — socratic-interview transcripts. One per planning session. Authored by the human, hardened by the agent.
- `session-handoffs/` — time-ordered notes written at the end of each session by `compass:session-handoff`.

## How to use

**Starting a session:** invoke `compass:architecture-journal`. It reads this manifest and loads relevant content.

**During a session:** when making a structural decision, propose an ADR. When establishing an invariant, add to `invariants.md`. When taking a shortcut, log it via `compass:complexity-budget`.

**Ending a session:** invoke `compass:session-handoff`.

## Top-level summary

(Replace this with one paragraph describing the system's shape: major components, their boundaries, how data flows. Update only when the shape changes.)
```

- [ ] **Step 5.2: Commit**

```bash
git add templates/architecture/manifest.md && git commit -m "templates: architecture manifest"
```

### Task 6: Template `invariants.md`

**Files:** Create `templates/architecture/invariants.md`

- [ ] **Step 6.1: Write invariants template**

```markdown
# Invariants

What must remain true across changes. Each invariant has an ID, the ADR that established it, a verification command, and an on-failure note.

## INV-001: <example — replace>

**Established by:** ADR 0001
**Verification:** `<exact shell command>`
**Expected:** <what success looks like>
**On failure:** <what to investigate, which ADR to revisit>

<!-- Add new invariants below. Never renumber. -->
```

- [ ] **Step 6.2: Commit**

```bash
git add templates/architecture/invariants.md && git commit -m "templates: invariants"
```

### Task 7: Template `conventions.md` and `debt-log.md`

- [ ] **Step 7.1: Write conventions template**

File: `templates/architecture/conventions.md`

```markdown
# Conventions

Non-obvious idioms. Things that newcomers will not infer from reading the code.

## C-001: <example — replace>

<Short statement of the convention. Why it exists. Where it shows up.>

<!-- Add new conventions below. Never renumber. -->
```

- [ ] **Step 7.2: Write debt-log template**

File: `templates/architecture/debt-log.md`

```markdown
# Debt Log

Known shortcuts. Each entry has files affected, what was deferred, why, when it will bite, and cost-to-fix (S/M/L/XL).

## DEBT-001: <example — replace>

**Files:** `path/to/file.ts:123-145`
**Deferred:** <what was not done>
**Reason:** <why deferred>
**Will bite when:** <trigger condition>
**Cost to fix:** S
**Logged:** YYYY-MM-DD

<!-- Add new entries below. Never renumber. -->
```

- [ ] **Step 7.3: Commit**

```bash
git add templates/architecture/conventions.md templates/architecture/debt-log.md
git commit -m "templates: conventions and debt-log"
```

### Task 8: Template ADR example

**Files:** Create `templates/architecture/decisions/0001-example.md`

- [ ] **Step 8.1: Write example ADR**

```markdown
# ADR 0001: Example decision

**Status:** accepted
**Date:** 2026-06-24
**Context:** Every architecture directory needs at least one ADR so newcomers see the format. Delete this file when you have a real one.
**Decision:** Adopt the ADR format described in `templates/architecture/manifest.md`.
**Consequences:** Easier — structural decisions become discoverable. Harder — requires the discipline to write one.
**Alternatives considered:** Free-form decision log (rejected: not searchable). Spreadsheet (rejected: not greppable).
**Invariants this creates:** —
```

- [ ] **Step 8.2: Commit**

```bash
git add templates/architecture/decisions/0001-example.md && git commit -m "templates: example ADR"
```

### Task 9: Bootstrap script

**Files:** Create `scripts/bootstrap-architecture.sh`

- [ ] **Step 9.1: Write script**

```bash
#!/usr/bin/env bash
# Copies the .architecture/ template into a target project.
set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../templates/architecture"

if [ -e "$TARGET/.architecture" ]; then
  echo "$TARGET/.architecture already exists; refusing to overwrite." >&2
  exit 1
fi

mkdir -p "$TARGET/.architecture"
cp -r "$SRC/." "$TARGET/.architecture/"

echo "Created $TARGET/.architecture"
echo "Edit manifest.md, invariants.md, conventions.md, debt-log.md as your project grows."
echo "Run compass:architecture-journal at session start."
```

- [ ] **Step 9.2: Make executable and verify**

```bash
chmod +x scripts/bootstrap-architecture.sh
# Dry-run smoke test in /tmp
TEST_DIR=$(mktemp -d)
bash scripts/bootstrap-architecture.sh "$TEST_DIR"
ls "$TEST_DIR/.architecture"
rm -rf "$TEST_DIR"
```

Expected: directory listing shows `manifest.md`, `invariants.md`, `conventions.md`, `debt-log.md`, `decisions/`, `session-handoffs/`.

- [ ] **Step 9.3: Commit**

```bash
git add scripts/bootstrap-architecture.sh && git commit -m "scripts: bootstrap-architecture"
```

---

## Phase 3: The Nine New Skills (Tasks 9a, 10–17)

For each task: create `skills/<name>/SKILL.md` with the exact content given. Commit after each.

### Task 9a: `socratic-interview`

**Files:** Create `skills/socratic-interview/SKILL.md`

- [ ] **Step 9a.1: Write SKILL.md**

```markdown
---
name: socratic-interview
description: Use first on any non-trivial request, before any other planning skill - the agent conducts a structured one-question-at-a-time interview that probes the human's reasoning for gaps until the agent has no further substantive objection, producing a transcript authored by the human
---

# Socratic Interview

## Overview

A request is a thought, not yet a plan. Most thoughts have gaps. The fastest way to find the gaps is for the agent to ask one specific challenge at a time and require the human to defend their reasoning. The resulting transcript is authored by the human, hardened by the agent's pressure. This keeps the human in the driver's seat where the cognitive work belongs.

**Core principle:** The human's reasoning is the source material. The agent's job is to find gaps, not to fill them.

**Violating the letter of this skill is violating the spirit of this skill.**

## When to Use

**Always first, before:**
- `compass:premise-check`
- `compass:design-archeology`
- `compass:brainstorming`
- Any planning skill

**Skip when:**
- The task is trivial and fully reversible (rename a variable, fix a typo).
- The human has explicitly opted out for this specific task. The opt-out is per-task, never per-session.

## The Iron Rules

1. **One question at a time.** Multi-question dumps let the human cherry-pick. Ask one. Wait. Read. Ask the next.
2. **Each question targets a specific gap.** Not a checklist. The agent must be able to point to the exact statement or omission the question challenges.
3. **The agent must hold a hypothesis.** Before asking, the agent must know what answer would change its view. If it does not, the question is fishing — drop it.
4. **Challenge reasoning, never identity.** "Why this rather than X?" — not "Do you really know what you're doing?"
5. **Terminate on convergence, not on count.** The interview ends when the agent has no further substantive objection. No N-question quota.
6. **No proposing solutions.** This is interview, not brainstorming. Surface gaps; the human decides whether to fill them.

## Process

### 1. Read the request
Resist the urge to start asking immediately. First, identify what the human has committed to and what they have left unsaid.

### 2. Ask the first challenge
Target the most load-bearing assumption — the one whose falsity would most change the recommended approach. One question. Wait.

### 3. Read the answer
Look for: restatement-of-the-request instead of an answer (human did not engage); new assumption introduced by the answer; tension with something the human said earlier; confidence not matching the evidence.

### 4. Ask the next challenge
Derived from the gap in the previous answer. Reference the human's own words: "You said X, but Y suggests..."

### 5. Loop
Continue until you cannot find another substantive gap. Be honest with yourself — if you are asking questions for the sake of asking, stop.

### 6. Produce the transcript
At end, write the transcript to `.architecture/interviews/YYYY-MM-DD-HHMM.md` with these sections:

- **Problem statement (in the human's words):** quote what the human said the task is, after the interview.
- **Constraints the human committed to:** numbered list.
- **Decisions the human made during the interview:** numbered list.
- **Open questions the human deferred:** numbered list.
- **Gaps the agent attempted:** numbered list — for each, the gap the agent saw, the question asked, and the human's response in summary.
- **Agent's final assessment:** "I have no further substantive objection" or "I still hold the following objections; we proceed knowing them: ...".

### 7. Hand off to premise-check
`compass:premise-check` now operates as a summarizer over the interview transcript, not a generator.

## Red Flags - STOP

- Asking three questions in one message.
- Asking a question without being able to name the specific gap it targets.
- Asking a question whose answer would not change your view.
- Proposing a solution in the question ("have you considered X?").
- Continuing past convergence because "I should ask more questions."
- Stopping early because the human seemed impatient — the human may need to be reminded that this is the cheapest stage to surface problems.

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "This is obvious, skip the interview" | Obvious requests are where unexamined assumptions hide best. |
| "The human seems annoyed" | Annoyance is not a substantive objection. Continue to convergence, then explain why. |
| "I'll ask my questions in a list to be efficient" | A list lets the human answer the easy ones and skip the hard one. |
| "I know the answer, just confirming" | Then you don't need an interview. Ask one direct verification question instead. |
| "The human is the expert here" | Experts have blind spots that look like obvious truths to them. The interview makes those visible. |

## Bottom Line

The human's reasoning, in the human's words, with every substantive gap surfaced by the agent. That is the artifact. Everything downstream uses it.
```

- [ ] **Step 9a.2: Commit**

```bash
git add skills/socratic-interview/SKILL.md && git commit -m "skill: socratic-interview"
```

### Task 10: `premise-check`

**Files:** Create `skills/premise-check/SKILL.md`

- [ ] **Step 10.1: Write SKILL.md**

```markdown
---
name: premise-check
description: Use after compass:socratic-interview has produced a transcript - summarizes the interview, validates the premise against the architecture journal, and categorizes the task to scale process weight
---

# Premise Check

## Overview

Premise-check does three things, in this order: (1) summarizes the socratic-interview transcript into the framings/assumptions/pivotal question downstream skills consume; (2) validates the premise against the architecture journal (invariants, prior ADRs, session-handoffs, debt-log); (3) categorizes the task so downstream skills know which mandatory steps to invoke.

**Core principle:** The interview produced the reasoning. Premise-check organizes it, checks it against recorded knowledge, and labels it.

**Violating the letter of this skill is violating the spirit of this skill.**

## Required Predecessor

`compass:socratic-interview` must have produced a transcript in `.architecture/interviews/`. If no transcript exists, refuse to proceed and direct to `compass:socratic-interview` first.

## When to Use

**Always after:**
- `compass:socratic-interview` (mandatory predecessor)

**Always before:**
- `compass:design-archeology`
- `compass:brainstorming`
- Any planning skill

## The Iron Law

```
NO PLAN WITHOUT INTERVIEW TRANSCRIPT + PREMISE-CHECK SUMMARY + VALIDATION + CATEGORIZATION
```

All five outputs below. Always. Before any plan.

## The Five Outputs

### 1. Two Alternative Framings (from the interview)

Quote (or closely paraphrase) two distinct framings the human articulated during the interview. If the interview did not produce two distinct framings, the interview was incomplete — return to `compass:socratic-interview` and probe further.

### 2. Load-Bearing Assumptions (from the interview)

List the assumptions the human committed to during the interview, drawn from their answers to the agent's challenge questions. These are not the agent's guesses — they are the human's stated positions.

### 3. One Pivotal Question (from the interview)

The highest-leverage open question the human deferred during the interview. From the transcript's "Open questions" section. If everything was resolved, state that explicitly.

### 4. Premise Validation (agent cross-references the architecture journal)

The agent reads `.architecture/invariants.md`, `.architecture/decisions/` (recent ADRs), `.architecture/session-handoffs/` (recent), and `.architecture/debt-log.md`, then reports three findings with citations:

**Plausibility:** does the premise contradict any documented invariant or past decision? Cite specific INV-IDs and ADR numbers. If none found, say "none found."

**Surface-level feasibility:** does the premise ask for something known to be technically impossible or known-to-fail in this codebase? Cite the source of the knowledge. *Scope:* this is the surface check only. Deep technical feasibility (does the code actually support this) comes from `compass:design-archeology` later. Deeper still, plan-writing surfaces what only becomes visible when you try to break the work down. Premise-check catches what is already known to be impossible or already failed.

**Prior-art check:** has something similar been attempted? Cite ADRs or session-handoffs. If a similar attempt was reverted, surface the reversion reason — that history is the most valuable input to the current decision.

If the validation surfaces conflicts, present them and wait. The human chooses: revise the premise, override the invariant (which creates a new ADR with `Decided by: H`), or proceed knowing the conflict (which gets documented in the resulting plan).

### 5. Premise Categorization (agent classifies the task)

The agent classifies the task on three axes:

**Domain familiarity:**
- *novel* — no related ADRs, no patterns in `conventions.md`, no prior work in `session-handoffs/`.
- *familiar* — clear prior art in the journal.
- *mixed* — some elements known, some new.

**Task type:** one of `feature | bug fix | refactor | infrastructure | migration | exploration | other`. This determines which downstream skills are mandatory.

**Suggested process weight:**
- *light* — trivial, locally reversible. May skip `tradeoff-matrix` for fully-reversible decisions. Skips `adversarial-review` if the task touches only one file and is fully reversible.
- *standard* — most tasks. Full pre-planning sequence.
- *heavy* — novel domain, irreversible decisions, multi-subsystem changes. Invokes `adversarial-review` at every plan iteration, not just at end. Invokes `design-archeology` even when familiar code would normally not warrant it.

The agent *suggests* the weight; the human confirms or overrides. The override gets an ADR with `Decided by: H` and a brief rationale.

## Process

1. Read the most recent `.architecture/interviews/YYYY-MM-DD-HHMM.md` transcript.
2. Extract outputs 1–3 from the human's words in the transcript.
3. Read the architecture journal files (invariants, decisions, recent handoffs, debt-log).
4. Produce output 4 (validation) with citations.
5. Produce output 5 (categorization) with reasoning grounded in the journal.
6. Present all five outputs to the human for confirmation.
7. Wait for confirmation, correction, or override.
8. Only then proceed to `compass:design-archeology` and `compass:brainstorming`.

## Red Flags - STOP

- About to invoke any downstream planning skill without all five outputs.
- About to invoke premise-check without reading the most recent transcript AND the architecture journal.
- The two alternative framings are the agent's inferences rather than the human's words.
- The load-bearing assumptions include items the human did not actually commit to during the interview.
- The pivotal question is one the agent thought of, not one the human deferred.
- The validation reports "no conflicts" without showing which files the agent read.
- The categorization is asserted without grounding in specific journal entries.
- Suggesting process weight = light on a task that touches multiple files or any one-way door.
- Thinking "the request is clear enough to skip the interview" — that decision belongs to the human, not the agent.

**All of these mean: STOP. Produce real outputs.**

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The request is unambiguous" | Unambiguous requests still rest on assumptions. Surface them. |
| "I'll just ask one quick question" | Question without framing means you're already biased by the request. |
| "Premise check slows things down" | Solving the wrong problem is the slowest thing you can do. |
| "The user clearly knows what they want" | They know what they think will help. That's not the same. |
| "The validation is taking too long" | Reading four short files is faster than discovering the conflict mid-implementation. |
| "Categorization is subjective" | Suggest a weight with grounded reasoning. The human overrides if needed. The override itself is informative. |

## Bottom Line

Five outputs. Always. Interview-derived (1–3), journal-cross-referenced (4), task-labeled (5). No exceptions.
```

- [ ] **Step 10.2: Commit**

```bash
git add skills/premise-check/SKILL.md && git commit -m "skill: premise-check"
```

### Task 11: `design-archeology`

**Files:** Create `skills/design-archeology/SKILL.md`

- [ ] **Step 11.1: Write SKILL.md**

```markdown
---
name: design-archeology
description: Use when about to modify a file or subsystem you have not authored or recently touched - reads existing code to extract implicit contracts, invariants, and smells before any change is proposed
---

# Design Archeology

## Overview

Code carries contracts that aren't in the type system. Callers depend on side-effect order, invariants the implementation happens to preserve, and idioms that aren't enforced anywhere. Changing code without surfacing those first guarantees a regression.

**Core principle:** Read before you write. Name the implicit before you change the explicit.

## When to Use

**Always before:**
- Editing a file you have not authored
- Editing a file you have not touched in this session
- Refactoring across multiple files
- Changing an interface

**Skip when:**
- Creating a new file from scratch in a new directory
- Writing a comment or fixing a typo

## The Four Outputs

For each target file, produce:

### 1. Implicit Contracts

What do callers rely on that the type system does not enforce?
- Side-effect order ("must call init() before use")
- Return-value invariants ("never returns null, only empty array")
- Concurrency assumptions ("not safe to call from multiple threads")
- Idempotence claims ("safe to call twice")

### 2. Invariants Preserved

What must remain true after every change?
- Data invariants ("the in-flight count never exceeds the configured max")
- State machine constraints ("once closed, never reopens")
- Resource invariants ("every open() has a matching close() on every path")

### 3. Smells

What's already weak?
- Files over 500 lines
- Functions doing more than one thing
- Hidden state (module-level mutables)
- Tangled responsibilities

### 4. The "Existing Design Notes" Block

Combine the above into a single block that becomes input to brainstorming or planning. Format:

```markdown
## Existing Design Notes — <file path>

**Implicit contracts:**
- ...

**Invariants:**
- ...

**Smells:**
- ...

**Implications for the proposed change:**
- ...
```

## Process

1. Read the target file completely. No skimming.
2. Read its direct dependents (one or two levels of callers).
3. If the file is large, also read its tests — tests document contracts the source doesn't.
4. Produce the four outputs above.
5. Pass the "Existing Design Notes" block to brainstorming.

## Red Flags - STOP

- About to propose an edit without having produced Existing Design Notes
- The implicit contracts list is empty (no code has zero implicit contracts; you missed them)
- The invariants list contains only type-system invariants (those aren't implicit)
- Thinking "I'll figure out the contracts as I edit"

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "I've seen code like this before" | Different codebases hide different contracts. Read this one. |
| "The function is small" | Small functions are often called from many places with overlapping assumptions. |
| "I'll just be careful" | Care without a list of constraints is luck. |
| "The tests would catch a regression" | Only if the tests cover the contract. Most don't. |

## Bottom Line

Four outputs. Every file. Before any edit.
```

- [ ] **Step 11.2: Commit**

```bash
git add skills/design-archeology/SKILL.md && git commit -m "skill: design-archeology"
```

### Task 12: `tradeoff-matrix`

**Files:** Create `skills/tradeoff-matrix/SKILL.md`

- [ ] **Step 12.1: Write SKILL.md**

```markdown
---
name: tradeoff-matrix
description: Use during brainstorming when an approach is being defended without explicit comparison to alternatives - forces three or more designs compared on named axes before any plan is approved
---

# Tradeoff Matrix

## Overview

Two-option comparisons collapse to vibes. Three-option comparisons on named axes make the tradeoff legible enough that a reviewer can disagree on substance.

**Core principle:** If you cannot fill in the matrix, you have not explored the design space.

## When to Use

**Always during brainstorming when:**
- A single approach is being defended
- The proposed approach has obvious one-way-door qualities (data migrations, schema changes, public API changes)
- The task touches multiple files or multiple subsystems

**Skip when:**
- The decision is fully reversible and cheap (a local refactor inside a single function)

## The Matrix

| Design | Reversibility | Complexity cost | Blast radius | Time to build | Operational cost | Future flexibility |
|---|---|---|---|---|---|---|

Rules:
- At least three designs. One may be "do nothing" if that's plausible.
- Every cell has one sentence of justification, not a number alone.
- The recommendation is the last row, with the tradeoff stated.

## Axes (default set)

- **Reversibility:** can we undo this in a week? a month? not at all?
- **Complexity cost:** how much does this add to the system's surface area?
- **Blast radius:** if this is wrong, how much breaks?
- **Time to build:** rough order of magnitude.
- **Operational cost:** ongoing run/maintain cost.
- **Future flexibility:** does this make likely next steps easier or harder?

Substitute axes when the situation warrants (security, latency, vendor lock-in). Always name them.

## Process

1. List at least three candidate designs.
2. Fill in every cell with a one-sentence justification.
3. Make a recommendation. State the tradeoff you're accepting.
4. Surface the matrix to the user before planning continues.

## Red Flags - STOP

- Fewer than three designs
- Cells with just numbers and no justification
- Cells marked "same for all designs" (then it isn't a discriminating axis; remove it)
- Recommendation with no stated tradeoff
- Recommendation chosen on a single axis (almost always wrong)

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "There's really only one reasonable approach" | Then the matrix takes five minutes to confirm. Do it. |
| "The user already chose" | The user chose with less information than you have now. |
| "Axes are subjective" | The point is to make the subjectivity visible. |
| "We can iterate" | Reversibility is one of the axes. If it's high, that's your justification. |

## Bottom Line

Three designs. Named axes. Stated tradeoff. Always.
```

- [ ] **Step 12.2: Commit**

```bash
git add skills/tradeoff-matrix/SKILL.md && git commit -m "skill: tradeoff-matrix"
```

### Task 13: `adversarial-review`

**Files:** Create `skills/adversarial-review/SKILL.md`

- [ ] **Step 13.1: Write SKILL.md**

```markdown
---
name: adversarial-review
description: Use after a plan is drafted but before execution begins - dispatches a subagent whose sole job is to defeat the plan and find the strongest objection
---

# Adversarial Review

## Overview

The model that proposed a plan tends to defend it. Separating the attacker from the proposer surfaces objections that self-review misses.

**Core principle:** Plans deserve a hostile reader before they deserve an implementer.

**REQUIRED SUB-SKILL:** Use `compass:dispatching-parallel-agents` to dispatch the reviewer.

## When to Use

**Always after:**
- A plan is drafted via `compass:writing-plans`
- Before any task in the plan is executed

**Especially when:**
- The plan involves a one-way door (migration, schema change, public API change)
- The plan touches multiple subsystems
- The plan is being executed by subagents (errors compound)

## The Process

1. Package the inputs the reviewer needs:
   - The plan document
   - The spec document
   - Relevant `.architecture/` excerpts (ADRs that touch the affected area, invariants that apply)
   - The names and one-line summaries of the rejected alternatives in the tradeoff matrix

2. Dispatch a subagent with this prompt template:

```
You are an adversarial reviewer. Your job is to defeat this plan. Find the
strongest objection a competent engineer who is hostile to this approach would
raise. The objection must be technical (about correctness, performance,
operability, security, blast radius, reversibility, or interaction with the
existing invariants) — not stylistic.

Do not soft-pedal. Do not list everything you can think of. Find the ONE
objection that is hardest to dismiss, and explain it in concrete terms with
the specific failure mode it predicts.

If you cannot find a substantive objection, say so explicitly and explain
which parts of the plan you stress-tested and what convinced you it survives.

Inputs:
- PLAN: <paste plan>
- SPEC: <paste spec>
- ARCHITECTURE CONTEXT: <paste relevant .architecture/ excerpts>
- REJECTED ALTERNATIVES: <list>

Output format:
## Strongest Objection
<technical objection in 100-300 words>

## Failure Mode
<specific scenario the objection predicts>

## What Would Defeat the Objection
<what change to the plan would address this — or "cannot be defeated within this approach">
```

3. Read the returned objection.
4. Either revise the plan or document in the spec why the objection is acceptable.

## Red Flags - STOP

- About to execute a plan that has not been adversarially reviewed
- The reviewer returns a stylistic objection ("the names could be better") — re-dispatch with the technical-only constraint emphasized
- The reviewer returns "no objection" without specifying what they stress-tested
- The reviewer returns five small objections instead of one strong one — re-dispatch

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The plan is small" | Small plans hide their failure modes better. |
| "I already self-reviewed" | The proposer cannot be the adversary. |
| "We'll find issues in code review" | Code review is too late; the design is locked. |
| "The reviewer will just nitpick" | Constrain the prompt to technical objections only. |

## Bottom Line

No plan executes without a real attack on it first.
```

- [ ] **Step 13.2: Commit**

```bash
git add skills/adversarial-review/SKILL.md && git commit -m "skill: adversarial-review"
```

### Task 14: `architecture-journal`

**Files:** Create `skills/architecture-journal/SKILL.md`

- [ ] **Step 14.1: Write SKILL.md**

```markdown
---
name: architecture-journal
description: Use at session start in a project with a .architecture/ directory, and whenever a structural decision is being made - manages the per-project architectural memory so decisions, invariants, conventions, and debt survive across sessions
---

# Architecture Journal

## Overview

Cross-session memory does not exist in the model. It exists in `.architecture/`. This skill makes sure the directory is read at the start of work and updated when work changes it.

**Core principle:** The model does not need to remember. It needs to be forced to read and forced to write.

## When to Use

**Always:**
- At session start in a project that has `.architecture/`
- When a structural decision is being made (interface change, dependency addition, data model change)
- When an invariant is being established
- When a shortcut is being taken (delegates to `compass:complexity-budget`)

**Skip when:**
- Project has no `.architecture/` (suggest bootstrapping it; do not silently create)
- Current task is purely tactical inside one well-understood function

## Session Start Process

1. Read `.architecture/manifest.md` (always).
2. Identify the area of the codebase the current task touches.
3. Read only the ADRs, invariants, conventions, and debt entries relevant to that area. Do not load everything.
4. Read the two most recent files in `session-handoffs/`.
5. Print a one-paragraph summary to the user of what you loaded and what you took away from it.

## Mid-Session Process

**When a structural decision is being made:**

Propose an ADR. Use this template:

```markdown
# ADR NNNN: <decision title>

**Status:** proposed
**Date:** YYYY-MM-DD
**Decided by:** H | A | D
**Context:** What forced this decision
**Decision:** What was decided
**Consequences:** What gets easier; what gets harder
**Alternatives considered:** Brief, with why-rejected
**Invariants this creates:** Reference to invariants.md IDs (or "none")
```

Number sequentially. Never reuse a number on supersede — use the `Status: superseded by NNNN` field instead.

**Decided by codes:**
- `H` — human decided the substance; agent surfaced options.
- `A` — agent proposed; human explicitly approved.
- `D` — delegated to agent without explicit human review at the time of decision.

The session-handoff skill reports the ratio at session end. Many consecutive `A` or `D` entries are a structural signal that the human has been backseated. The next session must surface that before continuing.

**When an invariant is established:**

Add to `invariants.md` using the format in the template. Always include a verification command.

**When a shortcut is taken:**

Delegate to `compass:complexity-budget` to log a `debt-log.md` entry.

## Session End Process

Invoke `compass:session-handoff`.

## Bootstrap (no `.architecture/` yet)

If session start detects no `.architecture/`:

1. Print:
   > "This project has no `.architecture/` directory. Compass's memory mechanism is unavailable. To enable it: run `<plugin>/scripts/bootstrap-architecture.sh .` and add `.architecture/` to git."

2. Continue without it. Do not silently create.

## Red Flags - STOP

- About to make a structural decision without proposing an ADR
- About to establish an invariant without a verification command
- About to take a shortcut without logging it to debt-log
- Reading all of `.architecture/` indiscriminately (you should load only what's relevant)

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "This decision is too small for an ADR" | Small decisions compound. The next session won't remember the rationale. |
| "I'll write the ADR later" | Later = never. Write it when the decision is made. |
| "The code documents the decision" | Code shows what; ADRs show why. |
| "The invariant is obvious" | Obvious to you in this session. Not obvious to the next session or a new contributor. |

## Bottom Line

Read at start. Write on every structural decision. Hand off at end.
```

- [ ] **Step 14.2: Commit**

```bash
git add skills/architecture-journal/SKILL.md && git commit -m "skill: architecture-journal"
```

### Task 15: `session-handoff`

**Files:** Create `skills/session-handoff/SKILL.md`

- [ ] **Step 15.1: Write SKILL.md**

```markdown
---
name: session-handoff
description: Use before ending any session that modified code or made structural decisions - writes a structured handoff note that the next session reads at start
---

# Session Handoff

## Overview

The next session has no memory of this one. A structured handoff is the only mechanism that survives the gap.

**Core principle:** Capture structural state changes, not work-done summaries.

## When to Use

**Always before ending a session that:**
- Modified code
- Made a structural decision
- Established or removed an invariant
- Logged debt

**Skip when:**
- Session was purely conversational (no file changes)
- Project has no `.architecture/`

## The Handoff Note

Save to `.architecture/session-handoffs/YYYY-MM-DD-HHMM.md`. Format:

```markdown
# Session Handoff — YYYY-MM-DD HH:MM

## What changed structurally

<List of structural changes: new files, deleted files, interface changes,
moved responsibilities. NOT a list of every file touched.>

## What is now true that wasn't

<Invariants added, conventions adopted, dependencies introduced.
Cross-reference ADR IDs.>

## What is half-finished

<If anything is incomplete: what's left, in what state, what blocks it.>

## What the next session needs to know

<Anything that would surprise a fresh session reading the code:
non-obvious assumptions, gotchas, "if you touch X, also touch Y".>

## Open questions

<Decisions deferred to a later session. What we don't know yet.>
```

## Process

1. Diff against session start (git status, git diff).
2. Identify *structural* changes — not every line touched, only the ones that change the shape of the system.
3. Write the note. One sentence per bullet, no padding.
4. Save to `.architecture/session-handoffs/YYYY-MM-DD-HHMM.md`.
5. If the diff includes a new ADR or invariant, ensure it's referenced from the handoff.
6. Commit the handoff with a clear message.

## Red Flags - STOP

- About to end a session with code changes but no handoff
- Handoff that's a chronological log of what you did instead of a structural diff
- Handoff that omits half-finished work
- Handoff longer than 500 words (you're not summarizing; you're transcribing)

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The git log is the handoff" | Git log shows commits, not structural meaning. |
| "I'll write it next session when I remember" | You won't remember. That's the problem. |
| "The session was small" | Small sessions accumulate. No handoff = invisible drift. |
| "The user can ask if they need to know" | The next session reads the handoff before the user asks. |

## Bottom Line

Structural diff, not narrative log. Every session that changed code.
```

- [ ] **Step 15.2: Commit**

```bash
git add skills/session-handoff/SKILL.md && git commit -m "skill: session-handoff"
```

### Task 16: `invariant-scan`

**Files:** Create `skills/invariant-scan/SKILL.md`

- [ ] **Step 16.1: Write SKILL.md**

```markdown
---
name: invariant-scan
description: Use on demand or scheduled to verify documented invariants in .architecture/invariants.md still hold across the codebase
---

# Invariant Scan

## Overview

Invariants drift silently. The only way to catch the drift is to run their verification commands periodically.

**Core principle:** Documented invariants are only as good as the most recent verification.

## When to Use

**On demand:**
- Before a release
- After a significant refactor
- When debugging a regression

**Scheduled:**
- Daily or weekly via `mcp__scheduled-tasks__create_scheduled_task` in Cowork
- Via CI on every PR in Claude Code projects

## Process

1. Read `.architecture/invariants.md`.
2. For each entry with ID `INV-NNN`:
   a. Read the `Verification:` field (an exact shell command).
   b. Read the `Expected:` field.
   c. Run the command.
   d. Compare output to expected.
   e. Classify: HOLDS, DRIFTED, or BROKEN_VERIFICATION.

3. Produce a report:

```markdown
## Invariant Scan — YYYY-MM-DD HH:MM

| ID | Status | Notes |
|---|---|---|
| INV-001 | HOLDS | — |
| INV-007 | DRIFTED | <one line: what's wrong, which ADR to revisit> |
| INV-012 | BROKEN_VERIFICATION | <verification command failed to run: error> |

**Action items:**
- <For each DRIFTED: which file, which ADR, suggested next step>
- <For each BROKEN_VERIFICATION: fix the verification command>
```

4. If any DRIFTED, propose a session to investigate. Do not silently auto-fix.

## Red Flags - STOP

- About to claim all invariants hold without showing the commands ran
- Skipping an invariant because the verification command "looks fine"
- Auto-fixing drifted invariants instead of investigating
- Treating BROKEN_VERIFICATION the same as DRIFTED (they're different problems)

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "The tests would catch invariant violations" | Tests cover what someone thought to test. Invariants cover what must always be true. |
| "I just touched that area, it's fine" | The drift might predate your change. |
| "The invariant is too generic to verify" | Then it isn't a real invariant. Either refine it or remove it. |

## Bottom Line

Run the commands. Read the output. Report the drift.
```

- [ ] **Step 16.2: Commit**

```bash
git add skills/invariant-scan/SKILL.md && git commit -m "skill: invariant-scan"
```

### Task 17: `complexity-budget`

**Files:** Create `skills/complexity-budget/SKILL.md`

- [ ] **Step 17.1: Write SKILL.md**

```markdown
---
name: complexity-budget
description: Use when taking a shortcut, reviewing a diff that took a shortcut, or at session start when touching files referenced in debt-log.md - keeps accumulated debt visible so it can be paid intentionally
---

# Complexity Budget

## Overview

Shortcuts that vanish into the diff get forgotten. A debt log that is read at the right moment makes shortcuts intentional rather than invisible.

**Core principle:** Debt that no one looks at compounds. Debt that gets surfaced at decision points gets weighed.

## When to Use

**Always:**
- About to take a shortcut (log it before committing the shortcut)
- Touching a file that appears in `.architecture/debt-log.md` (load the entry first)
- At session start when the planned work area overlaps logged debt
- Periodically to review accumulated debt sorted by age, cost, and trigger

## Logging a New Debt Entry

Append to `.architecture/debt-log.md`. Format:

```markdown
## DEBT-NNN: <one-line summary>

**Files:** `path/to/file.ts:123-145`
**Deferred:** <what was not done>
**Reason:** <why deferred>
**Will bite when:** <trigger condition>
**Cost to fix:** S | M | L | XL
**Logged:** YYYY-MM-DD
```

- Number sequentially. Never reuse a number.
- "Cost to fix" rubric: S = <1 hour, M = <1 day, L = <1 week, XL = larger.
- The trigger condition is mandatory. "When we have more users" is not a trigger. "When concurrent writes to this table exceed 100/sec" is.

## Surfacing Relevant Debt

At session start, given the set of files the planned work will touch:

1. `grep -A 6 'Files:' .architecture/debt-log.md | grep -E '<target-paths>'`
2. For each matching entry, print the entry to the user.
3. Ask: "Pay it now, or proceed and note the dependency?"

## Periodic Review

When invoked for review (no specific files in mind):

1. List all entries.
2. Sort by `Cost to fix` and by `Logged` date.
3. Highlight entries older than 90 days.
4. Highlight entries whose `Will bite when` trigger has plausibly fired.
5. Recommend a paydown order.

## Red Flags - STOP

- Took a shortcut without logging it
- Editing a file in `debt-log.md` without reading the entry first
- "Cost to fix" classification is vague ("medium" without rubric)
- "Will bite when" is a platitude
- Closing a debt entry without showing what changed

## Common Rationalizations

| Excuse | Reality |
|---|---|
| "It's a small shortcut, not worth logging" | Small shortcuts compound. Log them. |
| "I'll remember this one" | You won't. The next session won't. |
| "The TODO comment in the code is enough" | Comments don't aggregate. Debt log does. |
| "We never pay down debt anyway" | Then surface that fact and decide deliberately. |

## Bottom Line

Log it when you take it. Read it when you touch it. Review it periodically.
```

- [ ] **Step 17.2: Commit**

```bash
git add skills/complexity-budget/SKILL.md && git commit -m "skill: complexity-budget"
```

---

## Phase 4: Absorbed Superpowers Skills (Tasks 18–31)

For each absorbed skill: copy the source SKILL.md (and companion files) into `skills/<name>/`, then rewrite cross-references. The `using-superpowers` skill is additionally renamed.

**Rewrite command (used by every task in this phase):**

```bash
rewrite() {
  local file="$1"
  sed -i.bak \
    -e 's/superpowers:/compass:/g' \
    -e 's/Superpowers/Compass/g' \
    "$file"
  rm -f "${file}.bak"
}
```

The second pattern is a blanket prose replacement of the proper noun "Superpowers" → "Compass". This claims the absorbed skill as part of the Compass plugin context. Upstream attribution is preserved separately via the attribution-footer step in Task 31a, which runs after all rewrites and after the per-task verification.

**Verification command (used by every task in this phase):**

```bash
verify_no_superpowers() {
  if grep -rE 'superpowers:|Superpowers' "$1" 2>/dev/null; then
    echo "FAIL: remaining Superpowers references in $1"
    return 1
  fi
  echo "OK: no Superpowers references in $1"
}
```

This verification runs *before* Task 31a appends the attribution footer (which intentionally re-introduces the word "Superpowers" as a labeled citation). Do not re-run `verify_no_superpowers` on absorbed skills after Task 31a — it will fail by design.

### Task 18: Absorb `brainstorming`

- [ ] **Step 18.1: Copy**

```bash
mkdir -p skills/brainstorming
cp "$SP_SRC/brainstorming/SKILL.md" skills/brainstorming/SKILL.md
# Companion file (optional but referenced)
[ -f "$SP_SRC/brainstorming/visual-companion.md" ] && \
  cp "$SP_SRC/brainstorming/visual-companion.md" skills/brainstorming/
```

- [ ] **Step 18.2: Rewrite**

```bash
rewrite skills/brainstorming/SKILL.md
[ -f skills/brainstorming/visual-companion.md ] && rewrite skills/brainstorming/visual-companion.md
```

- [ ] **Step 18.3: Verify and commit**

```bash
verify_no_superpowers skills/brainstorming
git add skills/brainstorming && git commit -m "absorb: brainstorming"
```

### Task 19: Absorb `writing-plans`

- [ ] **Step 19.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/writing-plans
cp "$SP_SRC/writing-plans/SKILL.md" skills/writing-plans/SKILL.md
rewrite skills/writing-plans/SKILL.md
verify_no_superpowers skills/writing-plans
git add skills/writing-plans && git commit -m "absorb: writing-plans"
```

### Task 20: Absorb `executing-plans`

- [ ] **Step 20.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/executing-plans
cp "$SP_SRC/executing-plans/SKILL.md" skills/executing-plans/SKILL.md
rewrite skills/executing-plans/SKILL.md
verify_no_superpowers skills/executing-plans
git add skills/executing-plans && git commit -m "absorb: executing-plans"
```

### Task 21: Absorb `subagent-driven-development`

- [ ] **Step 21.1: Copy SKILL.md and companion prompts**

```bash
mkdir -p skills/subagent-driven-development
cp "$SP_SRC/subagent-driven-development/SKILL.md" skills/subagent-driven-development/
for f in implementer-prompt.md spec-reviewer-prompt.md code-quality-reviewer-prompt.md; do
  cp "$SP_SRC/subagent-driven-development/$f" skills/subagent-driven-development/
done
```

- [ ] **Step 21.2: Rewrite all four files**

```bash
for f in skills/subagent-driven-development/*.md; do rewrite "$f"; done
```

- [ ] **Step 21.3: Verify and commit**

```bash
verify_no_superpowers skills/subagent-driven-development
git add skills/subagent-driven-development && git commit -m "absorb: subagent-driven-development"
```

### Task 22: Absorb `test-driven-development`

- [ ] **Step 22.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/test-driven-development
cp "$SP_SRC/test-driven-development/SKILL.md" skills/test-driven-development/
[ -f "$SP_SRC/test-driven-development/testing-anti-patterns.md" ] && \
  cp "$SP_SRC/test-driven-development/testing-anti-patterns.md" skills/test-driven-development/
for f in skills/test-driven-development/*.md; do rewrite "$f"; done
verify_no_superpowers skills/test-driven-development
git add skills/test-driven-development && git commit -m "absorb: test-driven-development"
```

### Task 23: Absorb `systematic-debugging`

- [ ] **Step 23.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/systematic-debugging
cp "$SP_SRC/systematic-debugging/SKILL.md" skills/systematic-debugging/
for f in root-cause-tracing.md defense-in-depth.md condition-based-waiting.md; do
  [ -f "$SP_SRC/systematic-debugging/$f" ] && cp "$SP_SRC/systematic-debugging/$f" skills/systematic-debugging/
done
for f in skills/systematic-debugging/*.md; do rewrite "$f"; done
verify_no_superpowers skills/systematic-debugging
git add skills/systematic-debugging && git commit -m "absorb: systematic-debugging"
```

### Task 24: Absorb `verification-before-completion`

- [ ] **Step 24.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/verification-before-completion
cp "$SP_SRC/verification-before-completion/SKILL.md" skills/verification-before-completion/
rewrite skills/verification-before-completion/SKILL.md
verify_no_superpowers skills/verification-before-completion
git add skills/verification-before-completion && git commit -m "absorb: verification-before-completion"
```

### Task 25: Absorb `requesting-code-review`

- [ ] **Step 25.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/requesting-code-review
cp "$SP_SRC/requesting-code-review/SKILL.md" skills/requesting-code-review/
[ -f "$SP_SRC/requesting-code-review/code-reviewer.md" ] && \
  cp "$SP_SRC/requesting-code-review/code-reviewer.md" skills/requesting-code-review/
for f in skills/requesting-code-review/*.md; do rewrite "$f"; done
verify_no_superpowers skills/requesting-code-review
git add skills/requesting-code-review && git commit -m "absorb: requesting-code-review"
```

### Task 26: Absorb `receiving-code-review`

- [ ] **Step 26.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/receiving-code-review
cp "$SP_SRC/receiving-code-review/SKILL.md" skills/receiving-code-review/
rewrite skills/receiving-code-review/SKILL.md
verify_no_superpowers skills/receiving-code-review
git add skills/receiving-code-review && git commit -m "absorb: receiving-code-review"
```

### Task 27: Absorb `dispatching-parallel-agents`

- [ ] **Step 27.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/dispatching-parallel-agents
cp "$SP_SRC/dispatching-parallel-agents/SKILL.md" skills/dispatching-parallel-agents/
rewrite skills/dispatching-parallel-agents/SKILL.md
verify_no_superpowers skills/dispatching-parallel-agents
git add skills/dispatching-parallel-agents && git commit -m "absorb: dispatching-parallel-agents"
```

### Task 28: Absorb `using-git-worktrees`

- [ ] **Step 28.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/using-git-worktrees
cp "$SP_SRC/using-git-worktrees/SKILL.md" skills/using-git-worktrees/
rewrite skills/using-git-worktrees/SKILL.md
verify_no_superpowers skills/using-git-worktrees
git add skills/using-git-worktrees && git commit -m "absorb: using-git-worktrees"
```

### Task 29: Absorb `finishing-a-development-branch`

- [ ] **Step 29.1: Copy + rewrite + verify + commit**

```bash
mkdir -p skills/finishing-a-development-branch
cp "$SP_SRC/finishing-a-development-branch/SKILL.md" skills/finishing-a-development-branch/
rewrite skills/finishing-a-development-branch/SKILL.md
verify_no_superpowers skills/finishing-a-development-branch
git add skills/finishing-a-development-branch && git commit -m "absorb: finishing-a-development-branch"
```

### Task 30: Absorb `writing-skills`

- [ ] **Step 30.1: Copy SKILL.md and companion files**

```bash
mkdir -p skills/writing-skills
cp "$SP_SRC/writing-skills/SKILL.md" skills/writing-skills/
for f in anthropic-best-practices.md persuasion-principles.md testing-skills-with-subagents.md graphviz-conventions.dot render-graphs.js; do
  [ -f "$SP_SRC/writing-skills/$f" ] && cp "$SP_SRC/writing-skills/$f" skills/writing-skills/
done
```

- [ ] **Step 30.2: Rewrite markdown files**

```bash
for f in skills/writing-skills/*.md; do rewrite "$f"; done
```

- [ ] **Step 30.3: Verify and commit**

```bash
verify_no_superpowers skills/writing-skills
git add skills/writing-skills && git commit -m "absorb: writing-skills"
```

### Task 31: Absorb and rename `using-superpowers` → `using-compass`

- [ ] **Step 31.1: Copy under new name**

```bash
mkdir -p skills/using-compass
cp "$SP_SRC/using-superpowers/SKILL.md" skills/using-compass/SKILL.md
```

- [ ] **Step 31.2: Rewrite content (use the standard rewrite function) and patch frontmatter**

```bash
# Standard rewrite: superpowers: → compass: and Superpowers → Compass
rewrite skills/using-compass/SKILL.md

# Additional rename: the slug "using-superpowers" → "using-compass"
sed -i.bak -e 's/using-superpowers/using-compass/g' skills/using-compass/SKILL.md
rm -f skills/using-compass/SKILL.md.bak

# Replace the frontmatter name field explicitly
python3 - <<'PY'
import re, pathlib
p = pathlib.Path("skills/using-compass/SKILL.md")
text = p.read_text()
text = re.sub(r"^name: .*$", "name: using-compass", text, count=1, flags=re.M)
p.write_text(text)
PY
```

- [ ] **Step 31.3: Verify**

```bash
head -5 skills/using-compass/SKILL.md
verify_no_superpowers skills/using-compass
```

Expected: frontmatter shows `name: using-compass`, no `superpowers:` references remain.

- [ ] **Step 31.4: Commit**

```bash
git add skills/using-compass && git commit -m "absorb: using-compass (renamed from using-superpowers)"
```

### Task 31a: Append attribution footer to all absorbed skills

This task closes DEBT-003. It re-introduces the word "Superpowers" intentionally, as a labeled source citation. Runs after every absorption task is complete and verified.

**Files:** Modifies every `skills/<name>/SKILL.md` for the 14 absorbed skills.

- [ ] **Step 31a.1: Define the attribution footer**

```bash
read -r -d '' ATTRIBUTION <<'FOOTER' || true

---

*Source attribution: this skill is adapted from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin. Within the Compass plugin, references to the namespace `superpowers:` have been rewritten to `compass:` and prose mentions of "Superpowers" as a plugin name have been rewritten to "Compass". This footer is the canonical source citation; do not remove it on resync.*
FOOTER
```

- [ ] **Step 31a.2: Append to each absorbed skill**

```bash
ABSORBED=(
  brainstorming writing-plans executing-plans subagent-driven-development
  test-driven-development systematic-debugging verification-before-completion
  requesting-code-review receiving-code-review dispatching-parallel-agents
  using-git-worktrees finishing-a-development-branch writing-skills
  using-compass
)

for skill in "${ABSORBED[@]}"; do
  file="skills/$skill/SKILL.md"
  if [ ! -f "$file" ]; then
    echo "MISSING: $file" >&2
    continue
  fi
  # Idempotency: skip if already attributed
  if grep -q "Source attribution: this skill is adapted from" "$file"; then
    echo "SKIP (already attributed): $file"
    continue
  fi
  printf '%s\n' "$ATTRIBUTION" >> "$file"
  echo "Appended attribution: $file"
done
```

- [ ] **Step 31a.3: Verify every absorbed skill has the footer**

```bash
missing=0
for skill in "${ABSORBED[@]}"; do
  file="skills/$skill/SKILL.md"
  if ! grep -q "Source attribution: this skill is adapted from" "$file"; then
    echo "FAIL: missing attribution in $file"
    missing=$((missing+1))
  fi
done
if [ $missing -eq 0 ]; then echo "OK: all 14 absorbed skills attributed"; else exit 1; fi
```

Expected: `OK: all 14 absorbed skills attributed`.

- [ ] **Step 31a.4: Commit**

```bash
git add skills/
git commit -m "absorb: add source attribution footer to all absorbed skills (closes DEBT-003)"
```

---

## Phase 5: Hooks (Tasks 32–35)

Hooks are POSIX shell. Each must be executable and self-contained.

### Task 32: `SessionStart` hook

**Files:** Create `hooks/session-start.sh`

- [ ] **Step 32.1: Write hook**

```bash
#!/usr/bin/env bash
# Fires at the start of a Claude Code session.
# If the current project has .architecture/, prints a reminder to invoke architecture-journal.
set -eu

if [ -d ".architecture" ]; then
  echo "[compass] This project has .architecture/. Invoke compass:architecture-journal to load relevant context."
fi
exit 0
```

- [ ] **Step 32.2: Make executable and commit**

```bash
chmod +x hooks/session-start.sh
git add hooks/session-start.sh && git commit -m "hook: session-start"
```

### Task 33: `PreToolUse` hook (Edit/Write)

**Files:** Create `hooks/pre-tool-use-edit.sh`

- [ ] **Step 33.1: Write hook**

```bash
#!/usr/bin/env bash
# Fires before Edit/Write tool calls.
# Reads the target file path from the hook environment (varies by platform; assume $TARGET_FILE).
# Prints relevant debt entries and a design-archeology reminder if file is unfamiliar.
set -eu

TARGET="${TARGET_FILE:-}"
[ -n "$TARGET" ] || exit 0
[ -d ".architecture" ] || exit 0

if [ -f ".architecture/debt-log.md" ]; then
  match=$(grep -B1 -A6 "Files:.*$TARGET" .architecture/debt-log.md || true)
  if [ -n "$match" ]; then
    echo "[compass] Debt log entries for $TARGET:"
    echo "$match"
    echo "[compass] Consider compass:complexity-budget before proceeding."
  fi
fi

# Heuristic: if no commit in this session has touched this file's directory, suggest design-archeology
dir=$(dirname "$TARGET")
session_start_sha=$(git log --reverse --format=%H -n 1 || echo "")
if [ -n "$session_start_sha" ]; then
  if ! git log "$session_start_sha"..HEAD --name-only --format= -- "$dir" 2>/dev/null | grep -q .; then
    echo "[compass] No commits this session in $dir. Consider compass:design-archeology before editing $TARGET."
  fi
fi
exit 0
```

- [ ] **Step 33.2: Make executable and commit**

```bash
chmod +x hooks/pre-tool-use-edit.sh
git add hooks/pre-tool-use-edit.sh && git commit -m "hook: pre-tool-use-edit"
```

### Task 34: `PreToolUse` hook (Write) symlink/duplicate

- [ ] **Step 34.1: Reuse the same hook for Write**

```bash
cp hooks/pre-tool-use-edit.sh hooks/pre-tool-use-write.sh
chmod +x hooks/pre-tool-use-write.sh
git add hooks/pre-tool-use-write.sh && git commit -m "hook: pre-tool-use-write (mirror of edit)"
```

### Task 35: `SessionEnd` hook

**Files:** Create `hooks/session-end.sh`

- [ ] **Step 35.1: Write hook**

```bash
#!/usr/bin/env bash
# Fires at session end.
# If the session made code changes, prints a reminder to invoke session-handoff.
set -eu

[ -d ".architecture" ] || exit 0

changed=$(git diff --name-only HEAD@{1} HEAD 2>/dev/null | wc -l | tr -d ' ')
if [ "${changed:-0}" -gt 0 ]; then
  echo "[compass] Session changed $changed files. Invoke compass:session-handoff before ending."
fi
exit 0
```

- [ ] **Step 35.2: Make executable and commit**

```bash
chmod +x hooks/session-end.sh
git add hooks/session-end.sh && git commit -m "hook: session-end"
```

---

## Phase 6: Packaging (Tasks 36–37)

### Task 36: `package-cowork.sh`

**Files:** Create `scripts/package-cowork.sh`

- [ ] **Step 36.1: Write script**

```bash
#!/usr/bin/env bash
# Produces compass.plugin (a zip archive) suitable for Cowork install.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="$ROOT/dist/compass.plugin"

mkdir -p "$ROOT/dist"
rm -f "$OUT"

# Zip everything except .git, dist, *.bak
( cd "$ROOT" && zip -r "$OUT" . \
    -x ".git/*" "dist/*" "*.bak" "*.DS_Store" )

echo "Built $OUT"
echo "Size: $(du -h "$OUT" | cut -f1)"
```

- [ ] **Step 36.2: Make executable, smoke-test, commit**

```bash
chmod +x scripts/package-cowork.sh
bash scripts/package-cowork.sh
unzip -l dist/compass.plugin | head -20
git add scripts/package-cowork.sh && git commit -m "scripts: package-cowork"
```

Expected: `unzip -l` shows `plugin.json`, `skills/`, `templates/`, `hooks/`.

### Task 37: `package-claude-code.sh`

**Files:** Create `scripts/package-claude-code.sh`

- [ ] **Step 37.1: Write script**

```bash
#!/usr/bin/env bash
# Produces a Claude Code plugin directory (a clean copy of the source tree without .git).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUT="$ROOT/dist/compass-claude-code"

rm -rf "$OUT"
mkdir -p "$OUT"

# Copy everything except .git, dist, *.bak
rsync -a \
  --exclude='.git/' \
  --exclude='dist/' \
  --exclude='*.bak' \
  --exclude='.DS_Store' \
  "$ROOT/" "$OUT/"

echo "Built $OUT"
echo "Install via: claude plugins install $OUT  (or your platform's equivalent)"
```

- [ ] **Step 37.2: Make executable, smoke-test, commit**

```bash
chmod +x scripts/package-claude-code.sh
bash scripts/package-claude-code.sh
ls dist/compass-claude-code | head
git add scripts/package-claude-code.sh && git commit -m "scripts: package-claude-code"
```

---

## Phase 7: Dogfood — Plugin's Own `.architecture/` (Tasks 38–42)

The plugin's own `.architecture/` directory documents the plugin's design.

### Task 38: Plugin `.architecture/manifest.md`

- [ ] **Step 38.1: Write manifest**

File: `.architecture/manifest.md`

```markdown
# Compass — Architecture Manifest

## Contents

- `decisions/` — ADRs for this plugin's own design.
- `invariants.md` — what must remain true about the plugin.
- `conventions.md` — non-obvious idioms used in the plugin.
- `debt-log.md` — known shortcuts in the plugin.
- `session-handoffs/` — notes between development sessions of the plugin itself.

## Top-level summary

This plugin ships eight new strategic-programming skills, fourteen workflow skills absorbed from Superpowers, the `.architecture/` mechanism that the plugin manages for user projects, and optional Claude Code hooks. The source tree is shared between the Cowork `.plugin` archive and the Claude Code plugin directory; build scripts produce both. The plugin uses its own architecture mechanism on itself.
```

- [ ] **Step 38.2: Commit**

```bash
git add .architecture/manifest.md && git commit -m "dogfood: architecture manifest"
```

### Task 39: ADR 0001 — namespace prefix

- [ ] **Step 39.1: Write ADR**

File: `.architecture/decisions/0001-namespace-prefix.md`

```markdown
# ADR 0001: Use `compass:` as the skill namespace prefix

**Status:** accepted
**Date:** 2026-06-24
**Context:** Skills cross-reference each other via prefix; collisions are possible with other plugins (notably Superpowers). The prefix must be both unique and readable.
**Decision:** Use `compass:` (long form) rather than `se:` (short form).
**Consequences:** Easier — references are self-documenting and unlikely to collide. Harder — every absorbed skill needs sed rewriting and the prefix is verbose in cross-references.
**Alternatives considered:**
- `se:` — rejected: too short to be self-documenting; high collision risk.
- `strat-eng:` — rejected: hyphenated abbreviation reads worse than the full word.
**Invariants this creates:** INV-001 (every absorbed skill has cross-references rewritten).
```

- [ ] **Step 39.2: Commit**

```bash
git add .architecture/decisions/0001-namespace-prefix.md && git commit -m "dogfood: ADR 0001"
```

### Task 40: ADR 0002, 0003, 0004

- [ ] **Step 40.1: ADR 0002 — absorb instead of depend**

File: `.architecture/decisions/0002-absorb-superpowers.md`

```markdown
# ADR 0002: Absorb Superpowers skills rather than declare a dependency

**Status:** accepted
**Date:** 2026-06-24
**Context:** The plugin needs Superpowers workflow skills (brainstorming, writing-plans, TDD, etc.) but plugins do not yet have a dependency mechanism.
**Decision:** Bundle copies of the required Superpowers skills under the `compass:` namespace.
**Consequences:** Easier — plugin works standalone; no install ordering. Harder — duplicate skills if a user has both plugins; absorbed skills must be re-synced when Superpowers updates upstream.
**Alternatives considered:**
- Declare a runtime dependency on Superpowers — rejected: mechanism does not exist.
- Skip absorbed skills and document a Superpowers prerequisite — rejected: violates standalone requirement.
**Invariants this creates:** INV-002 (the plugin must install and function on a system without Superpowers).
```

- [ ] **Step 40.2: ADR 0003 — hooks as reminders**

File: `.architecture/decisions/0003-hooks-as-reminders.md`

```markdown
# ADR 0003: Hooks print reminders, never block

**Status:** accepted
**Date:** 2026-06-24
**Context:** Claude Code hooks can be advisory (print) or blocking (non-zero exit). Cowork has no hook mechanism.
**Decision:** All hooks print reminders and exit 0. Never block.
**Consequences:** Easier — Cowork parity at the skill level; users who disagree with a hook are not stuck. Harder — hooks have no enforcement teeth; skill descriptions carry the triggering load.
**Alternatives considered:** Blocking hooks — rejected: creates parity gap with Cowork; punishes users who deliberately opt out.
**Invariants this creates:** INV-003 (every hook script exits 0 regardless of detection).
```

- [ ] **Step 40.3: ADR 0004 — rename using-superpowers**

File: `.architecture/decisions/0004-rename-using-superpowers.md`

```markdown
# ADR 0004: Rename absorbed `using-superpowers` to `using-compass`

**Status:** accepted
**Date:** 2026-06-24
**Context:** `using-superpowers` is the meta-skill that bootstraps the workflow. Inside this plugin, the meta-skill must point at this plugin's skills, not Superpowers'.
**Decision:** Rename to `using-compass`. Rewrite all internal references.
**Consequences:** Easier — meta-skill loop closes correctly inside the plugin. Harder — name diverges from the upstream Superpowers source, complicating future syncs.
**Alternatives considered:** Keep the name and only rewrite cross-references — rejected: ambiguous and confusing.
**Invariants this creates:** INV-004 (no skill in this plugin is named `using-superpowers`).
```

- [ ] **Step 40.4: Commit**

```bash
git add .architecture/decisions/0002-absorb-superpowers.md .architecture/decisions/0003-hooks-as-reminders.md .architecture/decisions/0004-rename-using-superpowers.md
git commit -m "dogfood: ADRs 0002–0004"
```

- [ ] **Step 40.5: ADR 0005 — attribution mechanism for absorbed skills**

File: `.architecture/decisions/0005-absorbed-skill-attribution.md`

```markdown
# ADR 0005: Blanket prose rewrite plus attribution footer for absorbed skills

**Status:** accepted
**Date:** 2026-06-24
**Context:** Absorbed Superpowers skills carry prose references to "Superpowers" as a proper noun (e.g., "Superpowers skills override default system prompt behavior"). Two concerns compete: (a) inside the Compass plugin, those references should describe Compass — the plugin the user actually installed; (b) the upstream Superpowers project deserves attribution, and a future maintainer needs to know where to resync from.
**Decision:** Two-step approach. First, the `rewrite()` function blanket-replaces "Superpowers" → "Compass" in absorbed skill bodies (mechanical, applied to all references uniformly). Second, Task 31a appends a labeled attribution footer to each absorbed `SKILL.md` that intentionally re-introduces the word "Superpowers" as a citation. The README's Attribution section provides the higher-level credit.
**Consequences:** Easier — absorbed skills read as native Compass skills; the attribution footer is structurally separate from skill content. Harder — the verification function `verify_no_superpowers` must run *before* Task 31a, not after, since Task 31a re-introduces the proper noun by design.
**Alternatives considered:**
- Per-instance judgment (keep some "Superpowers" mentions, rewrite others) — rejected: inconsistent, hard to audit, hard to resync from upstream.
- Blanket rewrite with no attribution — rejected: implicitly claims the work; no resync path documented.
- Attribution only, no prose rewrite — rejected: readers of an absorbed skill see "Superpowers" mid-prose and become confused about which plugin context they are in.
**Invariants this creates:** INV-005 (every absorbed `SKILL.md` ends with the attribution footer).
**Closes:** DEBT-003.
```

- [ ] **Step 40.6: Commit ADR 0005**

```bash
git add .architecture/decisions/0005-absorbed-skill-attribution.md
git commit -m "dogfood: ADR 0005 (attribution mechanism)"
```

- [ ] **Step 40.7: ADR 0006 — human-as-driver and the socratic-interview / premise-check role split**

File: `.architecture/decisions/0006-human-as-driver.md`

```markdown
# ADR 0006: Human is the driver; agent is the foil

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Context:** A risk surfaced after the first design pass: every pre-planning skill (premise-check, design-archeology, tradeoff-matrix, adversarial-review) had the agent generate the artifact and the human approve it. This is procedurally fast but offloads the cognitive work to the agent. The user retains veto power, not driver's seat. For projects where the user explicitly wants their own knowledge and judgment to compound, that is a structural failure.
**Decision:** Add a `socratic-interview` skill that runs first on any non-trivial task. The agent conducts a one-question-at-a-time interview that probes the human's reasoning until the agent has no further substantive objection. The transcript is authored by the human in their own words. `premise-check` is demoted from generator to summarizer over that transcript. Decision authority is tracked in every ADR via a `Decided by:` field (H/A/D). The session-handoff reports the ratio so backseating is visible structurally.
**Consequences:** Easier — the human's reasoning, not the agent's inference, is the source of truth for planning. Decision authority is auditable. Backseating is detectable. Harder — every non-trivial task takes longer at the front; the user must engage rather than approve.
**Alternatives considered:**
- Keep the agent-generates / human-approves flow — rejected: it is exactly the offloading we want to prevent.
- Add the interview as a section inside premise-check — rejected: conflates interview-the-human with structure-the-output; the two have different rules and run at different times.
- Use "adversarial-interview" as the name — rejected on the user's preference for "socratic-interview" because the goal is mutual understanding, not opposition.
**Invariants this creates:** INV-006 (every plan has a corresponding interview transcript).
```

- [ ] **Step 40.8: Commit ADR 0006**

```bash
git add .architecture/decisions/0006-human-as-driver.md
git commit -m "dogfood: ADR 0006 (human-as-driver philosophy)"
```

- [ ] **Step 40.9: ADR 0007 — premise-check includes validation and categorization**

File: `.architecture/decisions/0007-premise-check-validation-and-categorization.md`

```markdown
# ADR 0007: premise-check includes validation and categorization

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H
**Context:** premise-check as defined in ADR 0006 was a pure summarizer over the socratic-interview transcript. Two gaps remained. (a) External validation — the interview catches internal contradictions in the human's reasoning, but not contradictions against the architecture journal's recorded invariants, ADRs, and prior session work. (b) Categorization — every task got the full ceremony or none, with no mechanism to scale process weight to task novelty or blast radius.
**Decision:** Extend premise-check with two additional outputs after the three interview-derived ones. Output 4 is validation: the agent cross-references the premise against `.architecture/invariants.md`, `decisions/`, recent `session-handoffs/`, and `debt-log.md`, reporting plausibility conflicts, surface-level feasibility concerns, and prior art with citations. Output 5 is categorization: domain familiarity (novel/familiar/mixed), task type (one of seven enumerated values), and suggested process weight (light/standard/heavy). The agent's classification is grounded in journal entries; the human reviews and overrides. Overrides get their own ADRs with `Decided by: H`.
**Consequences:** Easier — premises that contradict recorded knowledge fail fast, before any code is touched; process weight scales to task novelty and blast radius; downstream skills know which steps are mandatory; deep technical feasibility still gets caught by `design-archeology` (no false confidence from premise-check). Harder — premise-check now has five outputs and reads four journal files; the categorization is a judgment call the agent must defend with citations.
**Alternatives considered:**
- Separate validation skill — rejected for v1; skill proliferation outweighs reuse value at current scope. Revisit if validation complexity grows.
- Validation in `design-archeology` — rejected; archeology validates against code reality, premise-check validates against recorded knowledge. Different concerns, different timing.
- No categorization, every task gets full ceremony — rejected; user-confirmed need to scale process to task type.
- Categorization as a separate skill — deferred; revisit if it grows beyond the three-axis classification.
**Invariants this creates:** none new directly; reinforces INV-006 (the architecture journal must be readable for premise-check to do validation).
```

- [ ] **Step 40.10: Commit ADR 0007**

```bash
git add .architecture/decisions/0007-premise-check-validation-and-categorization.md
git commit -m "dogfood: ADR 0007 (validation and categorization in premise-check)"
```

### Task 41: Plugin invariants

- [ ] **Step 41.1: Write invariants**

File: `.architecture/invariants.md`

```markdown
# Invariants

## INV-001: Every absorbed skill has cross-references rewritten to `compass:`
**Established by:** ADR 0001
**Verification:** `! grep -r 'superpowers:' skills/ 2>/dev/null`
**Expected:** No matches (empty output, exit 0 on the negated grep).
**On failure:** Re-run the rewrite step for the offending skill; see ADR 0001.

## INV-002: Plugin installs and functions on a system without Superpowers
**Established by:** ADR 0002
**Verification:** Manual: install in a clean environment and invoke `using-compass`. Automated: skill self-references stay within `skills/`.
**Expected:** No external references except to the user's own project files.
**On failure:** A skill references an external resource; absorb it or remove the reference.

## INV-003: Every hook script exits 0 regardless of detection
**Established by:** ADR 0003
**Verification:** `for f in hooks/*.sh; do bash -n "$f" && bash "$f" </dev/null; echo "$f exit=$?"; done | grep -v 'exit=0' || echo OK`
**Expected:** Output is `OK`.
**On failure:** A hook is blocking. Make it advisory (exit 0).

## INV-004: No skill in this plugin is named `using-superpowers`
**Established by:** ADR 0004
**Verification:** `! [ -d skills/using-superpowers ]`
**Expected:** Directory does not exist.
**On failure:** Delete or rename; see ADR 0004.

## INV-005: Every absorbed `SKILL.md` ends with the attribution footer
**Established by:** ADR 0005
**Verification:** `for s in brainstorming writing-plans executing-plans subagent-driven-development test-driven-development systematic-debugging verification-before-completion requesting-code-review receiving-code-review dispatching-parallel-agents using-git-worktrees finishing-a-development-branch writing-skills using-compass; do grep -q "Source attribution: this skill is adapted from" "skills/$s/SKILL.md" || { echo "MISSING: $s"; exit 1; }; done; echo OK`
**Expected:** Output is `OK`.
**On failure:** Re-run Task 31a for the offending skill; see ADR 0005.

## INV-006: Every plan has a corresponding interview transcript
**Established by:** ADR 0006
**Verification:** `for plan in docs/*/plans/*.md 2>/dev/null; do d=$(basename "$plan" | grep -oE '^[0-9]{4}-[0-9]{2}-[0-9]{2}'); [ -n "$(ls .architecture/interviews/${d}*.md 2>/dev/null)" ] || { echo "MISSING interview for $plan (date $d)"; exit 1; }; done; echo OK`
**Expected:** Output is `OK`.
**On failure:** A plan was written without a socratic-interview transcript on the same date. Either back-fill the transcript or explicitly document in the plan why the interview was skipped (per the per-task opt-out in `compass:socratic-interview`).
```

- [ ] **Step 41.2: Run the invariant verifications now**

```bash
# INV-001
! grep -r 'superpowers:' skills/ 2>/dev/null && echo "INV-001: OK"

# INV-003
for f in hooks/*.sh; do
  bash -n "$f" && bash "$f" </dev/null
  echo "$f exit=$?"
done

# INV-004
! [ -d skills/using-superpowers ] && echo "INV-004: OK"

# INV-005 (run only after Task 31a is complete)
for s in brainstorming writing-plans executing-plans subagent-driven-development \
         test-driven-development systematic-debugging verification-before-completion \
         requesting-code-review receiving-code-review dispatching-parallel-agents \
         using-git-worktrees finishing-a-development-branch writing-skills using-compass; do
  grep -q "Source attribution: this skill is adapted from" "skills/$s/SKILL.md" \
    || { echo "MISSING: $s"; exit 1; }
done
echo "INV-005: OK"
```

Expected: INV-001 OK, every hook exit=0, INV-004 OK, INV-005 OK. (INV-002 is manual; skip for now.)

- [ ] **Step 41.3: Commit**

```bash
git add .architecture/invariants.md && git commit -m "dogfood: invariants"
```

### Task 42: Plugin conventions and debt-log seed

- [ ] **Step 42.1: Write conventions**

File: `.architecture/conventions.md`

```markdown
# Conventions

## C-001: ADR files use sequential numbering; never reused on supersede
Use the `Status: superseded by NNNN` field instead. The number itself is permanent.

## C-002: Skill cross-references use the `**REQUIRED SUB-SKILL:**` marker
Inherited from Superpowers. Always lowercase the skill name; always prefix with `compass:`.

## C-003: Hooks print, never block
Established by ADR 0003. Every hook ends with `exit 0`.

## C-004: Verification commands in invariants.md are exact shell commands
Not pseudocode, not "manually check". If it cannot be automated, label it `Verification: manual` and provide the procedure.
```

- [ ] **Step 42.2: Write debt-log**

File: `.architecture/debt-log.md`

```markdown
# Debt Log

## DEBT-001: Plugin-dependency mechanism not yet supported
**Files:** `plugin.json`
**Deferred:** Declaring Superpowers as a runtime dependency.
**Reason:** No such mechanism exists in either Cowork or Claude Code plugin systems as of 2026-06-24.
**Will bite when:** Upstream Superpowers updates a workflow skill in a way that changes behavior; this plugin's absorbed copy drifts.
**Cost to fix:** L (requires upstream change once mechanism exists; then a re-pinning sweep).
**Logged:** 2026-06-24

## DEBT-002: Hooks read `TARGET_FILE` from environment; format varies by platform
**Files:** `hooks/pre-tool-use-edit.sh`, `hooks/pre-tool-use-write.sh`
**Deferred:** Confirming the exact environment variable name Claude Code uses.
**Reason:** Not documented in any source available at the time of writing.
**Will bite when:** A user installs the plugin in Claude Code and the hook silently no-ops because the variable is named differently.
**Cost to fix:** S (one sed once the name is confirmed).
**Logged:** 2026-06-24

## DEBT-003: Narrative "Compass" mentions in absorbed skill bodies (RESOLVED)
**Files:** `skills/*/SKILL.md` (absorbed only)
**Deferred:** The rewrite step originally replaced `superpowers:` prefixes only, leaving prose references to "Superpowers" as a proper noun in absorbed skill bodies.
**Reason:** Blanket replacement was initially considered unsafe — some references are accurate citations of the upstream system.
**Will bite when:** Was a risk that readers would be confused about which plugin context they were in.
**Cost to fix:** M (estimated).
**Logged:** 2026-06-24
**Resolved:** 2026-06-24 — see ADR 0005. The `rewrite()` function now blanket-replaces `Superpowers` → `Compass` in absorbed skill bodies, and Task 31a appends a labeled attribution footer to each absorbed SKILL.md that intentionally re-introduces the word "Superpowers" as a citation. INV-005 verifies the footer is present.
```

- [ ] **Step 42.3: Commit**

```bash
git add .architecture/conventions.md .architecture/debt-log.md
git commit -m "dogfood: conventions and debt-log"
```

---

## Phase 8: Final Verification (Tasks 43–45)

### Task 43: Run all invariant verifications

- [ ] **Step 43.1: Run invariant-scan equivalent manually**

```bash
echo "=== INV-001 ==="
! grep -r 'superpowers:' skills/ 2>/dev/null && echo OK || echo FAIL

echo "=== INV-003 ==="
for f in hooks/*.sh; do
  bash -n "$f" && bash "$f" </dev/null >/dev/null
  echo "$f exit=$?"
done

echo "=== INV-004 ==="
! [ -d skills/using-superpowers ] && echo OK || echo FAIL

echo "=== File count sanity ==="
echo "Skills:   $(find skills -name SKILL.md | wc -l)"  # expect 22
echo "Hooks:    $(ls hooks/*.sh | wc -l)"               # expect 4
echo "ADRs:     $(ls .architecture/decisions/*.md | wc -l)"  # expect 4
```

Expected: every check passes; counts match.

- [ ] **Step 43.2: Build both packages**

```bash
bash scripts/package-cowork.sh
bash scripts/package-claude-code.sh
ls -lh dist/
```

Expected: `compass.plugin` archive and `compass-claude-code/` directory both exist.

### Task 44: Write first session handoff

- [ ] **Step 44.1: Author the handoff**

File: `.architecture/session-handoffs/2026-06-24-1400.md`

```markdown
# Session Handoff — 2026-06-24 14:00

## What changed structurally

- Plugin scaffolded from empty repo to v0.1.0.
- 8 new skills added under `skills/` (premise-check, design-archeology, tradeoff-matrix, adversarial-review, architecture-journal, session-handoff, invariant-scan, complexity-budget).
- 14 Superpowers skills absorbed into `skills/` with namespace rewrites.
- `using-superpowers` renamed to `using-compass`.
- `.architecture/` template populated under `templates/architecture/`.
- 4 hooks added under `hooks/` (session-start, pre-tool-use-edit, pre-tool-use-write, session-end).
- 2 packaging scripts under `scripts/`.
- Plugin's own `.architecture/` populated with ADRs 0001–0004, invariants INV-001–004, conventions C-001–004, debt entries DEBT-001–002.

## What is now true that wasn't

- The plugin works standalone (no Superpowers install required). See INV-002.
- Cross-session memory mechanism exists and is documented (the `.architecture/` directory and the `architecture-journal` skill).
- Hooks are advisory in all cases (INV-003).

## What is half-finished

- INV-002 verification is manual; needs a clean-environment install test before release.
- DEBT-002: hook environment variable name for `TARGET_FILE` is unconfirmed for Claude Code.

## What the next session needs to know

- The plugin uses its own `.architecture/` directory; updates to the plugin should follow the same discipline.
- Absorbed skills are kept verbatim except for `superpowers:` → `compass:` rewrites and the rename of `using-superpowers`. Resyncing from upstream is a sed + cherry-pick exercise.
- Adversarial review of this plan has not been run. Should be done before v0.1.0 release.

## Open questions

- Should the plugin offer a `migrate-from-superpowers.sh` script that detects an existing Superpowers install and offers to uninstall it?
- Should `invariant-scan` be wired to a default scheduled task on plugin install, or left to the user to schedule?
- Should the plugin ship with a sample `.architecture/` for a small example project to make the mechanism legible to first-time users?
```

- [ ] **Step 44.2: Commit**

```bash
git add .architecture/session-handoffs/2026-06-24-1400.md
git commit -m "dogfood: first session handoff"
```

### Task 45: Tag v0.1.0 and finish

- [ ] **Step 45.1: Tag**

```bash
git tag -a v0.1.0 -m "Compass plugin 0.1.0"
git log --oneline | head -20
```

- [ ] **Step 45.2: Finish per skill**

REQUIRED SUB-SKILL: Use `compass:finishing-a-development-branch` to choose merge / PR / keep / discard.

---

## Self-Review

**Spec coverage:**

| Spec section | Task(s) |
|---|---|
| §3.1 premise-check | Task 10 |
| §3.2 design-archeology | Task 11 |
| §3.3 tradeoff-matrix | Task 12 |
| §3.4 adversarial-review | Task 13 |
| §3.5 architecture-journal | Task 14 |
| §3.6 session-handoff | Task 15 |
| §3.7 invariant-scan | Task 16 |
| §3.8 complexity-budget | Task 17 |
| §4 14 absorbed skills | Tasks 18–31 |
| §5 `.architecture/` mechanism | Tasks 5–9 (template), 14 (skill), 38–42 (dogfood) |
| §6 hooks | Tasks 32–35 |
| §7 packaging | Tasks 36–37 |
| §9 dogfood `.architecture/` | Tasks 38–42 |

Every spec requirement maps to at least one task. No gaps.

**Placeholder scan:** Searched the plan for "TBD", "TODO", "implement later", "fill in". None present.

**Type consistency:** Skill names referenced by other skills always use the `compass:` prefix and exact hyphenation matching the directory name. Cross-checked: `dispatching-parallel-agents` (referenced in adversarial-review skill body) matches `skills/dispatching-parallel-agents/`. `architecture-journal` is referenced by `session-handoff`, `complexity-budget`, and the SessionStart hook — all spellings match.

**Execution handoff:** Plan complete. Two execution options:

1. **Subagent-Driven** (recommended) — dispatch a fresh subagent per task, review between tasks. REQUIRED: `compass:subagent-driven-development`.
2. **Inline Execution** — execute tasks in this session with checkpoints. REQUIRED: `compass:executing-plans`.

**Pre-execution gate:** Before running Task 1, invoke `compass:adversarial-review` on this plan with the spec attached. Document the strongest objection or its absence in `.architecture/session-handoffs/` before proceeding.