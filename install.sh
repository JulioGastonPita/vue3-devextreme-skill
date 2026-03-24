#!/usr/bin/env bash
# vue3-devextreme-skill installer
# Usage: bash /tmp/vue3-dx/install.sh (run from the root of your project)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"

# 1. Copy .claude/ contents
if [ ! -d "$SCRIPT_DIR/.claude" ]; then
  echo "Error: could not find .claude/ next to install.sh. Make sure you downloaded the full skill package." >&2
  exit 1
fi

if [ "$SCRIPT_DIR" != "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR/.claude"
  cp -r "$SCRIPT_DIR/.claude/." "$TARGET_DIR/.claude/"
  echo "✔ .claude/ copied"
else
  # Script is running from inside the project — files should already be present
  if [ -d "$TARGET_DIR/.claude/rules/vue3-devextreme" ] && [ -f "$TARGET_DIR/.claude/skills/vue3-devextreme.md" ]; then
    echo "✔ .claude/ already in place, skipped"
  else
    echo "Error: .claude/ exists but skill files are missing. Re-download the skill package and try again." >&2
    exit 1
  fi
fi

# 2. Handle CLAUDE.md
CLAUDE_TARGET="$TARGET_DIR/CLAUDE.md"
SKILL_MARKER="@.claude/rules/vue3-devextreme/dx-components.md"

if [ ! -f "$CLAUDE_TARGET" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_TARGET"
  echo "✔ CLAUDE.md created"
else
  if grep -qF "$SKILL_MARKER" "$CLAUDE_TARGET"; then
    echo "✔ CLAUDE.md already contains vue3-devextreme rules, skipped"
  else
    cat >> "$CLAUDE_TARGET" <<'EOF'

## Vue 3 + DevExtreme Rules
@.claude/rules/vue3-devextreme/dx-components.md
@.claude/rules/vue3-devextreme/state-and-data.md
@.claude/rules/vue3-devextreme/performance.md
@.claude/rules/vue3-devextreme/code-quality.md

## Invoke skill for new screens
To generate a complete enterprise screen (Toolbar + Grid + CRUD popup):
/vue3-devextreme
EOF
    echo "✔ vue3-devextreme rules appended to existing CLAUDE.md"
  fi
fi

echo ""
echo "Installation complete. Run 'claude' to start."
