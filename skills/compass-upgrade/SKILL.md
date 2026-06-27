---
name: compass-upgrade
description: Use when the user asks to "update compass", "upgrade compass", "pull latest compass", "refresh the compass plugin", or "get the latest skills". Pulls the latest version of the Compass plugin from GitHub and syncs it to the local plugin cache.
---

# Compass Upgrade

Pulls the latest Compass plugin from GitHub and syncs it to the local plugin cache so new and updated skills are available immediately.

## Steps

### 1. Check current state

```bash
git -C ~/.claude/plugins/marketplaces/socratic-compass log --oneline -3
```

Note the current HEAD commit.

### 2. Pull latest from GitHub

```bash
git -C ~/.claude/plugins/marketplaces/socratic-compass pull origin main
```

If pull fails (conflicts, auth), report the error and stop — do not proceed to sync.

### 3. Read the new version

```bash
cat ~/.claude/plugins/marketplaces/socratic-compass/.claude-plugin/plugin.json
```

Extract the `version` field (e.g. `0.2.0`).

### 4. Sync marketplace to cache

The cache directory is version-pinned. Sync the updated marketplace content into the versioned cache path:

```bash
PLUGIN_VERSION=$(python3 -c "import json; print(json.load(open('/home/$USER/.claude/plugins/marketplaces/socratic-compass/.claude-plugin/plugin.json'))['version'])")
CACHE_DIR="$HOME/.claude/plugins/cache/socratic-compass/compass/$PLUGIN_VERSION"
mkdir -p "$CACHE_DIR"
rsync -a --delete \
  --exclude='.git' \
  "$HOME/.claude/plugins/marketplaces/socratic-compass/" \
  "$CACHE_DIR/"
echo "Synced to $CACHE_DIR"
```

### 5. Report

Tell the user:
- What version they were on vs what they're on now
- How many skills are available (`ls ~/.claude/plugins/cache/socratic-compass/compass/$PLUGIN_VERSION/skills/ | wc -l`)
- That a **session restart is required** for new skills to appear in the system-reminder

## Notes

- This skill only handles pulling from GitHub. To publish changes back to GitHub, commit from `~/.claude/plugins/marketplaces/socratic-compass/` and push.
- The `~/.claude/plugins/cache/` directory is always a mirror of the marketplace — never edit it directly.
- If the version in `plugin.json` hasn't changed, the sync still runs (idempotent). A restart is only needed if the version changed or new skill directories were added.
