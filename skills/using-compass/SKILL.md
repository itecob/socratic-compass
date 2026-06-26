---
name: using-compass
description: Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions
---

<SUBAGENT-STOP>
If you were dispatched as a subagent to execute a specific task, skip this skill.
</SUBAGENT-STOP>

<EXTREMELY-IMPORTANT>
If you think there is even a 1% chance a skill might apply to what you are doing, you ABSOLUTELY MUST invoke the skill.

IF A SKILL APPLIES TO YOUR TASK, YOU DO NOT HAVE A CHOICE. YOU MUST USE IT.

This is not negotiable. This is not optional. You cannot rationalize your way out of this.
</EXTREMELY-IMPORTANT>

## First-load wizard (per ADR 0020)

**This section runs BEFORE any other content in this skill.**

### Detection

Check whether the project has been set up with Compass:

```
[ -d ".architecture" ] && echo "set-up" || echo "not-set-up"
```

If `.architecture/` exists, skip the wizard entirely and proceed to the "## Instruction Priority" section below.

If `.architecture/` does NOT exist, run the wizard.

### The wizard

Output this verbatim to the user, then wait for their response:

> Compass is loaded but this project hasn't been set up with Compass's memory mechanism yet. Compass's journal-grounded skills (premise-check, design-archeology, invariant-scan, complexity-budget, session-handoff, and the planning/execution skills) need an `.architecture/` directory to do their job. Skills that don't need the journal (test-driven-development, systematic-debugging, verification-before-completion, requesting-code-review, etc.) will work either way.
>
> Setting up Compass means creating an `.architecture/` directory with eleven files: a manifest, an invariants log, a conventions file, a debt log, a scope-deferred file, one example ADR (decisions/0001-example.md), and five placeholder READMEs for subdirectories that get populated over time. The bootstrap script (`scripts/bootstrap-architecture.sh`) does this in one pass. Your platform may ask you to confirm each file write — that's normal.
>
> **You have four options. Pick one:**
>
> 1. **Walk through it** — I run the bootstrap script. Your platform will prompt you for each file write. You see and authorize each one. (~12 prompts.)
> 2. **Just build it** — I run the bootstrap script and immediately write an involvement-setting ADR with "hands-off-with-receipts" so I keep proceeding without per-decision check-ins. You release control deliberately; the journal records the release.
> 3. **Skip setup for this project** — I won't bootstrap. Compass will run in degraded mode: the journal-needing skills will redirect you to invoke `compass:using-compass` again (this skill, this prompt) when they're needed. The discipline isn't gone; it's just deferred until you set it up.
> 4. **Tell me more before I decide** — I explain what `.architecture/` contains, what each file does, and why the skills need it. You can then come back to options 1-3.
>
> Which?

### Execute on user response

**On (1) — Walk through it:**
Run `bash scripts/bootstrap-architecture.sh .` (or the platform's equivalent). After it completes, say:
> Setup complete. Reading your recent messages to resume what you were trying to do.

Then proceed to the **Post-wizard resume** step below.

**On (2) — Just build it:**
Run `bash scripts/bootstrap-architecture.sh .` (or the platform's equivalent). After it completes, write `.architecture/decisions/0001-involvement-just-build-it.md` with:

```markdown
# ADR 0001: Involvement setting — hands-off-with-receipts

**Status:** accepted
**Date:** <today>
**Decided by:** H
**Context:** User selected option 2 ("just build it") in compass:using-compass's first-load wizard. They deliberately released per-decision control to the agent.
**Decision:** Involvement = hands-off-with-receipts per ADR 0008's involvement settings.
**Consequences:** Agent proceeds without per-decision check-ins. Decisions get recorded in session-handoffs/ at session end. User can change this at any time by writing a superseding ADR.
**Decided by:** H
```

Then say:
> Setup complete. Involvement: hands-off-with-receipts (you can change this at any time by writing a superseding ADR). Reading your recent messages to resume what you were trying to do.

Then proceed to **Post-wizard resume**.

**On (3) — Skip setup for this project:**
Do NOT bootstrap. Print:
> Compass running in degraded mode for this project. Skills that need `.architecture/` will redirect you here. Skills that don't need it (test-driven-development, systematic-debugging, verification-before-completion, requesting-code-review, etc.) will work normally. To set up later: invoke this skill again.

Continue with the user's original intent per **Post-wizard resume**, but DO NOT block on missing `.architecture/` — invoke whatever skill they wanted and let the per-skill error-and-redirect (per INV-026) handle the journal-needing case if it comes up.

**On (4) — Tell me more:**
Explain:
- `.architecture/manifest.md` — index of what lives in `.architecture/`. Edited as the journal grows.
- `.architecture/invariants.md` — things that must remain true; each has a verification command. Skills like `compass:invariant-scan` run these.
- `.architecture/conventions.md` — non-obvious idioms specific to this project.
- `.architecture/debt-log.md` — shortcuts you've taken and when they'll bite.
- `.architecture/scope-deferred.md` — mid-build insights that are out of scope right now.
- `.architecture/decisions/` — Architecture Decision Records, one per file. The first real ADR you'd write supersedes the example.
- `.architecture/interviews/` — socratic-interview transcripts when planning gets nontrivial.
- `.architecture/premise-checks/` — reports from `compass:premise-check` runs.
- `.architecture/design-notes/` — outputs from `compass:design-archeology` runs on existing files.
- `.architecture/session-handoffs/` — structured notes at session end. Cross-session memory.
- `.architecture/validation/` — adversarial-review outputs at phase boundaries.

Then re-display the four options and wait for their response.

### Post-wizard resume

After the wizard completes (any path), the agent reviews the last ~10 turns of the current conversation and resumes the user's original intent. Specifically:

1. Look at the user's messages in the conversation BEFORE this wizard ran.
2. If those messages contain a request that would invoke a Compass skill (e.g., "write me a plan for X" → `compass:writing-plans`, "brainstorm Y" → `compass:brainstorming`), proceed with that skill now.
3. If the recent context is ambiguous, ask: "Now that Compass is set up — was there something specific you wanted to start with?"
4. If the conversation has no pre-wizard context (the wizard ran on the user's first message), ask: "Compass is ready. What were you trying to do?"

The wizard does NOT need to remember pre-wizard state — the agent has the conversation in its working memory. The wizard is a checkpoint, not a coordinator.



## Instruction Priority

Compass skills override default system prompt behavior, but **user instructions always take precedence**:

1. **User's explicit instructions** (CLAUDE.md, GEMINI.md, AGENTS.md, direct requests) — highest priority
2. **Compass skills** — override default system behavior where they conflict
3. **Default system prompt** — lowest priority

If CLAUDE.md, GEMINI.md, or AGENTS.md says "don't use TDD" and a skill says "always use TDD," follow the user's instructions. The user is in control.

## How to Access Skills

**In Claude Code:** Use the `Skill` tool. When you invoke a skill, its content is loaded and presented to you—follow it directly. Never use the Read tool on skill files.

**In Copilot CLI:** Use the `skill` tool. Skills are auto-discovered from installed plugins. The `skill` tool works the same as Claude Code's `Skill` tool.

**In Gemini CLI:** Skills activate via the `activate_skill` tool. Gemini loads skill metadata at session start and activates the full content on demand.

**In other environments:** Check your platform's documentation for how skills are loaded.

## Platform Adaptation

Skills use Claude Code tool names. Non-CC platforms: see `references/copilot-tools.md` (Copilot CLI), `references/codex-tools.md` (Codex) for tool equivalents. Gemini CLI users get the tool mapping loaded automatically via GEMINI.md.

# Using Skills

## The Rule

**Invoke relevant or requested skills BEFORE any response or action.** Even a 1% chance a skill might apply means that you should invoke the skill to check. If an invoked skill turns out to be wrong for the situation, you don't need to use it.

```dot
digraph skill_flow {
    "User message received" [shape=doublecircle];
    "About to EnterPlanMode?" [shape=doublecircle];
    "Already brainstormed?" [shape=diamond];
    "Invoke brainstorming skill" [shape=box];
    "Might any skill apply?" [shape=diamond];
    "Invoke Skill tool" [shape=box];
    "Announce: 'Using [skill] to [purpose]'" [shape=box];
    "Has checklist?" [shape=diamond];
    "Create TodoWrite todo per item" [shape=box];
    "Follow skill exactly" [shape=box];
    "Respond (including clarifications)" [shape=doublecircle];

    "About to EnterPlanMode?" -> "Already brainstormed?";
    "Already brainstormed?" -> "Invoke brainstorming skill" [label="no"];
    "Already brainstormed?" -> "Might any skill apply?" [label="yes"];
    "Invoke brainstorming skill" -> "Might any skill apply?";

    "User message received" -> "Might any skill apply?";
    "Might any skill apply?" -> "Invoke Skill tool" [label="yes, even 1%"];
    "Might any skill apply?" -> "Respond (including clarifications)" [label="definitely not"];
    "Invoke Skill tool" -> "Announce: 'Using [skill] to [purpose]'";
    "Announce: 'Using [skill] to [purpose]'" -> "Has checklist?";
    "Has checklist?" -> "Create TodoWrite todo per item" [label="yes"];
    "Has checklist?" -> "Follow skill exactly" [label="no"];
    "Create TodoWrite todo per item" -> "Follow skill exactly";
}
```

## Red Flags

These thoughts mean STOP—you're rationalizing:

| Thought | Reality |
|---------|---------|
| "This is just a simple question" | Questions are tasks. Check for skills. |
| "I need more context first" | Skill check comes BEFORE clarifying questions. |
| "Let me explore the codebase first" | Skills tell you HOW to explore. Check first. |
| "I can check git/files quickly" | Files lack conversation context. Check for skills. |
| "Let me gather information first" | Skills tell you HOW to gather information. |
| "This doesn't need a formal skill" | If a skill exists, use it. |
| "I remember this skill" | Skills evolve. Read current version. |
| "This doesn't count as a task" | Action = task. Check for skills. |
| "The skill is overkill" | Simple things become complex. Use it. |
| "I'll just do this one thing first" | Check BEFORE doing anything. |
| "This feels productive" | Undisciplined action wastes time. Skills prevent this. |
| "I know what that means" | Knowing the concept ≠ using the skill. Invoke it. |

## Skill Priority

When multiple skills could apply, use this order:

1. **Process skills first** (brainstorming, debugging) - these determine HOW to approach the task
2. **Implementation skills second** (frontend-design, mcp-builder) - these guide execution

"Let's build X" → brainstorming first, then implementation skills.
"Fix this bug" → debugging first, then domain-specific skills.

## Skill Types

**Rigid** (TDD, debugging): Follow exactly. Don't adapt away discipline.

**Flexible** (patterns): Adapt principles to context.

The skill itself tells you which.

## User Instructions

Instructions say WHAT, not HOW. "Add X" or "Fix Y" doesn't mean skip workflows.

## Compass coupling (per ADR 0018)

This is the meta-skill that ties Compass together. At session start in any project with a `.architecture/` directory:

1. **Invoke `compass:architecture-journal` immediately.** This reads the manifest and loads the relevant subset of the journal for the current task. Without this, the agent operates blind to the project's accumulated discipline.
2. **Read the most recent 1–2 session-handoffs.** They contain the H/A/D ratio; surface that ratio if it suggests backseating. They also list the journal artifacts produced recently — the agent should know what's available.
3. **Before any planning skill, ensure `compass:socratic-interview` has been invoked for this task.** If not, run it. The interview is the entry point to the planning pipeline; downstream skills (premise-check, etc.) refuse to run without it.

In a project without `.architecture/`, print a one-time recommendation to run `bootstrap-architecture.sh` and proceed without the journal-based discipline.

The check is mandatory. The action is contextual. The choice is documented.

---

*Source attribution: this skill is adapted from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin's `using-superpowers` skill. Within the Compass plugin, references to the namespace `superpowers:` have been rewritten to `compass:` and prose mentions of "Superpowers" as a plugin name have been rewritten to "Compass". **The body of this skill has been modified beyond the standard namespace rewrite to add a "Compass coupling" section** that introduces mandatory checks of `.architecture/` artifacts (per ADRs 0017 and 0018). This footer is the canonical source citation; do not remove it on resync. When syncing from upstream, the Compass coupling section must be preserved separately.*
