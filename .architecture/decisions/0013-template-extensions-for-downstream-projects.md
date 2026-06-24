# ADR 0013: Extend ADRs 0009 and 0011 mechanisms into the default template for downstream projects

**Status:** accepted
**Date:** 2026-06-24
**Decided by:** H

**Context:** The Phase 2 adversarial subagent review (`.architecture/validation/phase-02-2026-06-24-2014.md`) flagged that the bootstrap template (`templates/architecture/`) ships `scope-deferred.md` and `validation/README.md` as default files, but the source ADRs that authorize those mechanisms (ADR 0009 — scope discipline; ADR 0011 — meta-validation methodology) were written specifically for the *Compass build itself*. They do not, on their face, mandate the same mechanisms for every project that uses Compass downstream.

The reviewer characterized this as overreach: extending build-local mechanisms into a universal template without explicit ADR-level justification. The reviewer is correct that this needs explicit ADR coverage rather than being silently absorbed.

The substantive question: are these mechanisms useful enough for downstream projects that they should be the default, or specialized enough that they should be opt-in?

## Analysis

**`scope-deferred.md` (per ADR 0009):** the mechanism for capturing mid-build insights that are out-of-current-scope but might matter later. ADR 0009 was written in response to per-skill mini-interviews creating scope-creep risk during the Compass build. The mechanism generalizes cleanly: any project doing planning-then-execution has scope-creep risk at the planning/execution boundary; any project with mid-work insights needs a place to capture them without acting on them. The format (`SD-NNN: date / source / insight / suggested resolution`) is content-agnostic. Downstream applicability: high.

**`validation/` directory + adversarial subagent at phase boundaries (per ADR 0011):** the mechanism for non-circular validation of work-in-progress. ADR 0011 was written because Compass is being built using its own discipline, creating a circular-validation risk. The mechanism — dispatching a Claude subagent with fresh context to evaluate artifacts against spec — generalizes to any project that produces artifacts against a spec, regardless of whether the project is the meta-tool. The discipline does require Claude (or a comparable LLM subagent capability) to be available, which is true for any project that uses Compass at all (Compass requires Claude). Downstream applicability: high, with the caveat that the project must have some form of spec or plan to evaluate against.

**The reviewer's concern, restated:** the source ADRs do not declare themselves universal. Extending them silently could mean every downstream project gets machinery they didn't ask for and don't understand.

**Counter-position:** the bootstrap is *opt-in already*. A user must explicitly run `scripts/bootstrap-architecture.sh` to get any of this. If they then look at the bootstrapped `.architecture/` and decide they don't want `scope-deferred.md` or `validation/`, they can delete those files. The cost of including them is one decision per file ("keep or delete"). The cost of *not* including them is a downstream project that uses Compass but doesn't get the discipline that made Compass work.

## Decision

Ship `scope-deferred.md` and `validation/README.md` as default contents of the bootstrap template. Both are extensions of the canonical `.architecture/` layout established by spec §3.5; both are mechanisms the Compass plugin uses on itself; both generalize cleanly to downstream projects.

Document the opt-out clearly: the bootstrap script's printed instructions should mention that these two files can be removed if the project doesn't need the corresponding discipline. The current bootstrap script's "Recommended next steps" does not currently make this clear — add a one-line note to step 1 or step 4 covering the opt-out.

Also: the source ADRs (0009 and 0011) should each gain a one-paragraph "Downstream applicability" addendum acknowledging that the mechanism is extended to the default template via this ADR. That makes the relationship between source ADR and template content auditable from either direction.

## Consequences

**Easier:** downstream projects using Compass get the full discipline that made Compass work, without having to read all of Compass's own ADRs to know what's recommended. The template is a complete starting point. The opt-out keeps the cost low for users who don't need the machinery.

**Harder:** projects that bootstrap and never touch `scope-deferred.md` or `validation/` carry two empty/instructional files forever. The maintenance burden is near zero (markdown files don't rot), but the visual noise is real for users who never engage with these mechanisms. The opt-out instruction must be clear enough that users know they can delete safely.

## Alternatives considered

- **Ship only spec §3.5's literal layout; don't include scope-deferred or validation in the default template.** Rejected: downstream projects lose discipline that the meta-tool itself relies on. Forces every downstream project to re-discover the mechanisms.
- **Ship them as separate optional templates the user invokes by name (e.g., `bootstrap-architecture.sh --with-validation`).** Considered. Adds flag complexity to the bootstrap script for minor benefit. The "delete files you don't want" opt-out is simpler and matches the convention of other plugin bootstrap tools (rails, create-react-app, etc., that ship more than the minimum).
- **Document the extension only in the bootstrap script's output, not in a new ADR.** Rejected: that's exactly the silent-absorption pattern ADR 0009 warns against. Extension is a structural decision; structural decisions get ADRs.

## Invariants this creates

- **INV-017:** ADRs 0009 and 0011 each include a "Downstream applicability" note referencing this ADR. Verification: `grep -l "Downstream applicability" .architecture/decisions/0009*.md .architecture/decisions/0011*.md` returns both files.
- **INV-018:** The bootstrap script's printed instructions explicitly mention the opt-out for `scope-deferred.md` and `validation/`. Verification: `grep -E '(scope-deferred|validation).*opt.out|remove' scripts/bootstrap-architecture.sh` returns at least one match.

## Follow-up tasks (Phase 2 polish, before commit)

1. Add "Downstream applicability" paragraph to ADR 0009.
2. Add "Downstream applicability" paragraph to ADR 0011.
3. Update `scripts/bootstrap-architecture.sh` printed instructions to mention the opt-out.
4. Update `.architecture/manifest.md` to index ADR 0013.
5. Update `.architecture/invariants.md` to add INV-017 and INV-018.
