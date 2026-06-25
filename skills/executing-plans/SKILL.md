---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute all tasks, report when complete.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

**Note:** Tell your human partner that Compass works much better with access to subagents. The quality of its work will be significantly higher if run on a platform with subagent support (such as Claude Code or Codex). If subagents are available, use compass:subagent-driven-development instead of this skill.

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Tasks

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use compass:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **compass:using-git-worktrees** - Ensures isolated workspace (creates one or verifies existing)
- **compass:writing-plans** - Creates the plan this skill executes
- **compass:finishing-a-development-branch** - Complete development after all tasks

## Compass coupling (per ADR 0018)

This skill executes a plan; before any execution begins, you must perform these checks:

1. **The plan itself.** Read it completely. Identify tasks that touch files referenced in `.architecture/debt-log.md`.
2. **`debt-log.md` for touched files.** For each file the plan will modify, grep `.architecture/debt-log.md` for the file path. Surface any existing debt entries before executing; the human should know what known issues exist in the area being touched.
3. **Involvement setting from ADR 0008.** Read `.architecture/decisions/0008-per-project-involvement.md` for the current involvement setting (high oversight / phase-level / hands-off / hybrid). Use this to determine how often to check in with the human during execution.
4. **Adversarial-review verdict (if available).** If `.architecture/validation/` has a recent adversarial-review of the plan being executed, read it. Address any unresolved concerns before continuing.

Document the result before beginning execution; surface any debt or unresolved concerns to the human first.

The check is mandatory. The action is contextual. The choice is documented.

---

*Source attribution: this skill is adapted from the [Superpowers](https://github.com/anthropic-experimental/superpowers) plugin's `executing-plans` skill. Within the Compass plugin, references to the namespace `superpowers:` have been rewritten to `compass:` and prose mentions of "Superpowers" as a plugin name have been rewritten to "Compass". **The body of this skill has been modified beyond the standard namespace rewrite to add a "Compass coupling" section** that introduces mandatory checks of `.architecture/` artifacts (per ADRs 0017 and 0018). This footer is the canonical source citation; do not remove it on resync. When syncing from upstream, the Compass coupling section must be preserved separately.*
