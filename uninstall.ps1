[CmdletBinding(SupportsShouldProcess)]
param([string]$ProfilePath)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts\Profile.ps1')
$targetProfiles = Get-ZenTargetProfiles $ProfilePath
foreach ($zenProfile in $targetProfiles) {
    Assert-ProfileClosed $zenProfile
}

$foundAny = $false
foreach ($zenProfile in $targetProfiles) {
    $chrome = Join-Path $zenProfile 'chrome'
    $managed = Join-Path $chrome 'UniverseLiquidGlass'
    if (-not (Test-Path -LiteralPath (Join-Path $managed 'install-state.json'))) {
        if ($ProfilePath) {
            throw 'Managed installation not found. See the manual uninstall instructions.'
        }
        continue
    }
    $foundAny = $true
    if (-not $PSCmdlet.ShouldProcess($zenProfile,'Remove Universe Liquid Glass imports and managed theme files')) { continue }
    foreach ($file in @('userChrome.css','userContent.css')) {
        $entry = Join-Path $chrome $file
        if (Test-Path -LiteralPath $entry) { Write-Utf8 $entry (Remove-ThemeImport (Read-OptionalText $entry)) }
    }
    $userJs = Join-Path $zenProfile 'user.js'
    if (Test-Path -LiteralPath $userJs) {
        $text = [regex]::Replace((Read-OptionalText $userJs),'(?ms)^// BEGIN UniverseLiquidGlass\r?\n.*?^// END UniverseLiquidGlass\r?\n?','')
        Write-Utf8 $userJs $text
    }
    # Resolve and validate the fixed child folder before any recursive removal.
    $resolved = (Resolve-Path -LiteralPath $managed).Path
    $expected = [IO.Path]::GetFullPath((Join-Path $chrome 'UniverseLiquidGlass'))
    if (-not $resolved.Equals($expected,[StringComparison]::OrdinalIgnoreCase)) { throw 'Unexpected theme directory. Refusing removal.' }
    Remove-Item -LiteralPath $resolved -Recurse -Force
}
if (-not $foundAny -and -not $ProfilePath) {
    Write-Host 'No managed installation found in any Zen profile.'
} else {
    Write-Host 'Universe Liquid Glass removed. Other custom CSS and backups are preserved. Restart Zen.'
}
