# ADR 0001: Example decision — replace this with your first real ADR

**Status:** accepted
**Date:** YYYY-MM-DD
**Decided by:** H | A | D

**Context:** Every architecture directory needs at least one ADR so newcomers see the format. Delete this file (or supersede it) when you have a real first decision.

**Decision:** Adopt the ADR format described in `manifest.md` and demonstrated by this file: sequential numbering, kebab-case title in the filename, Status/Date/Decided-by/Context/Decision/Consequences/Alternatives/Invariants sections.

**Consequences:**
- *Easier:* structural decisions become discoverable, searchable, citable.
- *Harder:* requires the discipline to actually write one when a structural decision is made.

**Alternatives considered:**
- *Free-form decision log in a single file.* Rejected: not searchable; harder to reference from invariants and other ADRs.
- *Spreadsheet of decisions.* Rejected: not greppable; mixes tabular and prose content.

**Invariants this creates:** — *(none for an example ADR; real ADRs cite the INV-NNN ids they introduce in `invariants.md`)*

## Notes for `Decided by` codes

- `H` — human decided the substance; agent surfaced options.
- `A` — agent proposed; human explicitly approved.
- `D` — delegated to agent without explicit human review.

If many recent ADRs are `A` or `D`, the project has drifted toward agent autonomy — `compass:session-handoff` will surface the ratio; revisit your involvement setting if that drift is unintentional.
