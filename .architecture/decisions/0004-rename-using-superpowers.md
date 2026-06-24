# ADR 0004: Rename absorbed `using-superpowers` to `using-compass`

**Status:** accepted
**Date:** 2026-06-24
**Context:** `using-superpowers` is the meta-skill that bootstraps the workflow. Inside this plugin, the meta-skill must point at this plugin's skills, not Superpowers'.
**Decision:** Rename to `using-compass`. Rewrite all internal references.
**Consequences:** Easier — meta-skill loop closes correctly inside the plugin. Harder — name diverges from the upstream Superpowers source, complicating future syncs.
**Alternatives considered:** Keep the name and only rewrite cross-references — rejected: ambiguous and confusing.
**Invariants this creates:** INV-004 (no skill in this plugin is named `using-superpowers`).
