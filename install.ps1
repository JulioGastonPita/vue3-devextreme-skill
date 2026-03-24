# vue3-devextreme-skill installer
# Usage: & "$env:TEMP\vue3-dx\install.ps1" (run from the root of your project)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = (Get-Location).Path

# 1. Copy .claude/ contents
$ClaudeSource = Join-Path $ScriptDir ".claude"
$ClaudeDest   = Join-Path $TargetDir ".claude"

if ($ClaudeSource -ne $ClaudeDest) {
    $null = New-Item -ItemType Directory -Force -Path $ClaudeDest
    Copy-Item -Recurse "$ClaudeSource\*" "$ClaudeDest\" -Force
    Write-Host "OK .claude/ copied"
} else {
    Write-Host "OK .claude/ already in place, skipped"
}

# 2. Handle CLAUDE.md
$ClaudeTarget = Join-Path $TargetDir "CLAUDE.md"
$SkillMarker  = "@.claude/rules/dx-components.md"
$AppendBlock  = @"

## Vue 3 + DevExtreme Rules
@.claude/rules/dx-components.md
@.claude/rules/state-and-data.md
@.claude/rules/performance.md
@.claude/rules/code-quality.md

## Invoke skill for new screens
To generate a complete enterprise screen (Toolbar + Grid + CRUD popup):
/vue3-devextreme
"@

if (-Not (Test-Path $ClaudeTarget)) {
    Copy-Item "$ScriptDir\CLAUDE.md" $ClaudeTarget
    Write-Host "OK CLAUDE.md created"
} else {
    $existing = Get-Content $ClaudeTarget -Raw
    if ($existing -like "*$SkillMarker*") {
        Write-Host "OK CLAUDE.md already contains vue3-devextreme rules, skipped"
    } else {
        Add-Content -Path $ClaudeTarget -Value $AppendBlock
        Write-Host "OK vue3-devextreme rules appended to existing CLAUDE.md"
    }
}

Write-Host ""
Write-Host "Installation complete. Run 'claude' to start."
