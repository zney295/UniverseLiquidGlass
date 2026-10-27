[CmdletBinding(SupportsShouldProcess)]
param([string]$ProfilePath,[switch]$UseDesktopWallpaper)
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'scripts\Profile.ps1')
$targetProfiles = Get-ZenTargetProfiles $ProfilePath
foreach ($zenProfile in $targetProfiles) {
    Assert-ProfileClosed $zenProfile
}
foreach ($file in @('userChrome.css','userContent.css')) {
    if (-not (Test-Path -LiteralPath (Join-Path $PSScriptRoot ('theme\' + $file)))) { throw ('Missing packaged file: ' + $file) }
}
$themeVersion = (Get-Content -LiteralPath (Join-Path $PSScriptRoot 'theme.json') -Raw | ConvertFrom-Json).version
$stamp = (Get-Date -Format 'yyyyMMdd-HHmmss') + '-' + [Guid]::NewGuid().ToString('N').Substring(0,8)

foreach ($zenProfile in $targetProfiles) {
    $chrome = Join-Path $zenProfile 'chrome'
    $managed = Join-Path $chrome 'UniverseLiquidGlass'
    $backup = Join-Path $zenProfile ('.universe-liquid-glass-backups\' + $stamp)
    if (-not $PSCmdlet.ShouldProcess($zenProfile,'Install Universe Liquid Glass and back up current CSS/user.js')) { continue }
    New-Item -ItemType Directory -Path $backup -Force | Out-Null
    New-Item -ItemType Directory -Path $chrome -Force | Out-Null
    foreach ($file in @('userChrome.css','userContent.css')) {
        $entry = Join-Path $chrome $file
        if (Test-Path -LiteralPath $entry) { Copy-Item -LiteralPath $entry -Destination (Join-Path $backup $file) }
    }
    $userJs = Join-Path $zenProfile 'user.js'
    if (Test-Path -LiteralPath $userJs) { Copy-Item -LiteralPath $userJs -Destination (Join-Path $backup 'user.js') }
    if (Test-Path -LiteralPath $managed) { Copy-Item -LiteralPath $managed -Destination (Join-Path $backup 'UniverseLiquidGlass') -Recurse }
    New-Item -ItemType Directory -Path $managed -Force | Out-Null
    foreach ($file in @('userChrome.css','userContent.css')) {
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot ('theme\' + $file)) -Destination (Join-Path $managed $file) -Force
        $entry = Join-Path $chrome $file
        $original = Remove-ThemeImport (Read-OptionalText $entry)
        $import = '@import url("UniverseLiquidGlass/' + $file + '"); /* UniverseLiquidGlass */' + "`r`n"
        # CSS imports must follow @charset, and precede @namespace and ordinary rules.
        $charset = [regex]::Match($original,'\A\s*@charset\s+[^;]+;[\r\n]*')
        $updated = if ($charset.Success) { $original.Insert($charset.Length,$import) } else { $import + $original }
        Write-Utf8 $entry $updated
    }
    $prefs = Read-OptionalText $userJs
    $prefs = [regex]::Replace($prefs,'(?ms)^// BEGIN UniverseLiquidGlass\r?\n.*?^// END UniverseLiquidGlass\r?\n?','')
    $prefs += "`r`n// BEGIN UniverseLiquidGlass`r`nuser_pref(`"toolkit.legacyUserProfileCustomizations.stylesheets`", true);`r`n// END UniverseLiquidGlass`r`n"
    Write-Utf8 $userJs $prefs
    if ($UseDesktopWallpaper) { & (Join-Path $PSScriptRoot 'scripts\use-desktop-wallpaper.ps1') -ProfilePath $zenProfile }
    Write-Utf8 (Join-Path $managed 'install-state.json') (@{version=$themeVersion;profile=$zenProfile;backup=$backup;installed=(Get-Date).ToString('o')} | ConvertTo-Json)
    Write-Host ('Installed Universe Liquid Glass in: ' + $zenProfile)
    Write-Host ('Backup: ' + $backup)
}
Write-Host 'Start Zen. Enable vertical tabs and the dark appearance for the intended look.'
