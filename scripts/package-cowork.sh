#!/usr/bin/env bash
# Compass plugin — Cowork packaging script
#
# Produces dist/compass.plugin — a zip archive of the runtime files only,
# suitable for Cowork install.
#
# Excludes (per ADR 0019, option B):
#   - .git/             — source control metadata
#   - .gitignore        — useless inside an installed plugin
#   - dist/             — build output (don't re-pack ourselves)
#   - .architecture/    — this plugin's own dogfood (visible on GitHub; not shipped)
#   - specs/            — design spec (build artifact)
#   - plans/            — implementation plan (build artifact)
#   - *.bak             — sandbox-side editor backups
#   - .DS_Store         — macOS Finder metadata
#
# Includes:
#   - plugin.json
#   - README.md, CHANGELOG.md, LICENSE, NOTICE
#   - skills/ (all 23 SKILL.md + companion files)
#   - hooks/ (4 hook scripts)
#   - templates/architecture/ (bootstrap source — required by bootstrap-architecture.sh)
#   - scripts/ (bootstrap-architecture.sh + packaging scripts)
#
# Implementation notes:
# - Files are staged in a tmpdir with explicit chmod normalization (644 for
#   regular files, 755 for *.sh and directories) before zipping. This avoids
#   the sandbox's umask 077 shipping rwx------ entries.
# - The zip is built in $TMPDIR then mv -f'd into dist/. This avoids zip's
#   "create temp + rename in place" pattern interacting badly with Windows-
#   mounted folders (UWP/virtiofs) where rename can fail with "Operation not
#   permitted" and leave a temp file behind.
#
# Exit codes:
#   0  — package built successfully
#   1  — required dependency missing or build failed
#   2  — plugin.json missing or unreadable

set -euo pipefail
umask 022

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST="$ROOT/dist"
OUT="$DIST/compass.plugin"

if ! command -v zip >/dev/null 2>&1; then
  echo "[compass] ERROR: zip not found. Install zip (apt/brew install zip) and retry." >&2
  exit 1
fi
if ! command -v tar >/dev/null 2>&1; then
  echo "[compass] ERROR: tar not found." >&2
  exit 1
fi
if [ ! -r "$ROOT/plugin.json" ]; then
  echo "[compass] ERROR: $ROOT/plugin.json not found." >&2
  exit 2
fi

mkdir -p "$DIST"

TMP_OUT="$(mktemp -u "${TMPDIR:-/tmp}/compass-XXXXXX.plugin")"
STAGE="$(mktemp -d "${TMPDIR:-/tmp}/compass-stage-XXXXXX")"
cleanup() {
  rm -f "$TMP_OUT" 2>/dev/null || true
  rm -rf "$STAGE" 2>/dev/null || true
}
trap cleanup EXIT

# Mirror the source tree into the stage, applying excludes.
( cd "$ROOT" && tar --exclude='.git' \
                    --exclude='.gitignore' \
                    --exclude='dist' \
                    --exclude='.architecture' \
                    --exclude='specs' \
                    --exclude='plans' \
                    --exclude='*.bak' \
                    --exclude='.DS_Store' \
                    -cf - . ) | ( cd "$STAGE" && tar -xf - )

# Normalize permissions.
find "$STAGE" -type d -exec chmod 755 {} +
find "$STAGE" -type f -exec chmod 644 {} +
find "$STAGE" -type f -name '*.sh' -exec chmod 755 {} +

# Build the zip from the stage (sandbox FS, no UWP friction).
( cd "$STAGE" && zip -r -q "$TMP_OUT" . )

if [ ! -s "$TMP_OUT" ]; then
  echo "[compass] ERROR: zip produced empty output." >&2
  exit 1
fi

# Replace destination atomically where the FS permits.
mv -f "$TMP_OUT" "$OUT"

echo "[compass] Built $OUT"
echo "[compass] Size: $(du -h "$OUT" | cut -f1)"
echo "[compass] Contents (top 20):"
unzip -l "$OUT" | head -22 | tail -20
