# vue3-devextreme-skill installer
# Usage: .\install.ps1 (run from the root of your project)

$TargetDir = (Get-Location).Path
$TempDir   = Join-Path $env:TEMP "vue3-devextreme-skill"

# 1. Download skill files
Write-Host "Downloading vue3-devextreme-skill..."
if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }
npx --yes degit JulioGastonPita/vue3-devextreme-skill $TempDir
if ($LASTEXITCODE -ne 0) {
    Write-Error "degit failed. Make sure Node.js is installed and you have internet access."
    exit 1
}
Write-Host "OK downloaded"

# 2. Copy .claude/ contents
$ClaudeSource = Join-Path $TempDir ".claude"
$ClaudeDest   = Join-Path $TargetDir ".claude"
$null = New-Item -ItemType Directory -Force -Path $ClaudeDest
Copy-Item -Recurse "$ClaudeSource\*" "$ClaudeDest\" -Force
Write-Host "OK .claude/ copied"

# 3. Handle CLAUDE.md
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
    Copy-Item "$TempDir\CLAUDE.md" $ClaudeTarget
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

# 4. Cleanup
Remove-Item -Recurse -Force $TempDir

Write-Host ""
Write-Host "Installation complete. Run 'claude' to start."
