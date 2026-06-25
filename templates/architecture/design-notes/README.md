# Design Notes

This directory holds `compass:design-archeology` outputs. Each file mirrors a source file from your project: a source file at `src/api/handlers.ts` produces design notes at `design-notes/src/api/handlers.ts.md`.

**Per-file contents:** implicit contracts callers rely on, invariants the code preserves, smells (long files, tangled responsibilities, hidden state), and implications for any proposed change.

**Staleness:** each file includes a "Last verified" header with the source SHA the notes were generated against. Downstream skills check the SHA before consuming notes; if the source has drifted, re-run `compass:design-archeology` to refresh.

See the Compass plugin's `design-archeology` skill for the discipline that produces these. Keep this README as a directory marker or remove it once you have real notes here.
