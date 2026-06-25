#!/usr/bin/env bash
# Compass plugin — SessionEnd hook (Claude Code only).
#
# Fires at session end. If the session made code changes, reminds to invoke
# session-handoff. Per ADRs 0003/0017: advisory only; exit 0 always.

set -u

[ -d ".architecture" ] || exit 0

# Detect whether this session made code changes. Use git status as a proxy.
CHANGED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ' || echo 0)

if [ "${CHANGED:-0}" -gt 0 ]; then
  echo "[compass] Session has uncommitted changes ($CHANGED files modified)."
  echo "[compass] Recommended: invoke compass:session-handoff before ending."
fi

exit 0
