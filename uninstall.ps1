# vue3-devextreme-skill uninstaller
# Usage: & "$env:TEMP\vue3-dx\uninstall.ps1" (run from the root of your project)

$TargetDir = (Get-Location).Path

# 1. Remove rules subfolder
$RulesDir = Join-Path $TargetDir ".claude\rules\vue3-devextreme"
if (Test-Path $RulesDir) {
    Remove-Item -Recurse -Force $RulesDir
    Write-Host "OK .claude/rules/vue3-devextreme/ removed"
} else {
    Write-Host "OK .claude/rules/vue3-devextreme/ not found, skipped"
}

# 2. Remove skill file
$SkillFile = Join-Path $TargetDir ".claude\skills\vue3-devextreme.md"
if (Test-Path $SkillFile) {
    Remove-Item -Force $SkillFile
    Write-Host "OK .claude/skills/vue3-devextreme.md removed"
} else {
    Write-Host "OK .claude/skills/vue3-devextreme.md not found, skipped"
}

# 3. Remove lines from CLAUDE.md
$ClaudeTarget = Join-Path $TargetDir "CLAUDE.md"
if (Test-Path $ClaudeTarget) {
    $content = Get-Content $ClaudeTarget -Raw
    # Remove the vue3-devextreme block (from the section header to /vue3-devextreme)
    $pattern = '\r?\n## Vue 3 \+ DevExtreme Rules\r?\n.*?/vue3-devextreme\r?\n'
    $cleaned = [regex]::Replace($content, $pattern, "`n", [System.Text.RegularExpressions.RegexOptions]::Singleline)
    if ($cleaned -ne $content) {
        Set-Content -Path $ClaudeTarget -Value $cleaned -NoNewline
        Write-Host "OK vue3-devextreme rules removed from CLAUDE.md"
    } else {
        Write-Host "OK CLAUDE.md did not contain vue3-devextreme rules, skipped"
    }
} else {
    Write-Host "OK CLAUDE.md not found, skipped"
}

Write-Host ""
Write-Host "Uninstall complete."
