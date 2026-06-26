# ADR 0020: First-load onboarding wizard, hosted by `using-compass`

**Status:** accepted
**Date:** 2026-06-26
**Decided by:** H
**Related:** ADR 0006 (human-as-driver), ADR 0008 (per-project involvement), ADR 0017 (cross-platform parity), ADR 0018 (mandatory-check / conditional-action / documented-decision), DEBT-015 (architecture-journal's prior passive-recommendation behavior superseded)

**Context:** Phase 8's INV-002 standalone-install verification surfaced a real-world UX gap. When `compass:using-compass` is invoked in a project without `.architecture/`, the prior behavior is to print a *recommendation* to run `bootstrap-architecture.sh` and then proceed passively. Users ignore the recommendation; subsequent Compass skills degrade silently. The synthetic INV-014 transferability test did not catch this because the test used a fresh bootstrap as a precondition rather than exercising the missing-bootstrap path. The first real-world install on a non-Compass project caught the defect within minutes.

The Phase-8 socratic-interview with the human established six load-bearing positions:

1. **Compass owns the onboarding** rather than deferring to Cowork/Claude Code per-write platform consent prompts. A bundled walkthrough is preferable to fragmented per-file dialog boxes.
2. **Frame is informed-consent permission-unlock**, not feature-discovery. The wizard's purpose is to make the user a deliberate authorizer of system changes, not to teach them about Compass's feature set.
3. **Click-through is acceptable** when it's a deliberate release of control. "Just build it" is a valid path; default-to-agent-takes-action is not. The wizard succeeds if it has *given* users the means to be informed and stay at the helm, regardless of whether each user takes advantage.
4. **`.architecture/` existence is the consent record.** No separate state file. The wizard runs only when `.architecture/` is missing. Once it exists, the wizard never re-runs — consent has been recorded by the act of bootstrap.
5. **`compass:using-compass` is the sole wizard host.** Other Compass skills detect missing `.architecture/` and error-and-redirect to using-compass first. Conceptual duplication with the absorbed-skill prologue pattern was rejected: 23 SKILL.md files re-implementing the same wizard logic is maintenance hostile.
6. **Post-wizard auto-pivot via active-context review.** The agent re-reads recent conversation turns (heuristic: last 10) and resumes the user's original intent without state-passing. The agent's natural conversation context provides the memory; no coordination layer is needed.

**Decision:** `compass:using-compass` SKILL.md gains a "First-load wizard" section that runs when `.architecture/` is missing:

1. **Detect:** check whether `.architecture/` exists.
2. **Frame:** print a single bundled-consent message naming what `bootstrap-architecture.sh` would create (the 11-file `.architecture/` tree), naming the platform's per-write prompts that will fire and what they will create, and naming the two paths forward: (a) walk through bootstrap step-by-step, (b) "just build it" — agent runs bootstrap, picks the hybrid involvement default, and continues. Either path is a deliberate authorization; passive ignoring is not an option.
3. **Ask:** offer the user the two paths plus a third — "no, don't bootstrap; I'll run Compass in degraded mode for this session." A 4-option prompt with clear consequences.
4. **Execute on consent:**
   - **(a) Step-by-step:** invoke `bootstrap-architecture.sh`. The platform's per-write prompts fire and the user sees each file as it's created.
   - **(b) Just build it:** invoke `bootstrap-architecture.sh`, then immediately write `.architecture/decisions/0001-involvement-just-build-it.md` with `Decided by: H` and the involvement setting = "hands-off-with-receipts" (per ADR 0008).
   - **(c) Degraded mode:** print a session-once warning ("Compass running without `.architecture/`. Skills that need the journal will redirect you here again."). Do not bootstrap.
5. **Resume:** the wizard's final action is to instruct the agent to review the last ~10 conversation turns and resume the user's original intent. If no pre-wizard context exists, ask "What were you trying to do?"

Other Compass skills that consume `.architecture/` artifacts (`premise-check`, `design-archeology`, `architecture-journal`, `invariant-scan`, `complexity-budget`, `session-handoff`, and the 6 coupled absorbed skills) detect missing `.architecture/` at their top and error-and-redirect:

> "This project doesn't have `.architecture/` set up yet — Compass needs it for this skill to do its job. Run `compass:using-compass` first to authorize setup. After that completes, your original request will resume automatically."

`compass:architecture-journal` SKILL.md's prior "Bootstrap" section (which printed a passive recommendation) is rewritten to defer to `compass:using-compass`. DEBT-015 captures the supersede.

**Consequences:** Easier — first-time users get a single deliberate consent decision instead of a sequence of platform prompts. Repeat users get zero ceremony in already-bootstrapped projects. Click-through is supported (path b) and explicit. Cowork-Claude Code parity holds because the wizard lives in the SKILL.md body, not in a platform-specific hook. Harder — `using-compass` now has a wizard section that is meaningfully longer than the rest of the skill; the SKILL.md gets a real substance bump. The other ~13 dependent skills each need a 3-line error-and-redirect check at their top.

**Alternatives considered:**
- **(B from Q2) Defer to platform per-write prompts.** Rejected: per-write prompts give the user no holistic view of what Compass is going to do; they just see "create file X? create file Y? create file Z?" with no narrative. Bundled consent supports an informed walkthrough.
- **(b' hybrid from Q6) Every Compass skill checks at its top.** Rejected: 23 SKILL.md files re-implementing the same wizard logic is maintenance hostile; conceptual duplication with using-compass.
- **(α from Q7) Manual re-invoke after wizard.** Rejected: friction tax for not knowing the convention is too high. β + active-context review gives the convention discoverability AND the UX smoothness.
- **(c from Q5) Plugin-load-time wizard.** Rejected: no reliable cross-platform load-time hook exists. Wizard at first skill invocation is the workable surface.

**Invariants this creates:**
- **INV-025:** `compass:using-compass` SKILL.md contains a "First-load wizard" section that runs when `.architecture/` is missing. Verification: `grep -q "First-load wizard" skills/using-compass/SKILL.md`.
- **INV-026:** Every Compass skill that consumes `.architecture/` artifacts (the list above) contains an error-and-redirect block referencing `compass:using-compass`. Verification: `for s in premise-check design-archeology architecture-journal invariant-scan complexity-budget session-handoff brainstorming writing-plans executing-plans subagent-driven-development finishing-a-development-branch using-compass; do grep -q "compass:using-compass" "skills/$s/SKILL.md" || { echo "MISSING: $s"; exit 1; }; done; echo OK`.

**Tracked debt:**
- **DEBT-015 (logged):** `compass:architecture-journal`'s prior "Bootstrap" section printed a passive recommendation; superseded by ADR 0020 which moves the actionable wizard to using-compass. The architecture-journal section is rewritten in this commit to defer; DEBT-015 records the prior state.
- **DEBT-016 (logged):** The "last 10 turns" intent-recovery heuristic is a guess. Edge cases (fresh conversation with no pre-context, long unrelated context, multi-skill ambiguous intent) are correctable in practice — the agent can ask "you wanted X, right?" before pivoting — but the heuristic itself is not empirically tuned. v0.1.1 candidate for refinement after real-user-interview-based transferability test (DEBT-013).
