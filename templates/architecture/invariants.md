# Invariants

What must remain true across changes. Each invariant has an ID, the ADR that established it, a verification command, and an on-failure note.

The point of this file: a future `compass:invariant-scan` run can execute every verification command and catch drift before it ships.

## INV-001: *(replace with your first invariant — one-sentence statement)*

**Established by:** ADR 0001 *(replace with the ADR ID that introduced this invariant)*
**Verification:** `<exact shell command — not pseudocode, not "manually check">`
**Expected:** *(what success looks like — usually empty output, exit code 0, or a specific string match)*
**On failure:** *(what to investigate, which ADR to revisit)*

<!-- Add new invariants below. Never renumber. -->
