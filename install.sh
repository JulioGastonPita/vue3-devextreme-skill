#!/usr/bin/env bash
# vue3-devextreme-skill installer
# Usage: bash install.sh (run from the root of your project)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(pwd)"

if [ "$SCRIPT_DIR" = "$TARGET_DIR" ]; then
  echo "Error: run this script from your project directory, not from the skill directory." >&2
  exit 1
fi

# 1. Copy .claude/ contents
mkdir -p "$TARGET_DIR/.claude"
cp -r "$SCRIPT_DIR/.claude/." "$TARGET_DIR/.claude/"
echo "✔ .claude/ copied"

# 2. Handle CLAUDE.md
CLAUDE_TARGET="$TARGET_DIR/CLAUDE.md"
CLAUDE_LINES='@.claude/rules/dx-components.md
@.claude/rules/state-and-data.md
@.claude/rules/performance.md
@.claude/rules/code-quality.md'

SKILL_MARKER="@.claude/rules/dx-components.md"

if [ ! -f "$CLAUDE_TARGET" ]; then
  cp "$SCRIPT_DIR/CLAUDE.md" "$CLAUDE_TARGET"
  echo "✔ CLAUDE.md created"
else
  if grep -qF "$SKILL_MARKER" "$CLAUDE_TARGET"; then
    echo "✔ CLAUDE.md already contains vue3-devextreme rules, skipped"
  else
    cat >> "$CLAUDE_TARGET" <<'EOF'

## Vue 3 + DevExtreme Rules
@.claude/rules/dx-components.md
@.claude/rules/state-and-data.md
@.claude/rules/performance.md
@.claude/rules/code-quality.md

## Invoke skill for new screens
To generate a complete enterprise screen (Toolbar + Grid + CRUD popup):
/vue3-devextreme
EOF
    echo "✔ vue3-devextreme rules appended to existing CLAUDE.md"
  fi
fi

echo ""
echo "Installation complete. Run 'claude' to start."
