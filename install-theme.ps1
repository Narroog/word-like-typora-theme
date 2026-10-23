[CmdletBinding()]
param(
    [string]$ThemeDirectory = (Join-Path $env:APPDATA 'Typora/themes')
)
$ErrorActionPreference = 'Stop'
$themeSource = Join-Path $PSScriptRoot 'word-like.css'
if (-not (Test-Path -LiteralPath $themeSource -PathType Leaf)) {
    throw "Missing theme: $themeSource"
}
[void](New-Item -ItemType Directory -Path $ThemeDirectory -Force)
$themeTarget = Join-Path $ThemeDirectory 'word-like.css'
if (Test-Path -LiteralPath $themeTarget) {
    $backupTarget = "$themeTarget.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss-fff')"
    Copy-Item -LiteralPath $themeTarget -Destination $backupTarget
    Write-Output "Previous version saved: $backupTarget"
}
Copy-Item -LiteralPath $themeSource -Destination $themeTarget
Write-Output "Installed: $themeTarget"
Write-Output 'Restart Typora and select Themes > Word Like.'
