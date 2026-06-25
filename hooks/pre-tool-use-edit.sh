#!/usr/bin/env bash
# Compass plugin — PreToolUse hook for Edit (Claude Code only).
#
# Fires before Edit tool calls. Reads target file path from $TARGET_FILE
# environment variable (per DEBT-002, this variable name is unverified; if
# Claude Code uses a different name, the hook will silently no-op).
#
# Per ADRs 0003/0017: hook is advisory only; exits 0 always; the underlying
# discipline is in compass:design-archeology and compass:complexity-budget.

set -u

TARGET="${TARGET_FILE:-}"
[ -n "$TARGET" ] || exit 0
[ -d ".architecture" ] || exit 0

# Surface any debt-log entries that mention the target file.
if [ -f ".architecture/debt-log.md" ]; then
  match=$(grep -B1 -A6 "Files:.*$TARGET" .architecture/debt-log.md 2>/dev/null || true)
  if [ -n "$match" ]; then
    echo "[compass] Debt-log entries reference $TARGET:"
    echo "$match" | sed 's/^/[compass]   /'
    echo "[compass] Consider compass:complexity-budget before proceeding."
  fi
fi

# Surface existing design-notes for this file, if any.
NOTES=".architecture/design-notes/${TARGET}.md"
if [ -f "$NOTES" ]; then
  echo "[compass] Design-notes exist for $TARGET: $NOTES"
  echo "[compass]   compass:design-archeology should verify the SHA before consuming."
else
  # DEBT-011: session-touched-directory heuristic disabled for v0.1.0.
  # The original logic used `git log --reverse --format=%H -n 1` which returns
  # the OLDEST commit in the repo (not the session start), so the check almost
  # always fired and trained users to ignore the hook. Real fix requires
  # SessionStart to capture HEAD into `.architecture/.session-start-sha` and
  # PreToolUse to read it. Deferred to v0.1.1.
  :
fi

exit 0
