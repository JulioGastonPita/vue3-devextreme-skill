# vue3-devextreme-skill installer
# Usage: & "$env:TEMP\vue3-dx\install.ps1" (run from the root of your project)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$TargetDir = (Get-Location).Path

# 1. Copy .claude/ contents
$ClaudeSource = Join-Path $ScriptDir ".claude"
$ClaudeDest   = Join-Path $TargetDir ".claude"

if (-Not (Test-Path $ClaudeSource)) {
    Write-Error "Could not find .claude/ next to install.ps1. Make sure you downloaded the full skill package."
    exit 1
}

if ($ClaudeSource -ne $ClaudeDest) {
    $null = New-Item -ItemType Directory -Force -Path $ClaudeDest
    Copy-Item -Recurse "$ClaudeSource\*" "$ClaudeDest\" -Force
    Write-Host "OK .claude/ copied"
} else {
    # Script is running from inside the project — files should already be present
    $rulesOk = Test-Path (Join-Path $ClaudeDest "rules\vue3-devextreme")
    $skillOk = Test-Path (Join-Path $ClaudeDest "skills\vue3-devextreme.md")
    if ($rulesOk -and $skillOk) {
        Write-Host "OK .claude/ already in place, skipped"
    } else {
        Write-Error ".claude/ exists but skill files are missing. Re-download the skill package and try again."
        exit 1
    }
}

# 2. Handle CLAUDE.md
$ClaudeTarget = Join-Path $TargetDir "CLAUDE.md"
$SkillMarker  = "@.claude/rules/vue3-devextreme/dx-components.md"
$AppendBlock  = @"

## Vue 3 + DevExtreme Rules
@.claude/rules/vue3-devextreme/dx-components.md
@.claude/rules/vue3-devextreme/state-and-data.md
@.claude/rules/vue3-devextreme/performance.md
@.claude/rules/vue3-devextreme/code-quality.md

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
