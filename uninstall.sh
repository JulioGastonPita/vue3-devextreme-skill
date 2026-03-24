#!/usr/bin/env bash
# vue3-devextreme-skill uninstaller
# Usage: bash /tmp/vue3-dx/uninstall.sh (run from the root of your project)

TARGET_DIR="$(pwd)"

# 1. Remove rules subfolder
RULES_DIR="$TARGET_DIR/.claude/rules/vue3-devextreme"
if [ -d "$RULES_DIR" ]; then
  rm -rf "$RULES_DIR"
  echo "✔ .claude/rules/vue3-devextreme/ removed"
else
  echo "✔ .claude/rules/vue3-devextreme/ not found, skipped"
fi

# 2. Remove skill folder
SKILL_DIR="$TARGET_DIR/.claude/skills/vue3-devextreme"
if [ -d "$SKILL_DIR" ]; then
  rm -rf "$SKILL_DIR"
  echo "✔ .claude/skills/vue3-devextreme/ removed"
else
  echo "✔ .claude/skills/vue3-devextreme/ not found, skipped"
fi

# 3. Remove lines from CLAUDE.md
CLAUDE_TARGET="$TARGET_DIR/CLAUDE.md"
if [ -f "$CLAUDE_TARGET" ]; then
  if grep -qF "@.claude/rules/vue3-devextreme" "$CLAUDE_TARGET"; then
    # Remove block from "## Vue 3 + DevExtreme Rules" through "/vue3-devextreme"
    perl -i -0pe 's/\n## Vue 3 \+ DevExtreme Rules\n.*?\/vue3-devextreme\n/\n/s' "$CLAUDE_TARGET"
    echo "✔ vue3-devextreme rules removed from CLAUDE.md"
  else
    echo "✔ CLAUDE.md did not contain vue3-devextreme rules, skipped"
  fi
else
  echo "✔ CLAUDE.md not found, skipped"
fi

echo ""
echo "Uninstall complete."
