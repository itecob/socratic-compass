#!/usr/bin/env bash
# Compass plugin — SessionStart hook (Claude Code only).
#
# Fires at the start of a Claude Code session. Per ADR 0017, hooks are
# reinforcement; per ADR 0003, hooks print reminders and always exit 0.
#
# The underlying enforcement lives in skill bodies (using-compass, etc.) so
# Cowork users get the same discipline through skill invocation. This hook is
# pure printed-text convenience for Claude Code.

set -u

if [ ! -d ".architecture" ]; then
  # Project hasn't been bootstrapped. Suggest it.
  echo "[compass] No .architecture/ directory in this project."
  echo "[compass] To enable Compass's planning and architectural-memory discipline, run:"
  echo "[compass]   bash <path-to-compass>/scripts/bootstrap-architecture.sh ."
  exit 0
fi

echo "[compass] .architecture/ present. Recommended: invoke compass:architecture-journal to load relevant context."

# Surface recent activity in each journal directory so the agent knows what exists.
if [ -d ".architecture/interviews" ]; then
  LATEST_INTERVIEW=$(ls -1t .architecture/interviews/*.md 2>/dev/null | head -1)
  [ -n "$LATEST_INTERVIEW" ] && echo "[compass]   Latest interview: $LATEST_INTERVIEW"
fi
if [ -d ".architecture/premise-checks" ]; then
  LATEST_PC=$(ls -1t .architecture/premise-checks/*.md 2>/dev/null | head -1)
  [ -n "$LATEST_PC" ] && echo "[compass]   Latest premise-check: $LATEST_PC"
fi
if [ -d ".architecture/session-handoffs" ]; then
  LATEST_HO=$(ls -1t .architecture/session-handoffs/*.md 2>/dev/null | head -1)
  [ -n "$LATEST_HO" ] && echo "[compass]   Latest session-handoff: $LATEST_HO"
fi
if [ -d ".architecture/validation" ]; then
  LATEST_VAL=$(ls -1t .architecture/validation/phase-*.md 2>/dev/null | head -1)
  [ -n "$LATEST_VAL" ] && echo "[compass]   Latest phase validation: $LATEST_VAL"
fi

exit 0
