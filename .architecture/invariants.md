# Invariants

What must remain true across changes. Each invariant has an ID, the ADR that established it, a verification command, and an on-failure note.

## INV-001: Every absorbed skill has cross-references rewritten to `compass:`
**Established by:** ADR 0001
**Verification:** `! grep -rEn '\bsuperpowers\b' skills/ 2>/dev/null | grep -vF 'Source attribution' | grep -vF 'anthropic-experimental/superpowers'`
**Expected:** No matches (empty output, exit 0 on the filtered grep). Two classes of citation are excluded as intentional: attribution-footer lines that cite the original namespace, and lines containing the upstream GitHub URL fragment `anthropic-experimental/superpowers`. The verification now catches both `superpowers:` (namespace prefix) and bare `superpowers` (path component), which the original rewrite missed (caught by Phase 4 adversarial review).
**On failure:** Re-run the rewrite step for the offending skill; see ADR 0001 and the implementation plan's Phase 4.

## INV-002: Plugin installs and functions on a system without Superpowers
**Established by:** ADR 0002
**Verification:** Manual: install in a clean environment and invoke `using-compass`. Automated proxy: every skill referenced by another in `skills/` exists within `skills/` (no external skill references).
**Expected:** No external dependencies; all referenced skills resolve within the plugin.
**On failure:** A skill references an external resource; absorb it or remove the reference.

## INV-003: Every hook script exits 0 regardless of detection
**Established by:** ADR 0003
**Verification:** `for f in hooks/*.sh; do bash -n "$f" && bash "$f" </dev/null >/dev/null 2>&1; echo "$f exit=$?"; done | grep -v 'exit=0' || echo OK`
**Expected:** Output is `OK`.
**On failure:** A hook is blocking. Make it advisory (exit 0).

## INV-004: No skill in this plugin is named `using-superpowers`
**Established by:** ADR 0004
**Verification:** `! [ -d skills/using-superpowers ]`
**Expected:** Directory does not exist.
**On failure:** Delete or rename; see ADR 0004.

## INV-005: Every absorbed `SKILL.md` ends with the attribution footer
**Established by:** ADR 0005
**Verification:** `for s in brainstorming writing-plans executing-plans subagent-driven-development test-driven-development systematic-debugging verification-before-completion requesting-code-review receiving-code-review dispatching-parallel-agents using-git-worktrees finishing-a-development-branch writing-skills using-compass; do grep -q "Source attribution: this skill is adapted from" "skills/$s/SKILL.md" 2>/dev/null || { echo "MISSING: $s"; exit 1; }; done; echo OK`
**Expected:** Output is `OK`.
**On failure:** Re-run the attribution footer step (Task 31a in the plan) for the offending skill; see ADR 0005.

## INV-006: Every plan has a corresponding interview transcript
**Established by:** ADR 0006
**Verification:** Manual at plan-write time; for plans in `plans/*.md`, check that a transcript from the same date exists in `.architecture/interviews/`.
**Expected:** Each plan has a matching transcript.
**On failure:** Back-fill the transcript or explicitly document why the interview was skipped (per the per-task opt-out in `socratic-interview`).

## INV-007: No new invariant from this ADR — premise-check uses INV-006 indirectly
**Established by:** ADR 0007
**Verification:** —
**Expected:** —
**On failure:** —

## INV-008: Every project has a recorded involvement setting
**Established by:** ADR 0008
**Verification:** `grep -q "Initial setting for this project" .architecture/decisions/0008-per-project-involvement.md`
**Expected:** Match found.
**On failure:** The involvement setting is missing from ADR 0008. Add it or write an addendum.

## INV-009: Every per-skill mini-interview opens with a scope statement
**Established by:** ADR 0009
**Verification:** Manual; agent self-checks each per-skill interview against the rule in ADR 0009 Layer 1.
**Expected:** Each interview begins with "The plan says this skill exists to do X. We're discussing how, not whether."
**On failure:** Restart the interview from the scope statement.

## INV-010: Mid-build structural insights produce an ADR or a `scope-deferred.md` entry
**Established by:** ADR 0009
**Verification:** Manual; reviewed at each phase boundary.
**Expected:** No silent absorption of structural drift.
**On failure:** Audit recent ADRs and the most recent session-handoff; back-fill any uncaptured drift.

## INV-011: Every new skill is built via a mini-interview probing the Skill Build Checklist
**Established by:** ADR 0010
**Verification:** Manual; each new skill in `skills/` should have a paragraph in its corresponding section of the relevant session-handoff explaining which checklist areas were probed.
**Expected:** All nine new skills have such a record.
**On failure:** Build that skill again via the checklist; archive the previous draft if relevant.

## INV-012: Every phase boundary produces an adversarial subagent evaluation
**Established by:** ADR 0011
**Verification:** `ls .architecture/validation/phase-*.md | wc -l` should equal the number of completed phases (1–8).
**Expected:** One evaluation file per completed phase.
**On failure:** Run the adversarial subagent dispatch for the missing phase before continuing to the next.

## INV-013: Build success criteria are spec §11's seven criteria, unrevised
**Established by:** ADR 0011
**Verification:** `diff specs/2026-06-24-compass-design.md.criteria-snapshot specs/2026-06-24-compass-design.md` (the snapshot file is captured at the start of the build; any change to §11 must produce a supersede ADR).
**Expected:** No diff in §11, or a supersede ADR explaining the change.
**On failure:** Either revert the §11 change or write the supersede ADR.

## INV-014: Transferability test runs before declaring the plugin ready to ship
**Established by:** ADR 0011
**Verification:** `[ -f .architecture/validation/transferability-*.md ]`
**Expected:** At least one transferability test result file exists before any "release" or "ship" action.
**On failure:** Do not ship. Run the transferability test on a non-Compass problem and capture the result.

## INV-015: README and CHANGELOG match plan Task 3 / Task 4 drafts at Phase 8 completion
**Established by:** ADR 0012
**Verification:** At Phase 8, diff the shipped `README.md` and `CHANGELOG.md` against the plan-drafted forms (in `plans/2026-06-24-compass-plan.md` Tasks 3 and 4).
**Expected:** Shipped forms converge to the plan-drafted release forms before any tag is created.
**On failure:** Rewrite README and CHANGELOG to the plan-drafted forms; do not release until they match.

## INV-016: Each phase from Phase 1 forward produces exactly one consolidated commit
**Established by:** ADR 0012
**Verification:** `git log --oneline` shows one commit per phase boundary, with a phase prefix in the commit message.
**Expected:** Phases 1–8 each have exactly one commit; the architecture bootstrap has one commit; planning artifacts have one commit. Roughly 10 commits total for the full build.
**On failure:** If multiple commits exist within a phase, consider squashing before the next phase begins.

## INV-017: ADRs 0009 and 0011 include "Downstream applicability" addenda referencing ADR 0013
**Established by:** ADR 0013
**Verification:** `[ "$(grep -l 'Downstream applicability' .architecture/decisions/0009*.md .architecture/decisions/0011*.md 2>/dev/null | wc -l)" = "2" ]`
**Expected:** Both files contain the addendum.
**On failure:** Add the missing addendum to the offending ADR; see ADR 0013.

## INV-018: Bootstrap script's printed instructions include an "Opt-outs" section for `scope-deferred.md` and `validation/`
**Established by:** ADR 0013
**Verification:** `grep -c 'Opt-outs' scripts/bootstrap-architecture.sh`
**Expected:** Output is `1` or more.
**On failure:** Restore the Opt-outs section to the script's heredoc'd "Recommended next steps" output.

## INV-019: Every `compass:premise-check` invocation produces a file in `.architecture/premise-checks/`
**Established by:** ADR 0014
**Verification:** At session-handoff time, the count of files in `.architecture/premise-checks/` equals the count of premise-check invocations recorded in the session-handoffs across the project history.
**Expected:** Counts match.
**On failure:** Back-fill the missing premise-check artifact(s) from the corresponding interview transcript and session-handoff.

## INV-020: Every `.architecture/design-notes/<path>.md` includes source-path header + "Last verified" SHA line
**Established by:** ADR 0015
**Verification:** `for f in .architecture/design-notes/**/*.md; do head -3 "$f" | grep -q "Last verified" || { echo "MISSING header in $f"; exit 1; }; done; echo OK` (or, when no design-notes exist yet, the check passes trivially).
**Expected:** Output is `OK`.
**On failure:** Re-run `compass:design-archeology` on the offending source path to regenerate with the correct header.

## INV-021: Spec §3.5 is rewritten before any release tag to include the four post-spec additions
**Established by:** ADR 0016
**Verification:** At Phase 8, `grep -E '(scope-deferred|validation/|premise-checks|design-notes)' specs/2026-06-24-compass-design.md | wc -l` should return at least 4.
**Expected:** All four post-spec directories/files appear in §3.5.
**On failure:** Do not tag. Rewrite §3.5 to include the additions per ADR 0016's enumerated table.

## INV-022: Spec §3.3 (design-archeology) is rewritten before any release tag to enumerate the four output sub-sections
**Established by:** ADR 0016
**Verification:** At Phase 8, `grep -E "(Implicit Contracts|Implications for the Proposed Change)" specs/2026-06-24-compass-design.md` returns matches.
**Expected:** §3.3 lists the four sub-sections.
**On failure:** Do not tag. Rewrite §3.3 per ADR 0016 Part 2.

## INV-023: Every coupled absorbed skill carries a "Compass coupling" section in its SKILL.md body
**Established by:** ADR 0017
**Verification:** `grep -l "Compass coupling" skills/brainstorming/SKILL.md skills/writing-plans/SKILL.md skills/executing-plans/SKILL.md skills/subagent-driven-development/SKILL.md skills/finishing-a-development-branch/SKILL.md skills/using-compass/SKILL.md 2>/dev/null | wc -l`
**Expected:** Output is `6`.
**On failure:** Re-add the missing coupling section per ADR 0018's table.

## INV-024: Coupled skills' coupling sections instruct the agent to perform the check and document the decision
**Established by:** ADR 0018
**Verification:** For each of the 6 coupled skills, `grep -E "(mandatory|must check|document.*decision)" skills/<name>/SKILL.md` returns at least one match.
**Expected:** All 6 coupled skills satisfy the discipline-keyword check.
**On failure:** Strengthen the coupling section's language to make the check mandatory and the decision documented (per ADR 0018).
