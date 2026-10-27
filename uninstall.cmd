@echo off
setlocal
cd /d "%~dp0"

if not exist "%~dp0uninstall.ps1" (
    echo.
    echo ========================================================================
    echo  [LOI / ERROR] Khong tim thay tap tin uninstall.ps1!
    echo  Ban can giai nen toan bo tep ZIP roi moi chay uninstall.cmd.
    echo  Please extract the entire ZIP archive before running uninstall.cmd.
    echo ========================================================================
    echo.
    pause
    exit /b 1
)

:: Check if Zen Browser is running
tasklist /fi "imagename eq zen.exe" 2>NUL | find /i "zen.exe" >NUL
if "%ERRORLEVEL%"=="0" (
    echo.
    echo ========================================================================
    echo  [!] Phat hien trinh duyet Zen Browser dang hoat dong!
    echo  [!] Zen Browser is currently running!
    echo.
    echo  Vui long dong Zen Browser truoc khi go bo theme.
    echo  Please close Zen Browser completely before uninstalling.
    echo ========================================================================
    echo.
    echo  Sau khi da dong Zen Browser, nhan phim bat ky de tiep tuc...
    echo  Press any key after closing Zen to proceed...
    pause >NUL
)

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0uninstall.ps1" %*
if errorlevel 1 (
    echo.
    echo [!] Go bo gap loi. Xem thong tin o tren.
    pause
    exit /b 1
)
pause
