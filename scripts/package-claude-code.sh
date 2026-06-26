#!/usr/bin/env bash
# Compass plugin — Claude Code packaging script
#
# Produces dist/compass-claude-code/ — a clean directory copy of the runtime
# files, suitable for installation into a Claude Code plugins directory.
#
# Excludes (per ADR 0019, option B):
#   - .git/             — source control metadata
#   - .gitignore        — useless inside an installed plugin
#   - dist/             — build output
#   - .architecture/    — this plugin's own dogfood
#   - specs/            — design spec (build artifact)
#   - plans/            — implementation plan (build artifact)
#   - *.bak             — sandbox-side editor backups
#   - .DS_Store         — macOS Finder metadata
#
# rsync runs with --delete so stale files in dist/compass-claude-code/ from
# a prior build are removed when their source is removed upstream.
#
# umask 022 + post-rsync chmod normalization ensures shipped files are
# world-readable (644) and *.sh world-executable (755) even when the
# sandbox or builder uses a restrictive umask.
#
# Exit codes:
#   0  — directory built successfully
#   1  — required dependency missing or build failed
#   2  — plugin.json missing or unreadable

set -euo pipefail
umask 022

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DIST="$ROOT/dist"
OUT="$DIST/compass-claude-code"

if ! command -v rsync >/dev/null 2>&1; then
  echo "[compass] ERROR: rsync not found. Install rsync (apt/brew install rsync) and retry." >&2
  echo "[compass]   On Windows native Git Bash without rsync, install Git for Windows" >&2
  echo "[compass]   with the optional Unix tools, or use WSL." >&2
  exit 1
fi
if [ ! -r "$ROOT/.claude-plugin/plugin.json" ]; then
  echo "[compass] ERROR: $ROOT/.claude-plugin/plugin.json not found." >&2
  exit 2
fi

mkdir -p "$DIST"
mkdir -p "$OUT"

rsync -a --delete \
  --exclude='.git/' \
  --exclude='.gitignore' \
  --exclude='dist/' \
  --exclude='.architecture/' \
  --exclude='specs/' \
  --exclude='plans/' \
  --exclude='*.bak' \
  --exclude='.DS_Store' \
  "$ROOT/" "$OUT/"

# Normalize permissions.
find "$OUT" -type d -exec chmod 755 {} +
find "$OUT" -type f -exec chmod 644 {} +
find "$OUT" -type f -name '*.sh' -exec chmod 755 {} +

echo "[compass] Built $OUT"
echo "[compass] Size: $(du -sh "$OUT" | cut -f1)"
echo "[compass] Top-level contents:"
ls -1 "$OUT" | sed 's/^/[compass]   /'
echo ""
echo "[compass] Install: copy the directory into your Claude Code plugins directory"
echo "[compass]          (or symlink it for development)."
