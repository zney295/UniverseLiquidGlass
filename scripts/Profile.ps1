Set-StrictMode -Version Latest

function Get-ZenTargetProfiles {
    param([string]$ProfilePath)
    if ($ProfilePath) {
        $item = Get-Item -LiteralPath $ProfilePath -ErrorAction Stop
        if (-not $item.PSIsContainer) { throw 'ProfilePath must be a profile folder.' }
        return @($item.FullName)
    }

    $discovered = [System.Collections.Generic.List[string]]::new()
    $seen = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    $addCandidate = {
        param([string]$dir)
        if ([string]::IsNullOrWhiteSpace($dir)) { return }
        if (Test-Path -LiteralPath $dir -PathType Container) {
            $full = (Get-Item -LiteralPath $dir).FullName
            if ($seen.Add($full)) {
                $discovered.Add($full)
            }
        }
    }

    # 1. Parse profiles.ini if present (standard Mozilla/Zen config)
    $config = Join-Path $env:APPDATA 'zen\profiles.ini'
    if (Test-Path -LiteralPath $config) {
        $sections = @{}
        $currentSection = $null
        foreach ($line in [IO.File]::ReadAllLines($config)) {
            $trimmed = $line.Trim()
            if ($trimmed -match '^\[([^\]]+)\]$') {
                $currentSection = $Matches[1]
                $sections[$currentSection] = @{}
            } elseif ($currentSection -and $trimmed -match '^([^=]+)=(.*)$') {
                $sections[$currentSection][$Matches[1].Trim()] = $Matches[2].Trim()
            }
        }

        # 1a. Per-installation default profile (modern release/default channel)
        foreach ($k in $sections.Keys) {
            if ($k -match '^Install' -and $sections[$k].ContainsKey('Default')) {
                $rel = $sections[$k]['Default']
                $path = Join-Path (Split-Path $config) $rel
                & $addCandidate $path
            }
        }

        # 1b. Profiles explicitly flagged Default=1
        foreach ($k in $sections.Keys) {
            if ($k -match '^Profile\d+$' -and $sections[$k].ContainsKey('Default') -and $sections[$k]['Default'] -eq '1' -and $sections[$k].ContainsKey('Path')) {
                $p = $sections[$k]
                $path = if ($p['IsRelative'] -eq '1') { Join-Path (Split-Path $config) $p['Path'] } else { $p['Path'] }
                & $addCandidate $path
            }
        }

        # 1c. All other profiles listed in profiles.ini
        foreach ($k in $sections.Keys) {
            if ($k -match '^Profile\d+$' -and $sections[$k].ContainsKey('Path')) {
                $p = $sections[$k]
                $path = if ($p['IsRelative'] -eq '1') { Join-Path (Split-Path $config) $p['Path'] } else { $p['Path'] }
                & $addCandidate $path
            }
        }
    }

    # 2. Also scan disk directory %APPDATA%\zen\Profiles directly for any older or manual profiles
    $profilesDir = Join-Path $env:APPDATA 'zen\Profiles'
    if (Test-Path -LiteralPath $profilesDir -PathType Container) {
        $folders = Get-ChildItem -LiteralPath $profilesDir -Directory | Sort-Object LastWriteTime -Descending
        foreach ($f in $folders) {
            & $addCandidate $f.FullName
        }
    }

    if ($discovered.Count -eq 0) {
        throw 'No Zen profiles found. If Zen Browser is newly installed, please launch it once so it initializes a profile, then run install again.'
    }

    return $discovered.ToArray()
}

function Resolve-ZenProfile {
    param([string]$ProfilePath)
    $profiles = Get-ZenTargetProfiles $ProfilePath
    return $profiles[0]
}

function Assert-ProfileClosed {
    param([string]$ProfilePath)
    foreach ($filename in @('parent.lock','.parentlock')) {
        $lock = Join-Path $ProfilePath $filename
        if (Test-Path -LiteralPath $lock) {
            try { $stream = [IO.File]::Open($lock,'Open','ReadWrite','None'); $stream.Dispose() }
            catch { throw 'This Zen profile is running or locked. Close Zen completely before installing or removing the theme.' }
        }
    }
}

function Read-OptionalText {
    param([string]$Path)
    if (Test-Path -LiteralPath $Path) { return [IO.File]::ReadAllText($Path) }
    return ''
}

function Write-Utf8 {
    param([string]$Path,[AllowEmptyString()][string]$Text)
    [IO.File]::WriteAllText($Path,$Text,[Text.UTF8Encoding]::new($false))
}

function Remove-ThemeImport {
    param([string]$Text)
    return [regex]::Replace($Text,'(?m)^[ \t]*@import url\("UniverseLiquidGlass/(?:userChrome|userContent|wallpaper)\.css"\); /\* UniverseLiquidGlass(?: wallpaper)? \*/\r?\n?','')
}
