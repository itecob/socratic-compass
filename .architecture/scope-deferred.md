# Scope Deferred

Mid-build insights that surfaced during per-skill mini-interviews and were genuinely out of scope for the moment but might matter later. Reviewed at each phase boundary as candidate ADR material (per ADR 0009 Layer 2).

Format per entry:
```
## SD-NNN: <one-line summary>
**Date:** YYYY-MM-DD
**Source:** <which skill or session was being worked on>
**Insight:** <one sentence>
**Suggested resolution:** revise spec | new ADR | discard | revisit at phase boundary
```

---

## SD-001: Plan ordering of `.architecture/` setup
**Date:** 2026-06-24
**Source:** First execution session (interview about "build the plugin")
**Insight:** The plan puts plugin `.architecture/` dogfood in Phase 7 (Tasks 38–42), but `.architecture/` must exist before Phase 1 because every skill we write references it. We worked around this by bootstrapping `.architecture/` immediately. The plan itself needs a Phase 0 or a reordering.
**Suggested resolution:** revise spec / plan — add a Phase 0 explicitly, or move the .architecture/ bootstrap to the start of Phase 1.

<!-- New entries appended below. Never renumber. -->
