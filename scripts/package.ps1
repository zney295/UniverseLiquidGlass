$ErrorActionPreference='Stop'
$repo=Split-Path $PSScriptRoot
$manifest=Get-Content -LiteralPath (Join-Path $repo 'theme.json') -Raw | ConvertFrom-Json
$dist=Join-Path $repo 'dist'
New-Item -ItemType Directory -Path $dist -Force | Out-Null
$zip=Join-Path $dist ('UniverseLiquidGlass-v'+$manifest.version+'.zip')
if (Test-Path -LiteralPath $zip) { Remove-Item -LiteralPath $zip -Force }
$stage=Join-Path $dist ('package-'+[Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $stage | Out-Null
try {
    $items=@('theme','scripts','src','docs','install.ps1','install.cmd','uninstall.ps1','uninstall.cmd','README.md','LICENSE','CHANGELOG.md','theme.json') | ForEach-Object { Join-Path $repo $_ }
    foreach ($item in $items) {
        $files=if ((Get-Item -LiteralPath $item).PSIsContainer) { Get-ChildItem -LiteralPath $item -File -Recurse } else { Get-Item -LiteralPath $item }
        foreach ($file in $files) {
            if ($file.Extension -eq '.pyc' -or $file.FullName.Contains('\__pycache__\')) { continue }
            $relative=$file.FullName.Substring($repo.Length).TrimStart('\','/')
            $target=Join-Path $stage $relative
            New-Item -ItemType Directory -Path (Split-Path $target) -Force | Out-Null
            Copy-Item -LiteralPath $file.FullName -Destination $target
        }
    }
    Compress-Archive -Path (Join-Path $stage '*') -DestinationPath $zip -Force
} finally {
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
}
Get-FileHash -LiteralPath $zip -Algorithm SHA256
