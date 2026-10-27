[CmdletBinding(SupportsShouldProcess)]
param([string]$ProfilePath,[string]$WallpaperPath)
$ErrorActionPreference='Stop'
. (Join-Path $PSScriptRoot 'Profile.ps1')
$targetProfiles=Get-ZenTargetProfiles $ProfilePath
if (-not $WallpaperPath) {
    $WallpaperPath=(Get-ItemProperty -LiteralPath 'HKCU:\Control Panel\Desktop').WallPaper
    if (-not $WallpaperPath -or -not (Test-Path -LiteralPath $WallpaperPath -PathType Leaf)) {
        $WallpaperPath=Join-Path $env:APPDATA 'Microsoft\Windows\Themes\TranscodedWallpaper'
    }
}
$bytes=[IO.File]::ReadAllBytes((Get-Item -LiteralPath $WallpaperPath -ErrorAction Stop).FullName)
if ($bytes.Length -lt 12) { throw 'Wallpaper file is empty or unsupported.' }
$mime=if ($bytes[0] -eq 0xff -and $bytes[1] -eq 0xd8) { 'image/jpeg' }
elseif ($bytes[0] -eq 0x89 -and $bytes[1] -eq 0x50) { 'image/png' }
elseif ($bytes[0] -eq 0x42 -and $bytes[1] -eq 0x4d) { 'image/bmp' }
elseif ([Text.Encoding]::ASCII.GetString($bytes,8,4) -eq 'WEBP') { 'image/webp' }
else { throw 'Wallpaper must be a JPEG, PNG, BMP or WebP image.' }

$data='url("data:'+$mime+';base64,'+[Convert]::ToBase64String($bytes)+'")'
# Restrict private image data to browser chrome and internal blank/new-tab pages.
# A normal website must never inherit a variable containing the user's wallpaper.
$css='/* Personal wallpaper, local to this Zen profile. Do not publish this file. */' + "`n" +
  '@-moz-document url-prefix("chrome://browser/"),url("about:blank"),url("about:newtab"),url("about:home"),url("about:privatebrowsing") {' + "`n" +
  '  :root { --cosmos-wallpaper: '+$data+' !important; }' + "`n}`n"

foreach ($zenProfile in $targetProfiles) {
    if (-not $PSCmdlet.ShouldProcess($zenProfile,'Use current desktop image as a local Zen wallpaper')) { continue }
    $chrome=Join-Path $zenProfile 'chrome'
    $folder=Join-Path $chrome 'UniverseLiquidGlass'
    New-Item -ItemType Directory -Path $folder -Force | Out-Null
    $target=Join-Path $folder 'wallpaper.css'
    if (Test-Path -LiteralPath $target) { Copy-Item -LiteralPath $target -Destination ($target+'.backup-'+(Get-Date -Format 'yyyyMMdd-HHmmss')) }
    Write-Utf8 $target $css
    foreach ($name in @('userChrome.css','userContent.css')) {
        $path=Join-Path $chrome $name
        $text=Read-OptionalText $path
        $text=[regex]::Replace($text,'(?m)^[ \t]*@import url\("UniverseLiquidGlass/wallpaper\.css"\); /\* UniverseLiquidGlass wallpaper \*/\r?\n?','')
        $line='@import url("UniverseLiquidGlass/wallpaper.css"); /* UniverseLiquidGlass wallpaper */' + "`r`n"
        $charset=[regex]::Match($text,'\A\s*@charset\s+[^;]+;[\r\n]*')
        if ($charset.Success) { $text=$text.Insert($charset.Length,$line) } else { $text=$line+$text }
        Write-Utf8 $path $text
    }
}
Write-Host 'Desktop wallpaper copied into a private, local CSS setting. Restart Zen to apply.'
Write-Host 'Run this command again after changing the desktop wallpaper. It is not synchronized automatically.'
