#!/usr/bin/env bash
# vue3-devextreme-skill installer
# Usage: bash install.sh (run from the root of your project)

TARGET_DIR="$(pwd)"
TEMP_DIR="/tmp/vue3-devextreme-skill"

# 1. Download skill files
echo "Downloading vue3-devextreme-skill..."
rm -rf "$TEMP_DIR"
npx --yes degit JulioGastonPita/vue3-devextreme-skill "$TEMP_DIR"
if [ $? -ne 0 ]; then
  echo "Error: degit failed. Make sure Node.js is installed and you have internet access." >&2
  exit 1
fi
echo "✔ downloaded"

# 2. Copy .claude/ contents
mkdir -p "$TARGET_DIR/.claude"
cp -r "$TEMP_DIR/.claude/." "$TARGET_DIR/.claude/"
echo "✔ .claude/ copied"

# 3. Handle CLAUDE.md
CLAUDE_TARGET="$TARGET_DIR/CLAUDE.md"
SKILL_MARKER="@.claude/rules/vue3-devextreme/dx-components.md"

if [ ! -f "$CLAUDE_TARGET" ]; then
  cp "$TEMP_DIR/CLAUDE.md" "$CLAUDE_TARGET"
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

# 4. Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "Installation complete. Run 'claude' to start."
