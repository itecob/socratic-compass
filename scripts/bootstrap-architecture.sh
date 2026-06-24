#!/usr/bin/env bash
# Copies the .architecture/ template into a target project.
#
# Usage:
#   bash bootstrap-architecture.sh [target-dir]
#
# If [target-dir] is omitted, the current working directory is used.
# Refuses to overwrite an existing .architecture/ directory — back up
# or remove it first if you want to start over.

set -euo pipefail

TARGET="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../templates/architecture"

if [ ! -d "$SRC" ]; then
  echo "Bootstrap source not found: $SRC" >&2
  echo "This script must run from a complete Compass plugin install (the templates/architecture/ directory is missing)." >&2
  exit 2
fi

if [ -e "$TARGET/.architecture" ]; then
  echo "$TARGET/.architecture already exists; refusing to overwrite." >&2
  echo "Move or remove the existing directory if you want to start over." >&2
  exit 1
fi

mkdir -p "$TARGET/.architecture"
# Copy contents (including hidden files); the trailing /. after $SRC ensures we copy contents, not the directory itself
cp -r "$SRC/." "$TARGET/.architecture/"

cat <<EOF
Created $TARGET/.architecture/

Contents:
  - manifest.md         (project index — edit the "Top-level summary" section)
  - invariants.md       (what must remain true; edit to add your first INV-001)
  - conventions.md      (non-obvious idioms; edit to add your first C-001)
  - debt-log.md         (known shortcuts; edit to add your first DEBT-001)
  - scope-deferred.md   (out-of-scope insights for later)
  - decisions/0001-example.md  (example ADR; replace or supersede with your first real one)
  - interviews/         (placeholder README; first socratic-interview transcript lands here)
  - session-handoffs/   (placeholder README; first session-handoff lands here)
  - validation/         (placeholder README; phase-boundary adversarial reviews land here)

Recommended next steps:
  1. Read $TARGET/.architecture/manifest.md and replace the "Top-level summary" paragraph.
  2. Decide on your project's involvement setting. The Compass plugin uses a hybrid setting;
     see https://github.com/itecob/socratic-compass/blob/main/.architecture/decisions/0008-per-project-involvement.md
     for the reference pattern.
  3. At your next session start, invoke 'compass:architecture-journal' to load relevant context.
  4. At your first non-trivial planning task, invoke 'compass:socratic-interview' first.

Opt-outs:
  - 'scope-deferred.md' and 'validation/' are extensions Compass uses on itself
    (per Compass ADRs 0009 and 0011, extended to downstream via ADR 0013). If
    your project does not need either mechanism, you can safely delete those
    files; the rest of the architecture journal works without them.

If your project is in version control, this directory should be committed.
EOF
