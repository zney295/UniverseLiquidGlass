$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot
$fixture=Join-Path ([IO.Path]::GetTempPath()) ('UniverseLiquidGlass-test-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path (Join-Path $fixture 'chrome') -Force | Out-Null
$utf8=[Text.UTF8Encoding]::new($false)
$chromeFile=Join-Path $fixture 'chrome\userChrome.css'
$contentFile=Join-Path $fixture 'chrome\userContent.css'
$prefFile=Join-Path $fixture 'user.js'
$original='@charset "UTF-8";' + "`r`n" + '/* Existing custom theme */' + "`r`n" + ':root { --my-color: red; }'
[IO.File]::WriteAllText($chromeFile,$original,$utf8)
[IO.File]::WriteAllText($contentFile,'/* Existing content rules */',$utf8)
[IO.File]::WriteAllText($prefFile,'user_pref("browser.startup.page", 0);',$utf8)
& (Join-Path $repo 'install.ps1') -ProfilePath $fixture -WhatIf
if (Test-Path -LiteralPath (Join-Path $fixture 'chrome\UniverseLiquidGlass')) { throw 'WhatIf modified the profile' }
& (Join-Path $repo 'install.ps1') -ProfilePath $fixture
& (Join-Path $repo 'install.ps1') -ProfilePath $fixture
$installed=[IO.File]::ReadAllText($chromeFile)
if (($installed.Split([string[]]@('/* UniverseLiquidGlass */'),[StringSplitOptions]::None).Length-1) -ne 1) { throw 'Duplicate import after repeated install' }
if (-not $installed.StartsWith('@charset "UTF-8";')) { throw 'CSS charset moved' }
if (-not $installed.Contains(':root { --my-color: red; }')) { throw 'Custom CSS lost' }
if (-not [IO.File]::ReadAllText($prefFile).Contains('browser.startup.page')) { throw 'Existing preferences lost' }
if (@(Get-ChildItem -LiteralPath (Join-Path $fixture '.universe-liquid-glass-backups') -Directory).Count -ne 2) { throw 'Missing backups' }
$wallpaperSample=Join-Path $fixture 'sample-wallpaper.png'
[IO.File]::WriteAllBytes($wallpaperSample,[Convert]::FromBase64String('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jG8EAAAAASUVORK5CYII='))
1..2 | ForEach-Object { & (Join-Path $PSScriptRoot 'use-desktop-wallpaper.ps1') -ProfilePath $fixture -WallpaperPath $wallpaperSample }
$wallpaperCss=[IO.File]::ReadAllText((Join-Path $fixture 'chrome\UniverseLiquidGlass\wallpaper.css'))
if (-not $wallpaperCss.Contains('data:image/png;base64,') -or -not $wallpaperCss.Contains('@-moz-document') -or $wallpaperCss.Contains('url-prefix("http')) { throw 'Local wallpaper data scope failed' }
if (([regex]::Matches([IO.File]::ReadAllText($chromeFile),'UniverseLiquidGlass wallpaper')).Count -ne 1) { throw 'Duplicate wallpaper import' }
$later="`r`n/* Added after installation */"
[IO.File]::AppendAllText($chromeFile,$later,$utf8)
& (Join-Path $repo 'uninstall.ps1') -ProfilePath $fixture
$restored=[IO.File]::ReadAllText($chromeFile)
if ($restored -ne ($original+$later)) { throw 'Uninstall did not preserve custom CSS exactly' }
if ([IO.File]::ReadAllText($prefFile).Contains('BEGIN UniverseLiquidGlass')) { throw 'Managed preference block remains' }
if (Test-Path -LiteralPath (Join-Path $fixture 'chrome\UniverseLiquidGlass')) { throw 'Theme folder remains' }
$lock=[IO.File]::Open((Join-Path $fixture 'parent.lock'),'Create','ReadWrite','None')
try {
    $rejected=$false
    try { & (Join-Path $repo 'install.ps1') -ProfilePath $fixture } catch { $rejected=$_.Exception.Message.Contains('running or locked') }
    if (-not $rejected) { throw 'Locked profile was not rejected' }
} finally { $lock.Dispose() }

# Test multi-profile scanning for both new installations and existing profiles
$origAppData = $env:APPDATA
$testApp = Join-Path ([IO.Path]::GetTempPath()) ('zen-test-app-' + [Guid]::NewGuid().ToString('N'))
$testZen = Join-Path $testApp 'zen'
$p1 = Join-Path $testZen 'Profiles\profile-one'
$p2 = Join-Path $testZen 'Profiles\profile-two'
$p3 = Join-Path $testZen 'Profiles\profile-three-older'
New-Item -ItemType Directory -Path $p1 -Force | Out-Null
New-Item -ItemType Directory -Path $p2 -Force | Out-Null
New-Item -ItemType Directory -Path $p3 -Force | Out-Null
$iniContent = "[Install7C0FFE87499266CD]`r`nDefault=Profiles/profile-two`r`nLocked=1`r`n[Profile0]`r`nName=Profile One`r`nIsRelative=1`r`nPath=Profiles/profile-one`r`n[Profile1]`r`nName=Profile Two`r`nIsRelative=1`r`nPath=Profiles/profile-two`r`nDefault=1`r`n"
[IO.File]::WriteAllText((Join-Path $testZen 'profiles.ini'), $iniContent)
$env:APPDATA = $testApp
try {
    . (Join-Path $PSScriptRoot 'Profile.ps1')
    $targets = Get-ZenTargetProfiles
    if ($targets.Count -lt 3) { throw 'Did not scan all profiles from profiles.ini and disk Profiles folder' }
    if ($targets[0] -ne (Get-Item -LiteralPath $p2).FullName) { throw 'Active install profile was not prioritized first' }

    # Run parameterless install across all scanned profiles
    & (Join-Path $repo 'install.ps1')
    foreach ($p in @($p1, $p2, $p3)) {
        if (-not (Test-Path -LiteralPath (Join-Path $p 'chrome\UniverseLiquidGlass\install-state.json'))) {
            throw ('Theme was not applied to scanned profile: ' + $p)
        }
    }

    # Run parameterless uninstall across all scanned profiles
    & (Join-Path $repo 'uninstall.ps1')
    foreach ($p in @($p1, $p2, $p3)) {
        if (Test-Path -LiteralPath (Join-Path $p 'chrome\UniverseLiquidGlass')) {
            throw ('Theme was not removed from scanned profile: ' + $p)
        }
    }
} finally {
    $env:APPDATA = $origAppData
    Remove-Item -LiteralPath $testApp -Recurse -Force
}

Write-Host 'PASS: WhatIf, repeated install, CSS import order, backups, local wallpaper, uninstall preservation, profile lock, multi-profile scan and apply.'
Write-Host ('Test profile retained for inspection: '+$fixture)
