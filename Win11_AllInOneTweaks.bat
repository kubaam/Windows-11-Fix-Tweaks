@echo off
setlocal EnableExtensions EnableDelayedExpansion

:: =============================================================================
:: Windows 10-11 Ultimate Optimizer & Hardener (Interactive)
:: by ambry/kubaam  •  October 2025  •  Single-file, logged, safe-by-default
:: =============================================================================
:: DISCLAIMER: This script modifies system settings and registry keys.
:: - Run as Administrator.
:: - Actions are logged to a temp logfile.
:: - Optional: create a System Restore Point and full Registry backup first.
:: Use at your own risk; test on non-production systems.
:: =============================================================================

:: ---------- Appearance ----------
color 0B
title Windows 10-11 Ultimate Optimizer ^& Hardener (Interactive)
mode con: cols=112 lines=40 >nul 2>&1

:: ---------- Globals ----------
set "AUTO=0"
set "FORCE_AUTO=0"
set "SCRIPT_DIR=%~dp0"
set "BACKUP_DIR=%TEMP%\W_Tweaks_Backups"
set "LOGFILE=%TEMP%\W_Tweaks_%RANDOM%_%RANDOM%.log"
if not exist "%BACKUP_DIR%" md "%BACKUP_DIR%" >nul 2>&1

:: ---------- Banner ----------
cls
call :Banner
echo   Log file: "%LOGFILE%"
echo =================================================================================================
echo.

:: ---------- Admin check ----------
set "ADMIN_OK=1"
net session >nul 2>&1
if errorlevel 1 (
    fsutil dirty query %systemdrive% >nul 2>&1
    if errorlevel 1 set "ADMIN_OK=0"
)
if "%ADMIN_OK%"=="0" (
    echo [ERROR] Please run this script as Administrator.
    echo         Right-click the .bat and choose "Run as administrator".
    pause
    exit /b 1
)

:: ---------- OS/version detection ----------
set "WIN_BUILD="
for /f %%B in ('powershell -NoProfile -Command "[Environment]::OSVersion.Version.Build"') do set "WIN_BUILD=%%B"
if not defined WIN_BUILD (
    for /f "tokens=3" %%a in ('reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v CurrentBuildNumber ^| findstr /I "CurrentBuildNumber"') do set "WIN_BUILD=%%a"
)
set "IS_WIN11=0"
if defined WIN_BUILD (
    if %WIN_BUILD% GEQ 22000 ( set "IS_WIN11=1" )
    call :Log "Detected OS Build: %WIN_BUILD% (IS_WIN11=%IS_WIN11%)"
) else (
    call :Log "WARN: Could not detect OS build."
)

:: ---------- Optional restore point ----------
echo Create a System Restore Point? (Y/N)
set /p "_rp= > "
if /i "%_rp%"=="Y" (
    call :CreateRestorePoint
)

:: ---------- Optional full registry backup ----------
echo Create a full Registry backup to Documents\RegistryBackup_YYYY-MM-DD_HH-mm-ss ? (Y/N)
set /p "_rb= > "
if /i "%_rb%"=="Y" (
    call :CreateRegBackup
)

:: =================================== Main Menu ===================================
:MainMenu
cls
echo =================================================================================================
echo                         Windows 10-11 Optimizer ^& Hardener - Main Menu
echo =================================================================================================
echo   1. Apply ALL Recommended Tweaks [Auto, no prompts]
echo   2. System Integrity: DISM + SFC
echo   3. Reset Windows Update Components
echo   4. Repair Microsoft Store / Re-register Apps
echo   5. Performance Tweaks (startup, shutdown, timers, responsiveness)
echo   6. Visual Effects / UI Tweaks
echo   7. Privacy ^& Security Hardening
echo   8. Remove Preinstalled Apps (Debloat - optional)
echo   9. Common Registry Tweaks (Explorer to This PC, Spotlight off)
echo  10. Advanced System Tweaks (TSC, MMCSS, LargeSystemCache, ACK freq)
echo  11. Network Fixes (reset TCP/IP, Winsock, DNS, IP renew)
echo  12. Additional Advanced Tweaks (Hibernate, Power plan, etc.)
echo  13. Optional Extras (GodMode, Error Reporting off, AutoPlay off, etc.)
echo  14. System ^& Network Maintenance Tools
echo  15. Revert BCDEdit Timer Tweaks to System Defaults
echo  16. Create System Restore Point
echo  17. Create Full Registry Backup
echo  18. Reboot System
echo  19. Exit
echo.
set /p "option=Enter your choice (1-19): "

if "%option%"=="1"  goto ApplyAll
if "%option%"=="2"  goto SFC_DISM
if "%option%"=="3"  goto WindowsUpdateReset
if "%option%"=="4"  goto StoreRepair
if "%option%"=="5"  goto PerformanceTweaks
if "%option%"=="6"  goto VisualUITweaks
if "%option%"=="7"  goto HardenPrivacy
if "%option%"=="8"  goto RemovePreApps
if "%option%"=="9"  goto CommonRegistryTweaks
if "%option%"=="10" goto AdvancedTweaks
if "%option%"=="11" goto NetworkFixes
if "%option%"=="12" goto AdditionalTweaks
if "%option%"=="13" goto OptionalTweaks
if "%option%"=="14" goto MaintenanceMenu
if "%option%"=="15" goto RevertBCDTweaks
if "%option%"=="16" goto MakeRestorePoint
if "%option%"=="17" goto MakeRegBackup
if "%option%"=="18" goto RebootSystem
if "%option%"=="19" goto ExitScript

echo [ERR] Invalid option.
pause
goto MainMenu

:: ================================= Apply All (Auto) ==============================
:ApplyAll
set "FORCE_AUTO=1"
call :PerformanceTweaks
call :VisualUITweaks
call :HardenPrivacy
call :CommonRegistryTweaks
call :AdvancedTweaks
call :NetworkFixes
call :AdditionalTweaks
set "FORCE_AUTO=0"
echo.
echo [OK] Apply All completed. Review "%LOGFILE%" for details.
pause
goto MainMenu

:: ========================== Integrity ===========================================
:SFC_DISM
cls
echo =================================================================================================
echo                           System Integrity: DISM + SFC
echo =================================================================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "DISM /ScanHealth"     "dism /online /cleanup-image /scanhealth"
    call :AskAndRun "DISM /CheckHealth"    "dism /online /cleanup-image /checkhealth"
    call :AskAndRun "DISM /RestoreHealth"  "dism /online /cleanup-image /restorehealth"
    call :AskAndRun "SFC /scannow"         "sfc /scannow"
) else (
    call :Run "dism /online /cleanup-image /scanhealth"
    call :Run "dism /online /cleanup-image /checkhealth"
    call :Run "dism /online /cleanup-image /restorehealth"
    call :Run "sfc /scannow"
)
echo [OK] Integrity repairs finished.
pause
goto MainMenu

:: ========================== Windows Update Reset ================================
:WindowsUpdateReset
cls
echo =================================================================================================
echo                          Reset Windows Update Components
echo =================================================================================================
echo Stops services, renames caches, restarts services.
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Stop WU services" ^
        "net stop wuauserv ^&^& net stop bits ^&^& net stop cryptSvc ^&^& net stop msiserver ^&^& net stop appidsvc"
) else (
    for %%S in (wuauserv bits cryptSvc msiserver appidsvc) do call :Run "net stop %%S"
)
if exist "%SystemRoot%\SoftwareDistribution" (
    call :Log "Renaming SoftwareDistribution..."
    ren "%SystemRoot%\SoftwareDistribution" "SoftwareDistribution.bak_%RANDOM%" 1>>"%LOGFILE%" 2>>&1
)
if exist "%SystemRoot%\System32\catroot2" (
    call :Log "Renaming catroot2..."
    ren "%SystemRoot%\System32\catroot2" "catroot2.bak_%RANDOM%" 1>>"%LOGFILE%" 2>>&1
)
if "%AUTO%"=="0" (
    call :AskAndRun "Start WU services" ^
        "net start wuauserv ^&^& net start bits ^&^& net start cryptSvc ^&^& net start msiserver ^&^& net start appidsvc"
) else (
    for %%S in (wuauserv bits cryptSvc msiserver appidsvc) do call :Run "net start %%S"
)
echo [OK] Windows Update components reset.
pause
goto MainMenu

:: ========================== Store/App Re-register ===============================
:StoreRepair
cls
echo =================================================================================================
echo                  Repair Microsoft Store / Re-register Built-in Apps
echo =================================================================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Re-register Microsoft Store" ^
        "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-AppxPackage *WindowsStore* ^| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register """"$($_.InstallLocation)\AppxManifest.xml""""}"""
    call :AskAndRun "Re-register ALL apps for ALL users" ^
        "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-AppxPackage -AllUsers ^| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register """"$($_.InstallLocation)\AppxManifest.xml""""}"""
) else (
    call :Run "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-AppxPackage *WindowsStore* ^| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register """"$($_.InstallLocation)\AppxManifest.xml""""}"""
    call :Run "powershell -NoProfile -ExecutionPolicy Bypass -Command ""Get-AppxPackage -AllUsers ^| ForEach-Object {Add-AppxPackage -DisableDevelopmentMode -Register """"$($_.InstallLocation)\AppxManifest.xml""""}"""
)
echo [OK] Re-registration attempted.
pause
goto MainMenu

:: ========================== Performance Tweaks ==================================
:PerformanceTweaks
cls
echo =================================================================================================
echo                        Performance Tweaks (Startup, Timers, UI)
echo =================================================================================================
call :ConfirmMode

:: Startup delay and idle wait
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" REG_DWORD 0 "Disable startup delay"
if "%IS_WIN11%"=="1" call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "WaitForIdleState" REG_DWORD 0 "Disable startup idle wait (W11)"

:: Faster shutdown timeouts
call :SafeRegAdd "HKCU\Control Panel\Desktop" "AutoEndTasks" REG_SZ 1 "Auto end tasks on shutdown"
call :SafeRegAdd "HKCU\Control Panel\Desktop" "HungAppTimeout" REG_SZ 2000 "Hung app timeout 2000 ms"
call :SafeRegAdd "HKCU\Control Panel\Desktop" "WaitToKillAppTimeout" REG_SZ 2000 "WaitToKill app timeout 2000 ms"
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" REG_SZ 2000 "Service kill timeout 2000 ms"

:: Foreground priority and gaming task tuning
call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" REG_DWORD 10 "Foreground priority (10)"
call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "GPU Priority" REG_DWORD 8 "Games GPU priority"
call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" "Priority" REG_DWORD 6 "Games CPU priority"

:: Faster menus
call :SafeRegAdd "HKCU\Control Panel\Desktop" "MenuShowDelay" REG_SZ 50 "Menu show delay 50 ms"

:: Disable network throttling
call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" REG_DWORD 4294967295 "Disable network throttling"

:: Optional timer tweaks
if "%AUTO%"=="0" (
    echo.
    echo Optional: Timer tweaks. Apply? (Y/N)
    set /p "_tt= > "
    if /i "%_tt%"=="Y" (
        call :Run "bcdedit /deletevalue useplatformclock"
        call :Run "bcdedit /set disabledynamictick yes"
    )
) else (
    call :Run "bcdedit /deletevalue useplatformclock"
    call :Run "bcdedit /set disabledynamictick yes"
)
echo [OK] Performance tweaks completed.
pause
goto MainMenu

:: ========================== Visual Effects / UI =================================
:VisualUITweaks
cls
echo =================================================================================================
echo                               Visual Effects / UI Tweaks
echo =================================================================================================
call :ConfirmMode
:: Best performance base
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" REG_DWORD 2 "Best performance visual effects"

:: Optional refined mask
if "%AUTO%"=="0" (
    echo.
    echo Optional: Apply refined UserPreferencesMask. Apply? (Y/N)
    set /p "_mask= > "
    if /i "%_mask%"=="Y" (
        call :SafeRegAdd "HKCU\Control Panel\Desktop" "UserPreferencesMask" REG_BINARY 9012038010000000 "Refined UI performance mask"
    )
) else (
    call :SafeRegAdd "HKCU\Control Panel\Desktop" "UserPreferencesMask" REG_BINARY 9012038010000000 "Refined UI performance mask"
)
echo [OK] Visual/UI tweaks applied.
pause
goto MainMenu

:: ========================== Privacy & Security ==================================
:HardenPrivacy
cls
echo =================================================================================================
echo                             Privacy ^& Security Hardening
echo =================================================================================================
call :ConfirmMode

:: Telemetry minimum
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" REG_DWORD 0 "Disable diagnostic telemetry (policy)"

:: Cortana + web search off
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" REG_DWORD 0 "Disable Cortana (policy)"
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "DisableWebSearch" REG_DWORD 1 "Disable web search in Start"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" "BingSearchEnabled" REG_DWORD 0 "Disable Bing in Search"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" "AllowSearchToUseLocation" REG_DWORD 0 "Search no location"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" "CortanaConsent" REG_DWORD 0 "Cortana consent off"

:: Location service off
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" "Status" REG_DWORD 0 "Disable system-wide location"

:: Consumer features and tips off
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableWindowsConsumerFeatures" REG_DWORD 1 "Disable suggested apps"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SubscribedContent-338389Enabled" REG_DWORD 0 "Tips off"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" REG_DWORD 0 "Suggestions off"

:: Disable telemetry services if present
call :Run "sc config DiagTrack start= disabled"
call :Run "sc stop DiagTrack"
call :Run "sc config dmwappushservice start= disabled"
call :Run "sc stop dmwappushservice"

echo [OK] Privacy hardening applied.
pause
goto MainMenu

:: ========================== Debloat (Optional) ==================================
:RemovePreApps
cls
echo =================================================================================================
echo                                Remove Preinstalled Apps
echo =================================================================================================
echo WARNING: This attempts removal for ALL users. Some apps may return after feature updates.
echo Proceed? (Y/N)
set /p "_rm= > "
if /i not "%_rm%"=="Y" (
    echo [INFO] Skipping app removal.
    pause
    goto MainMenu
)

call :ConfirmMode
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
"& {$B=@('*3DBuilder*','*3DViewer*','*bing*','*GetHelp*','*Getstarted*','*Messaging*','*MixedReality.Portal*','*Office.Hub*','*OneConnect*','*people*','*SkypeApp*','*solitaire*','*Sway*','*Wallet*','*YourPhone*','*ZuneMusic*','*ZuneVideo*','*Xbox*');"^
"foreach($a in $B){Write-Host 'Removing' $a; Get-AppxPackage -AllUsers $a | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue;"^
"Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -like $a } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue;}}" ^
1>>"%LOGFILE%" 2>>&1
if errorlevel 1 (echo [WARN] Some removals failed. See log.) else echo [OK] Debloat complete.
pause
goto MainMenu

:: ========================== Common Registry Tweaks ==============================
:CommonRegistryTweaks
cls
echo =================================================================================================
echo                                  Common Registry Tweaks
echo =================================================================================================
call :ConfirmMode
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableConsumerFeatures" REG_DWORD 1 "Disable Consumer features"
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding"     REG_DWORD 1 "Disable SoftLanding"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" REG_DWORD 1 "Explorer opens 'This PC'"
echo [OK] Common tweaks applied.
pause
goto MainMenu

:: ========================== Advanced System Tweaks ==============================
:AdvancedTweaks
cls
echo =================================================================================================
echo                               Advanced System / Registry Tweaks
echo =================================================================================================
call :ConfirmMode

:: CPU timers and boot menu
call :AskAndRun "Set tscsyncpolicy=enhanced" "bcdedit /set tscsyncpolicy enhanced"
call :AskAndRun "Delete useplatformtick (default)" "bcdedit /deletevalue useplatformtick"
call :AskAndRun "Boot menu policy legacy (F8 classic)" "bcdedit /set bootmenupolicy legacy"

:: Graphics driver preemption toggle
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" "EnablePreemption" REG_DWORD 0 "Disable graphics preemption"

:: Large system cache
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" REG_DWORD 1 "Enable LargeSystemCache"

:: Disable MMCSS (advanced)
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" "Start" REG_DWORD 4 "Disable MMCSS service"

:: Per-NIC TcpAckFrequency=1
echo.
echo Applying TcpAckFrequency=1 per network interface...
for /f "tokens=*" %%K in ('reg query "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" ^| findstr /R /C:"HKEY_LOCAL_MACHINE"') do (
    call :Log "Setting TcpAckFrequency=1 on: %%K"
    reg add "%%K" /v TcpAckFrequency /t REG_DWORD /d 1 /f 1>>"%LOGFILE%" 2>>&1
)

:: Priority separation
call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" REG_DWORD 26 "Favor foreground apps"

echo [OK] Advanced tweaks applied.
pause
goto MainMenu

:: ========================== Network Fixes =======================================
:NetworkFixes
cls
echo =================================================================================================
echo                                       Network Fixes
echo =================================================================================================
echo WARNING: This resets TCP/IP, Winsock, flushes DNS, and renews IP. You may lose connectivity briefly.
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Reset TCP/IP"   "netsh int ip reset"
    call :AskAndRun "Flush DNS"      "ipconfig /flushdns"
    call :AskAndRun "Reset Winsock"  "netsh winsock reset"
    call :AskAndRun "Release IP"     "ipconfig /release"
    call :AskAndRun "Renew IP"       "ipconfig /renew"
) else (
    call :Run "netsh int ip reset"
    call :Run "ipconfig /flushdns"
    call :Run "netsh winsock reset"
    call :Run "ipconfig /release"
    call :Run "ipconfig /renew"
)
echo [OK] Network fixes executed.
pause
goto MainMenu

:: ========================== Additional Advanced Tweaks ==========================
:AdditionalTweaks
cls
echo =================================================================================================
echo                              Additional Advanced Tweaks
echo =================================================================================================
call :ConfirmMode

:: Hibernate off
call :AskAndRun "Disable Hibernation" "powercfg /h off"

:: Ultimate Performance plan if available
call :AskAndRun "Enable Ultimate Performance power plan" ^
    "powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 ^>nul 2^>^&1 ^& powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61"

:: Optional: Disable IPv6 on all interfaces
if "%AUTO%"=="0" (
    echo.
    echo Optional: Disable IPv6 on all network interfaces? (Y/N)
    set /p "_ipv6= > "
    if /i "%_ipv6%"=="Y" (
        for /f "tokens=3,* delims= " %%A in ('netsh interface ipv6 show interfaces ^| findstr /R "^\ *[0-9]"') do (
            call :Run "netsh interface ipv6 set interface ""%%B"" admin=disabled"
        )
    )
)

:: Optional: Disable Windows Search Indexing
if "%AUTO%"=="0" (
    echo.
    echo Optional: Disable Windows Search Indexing? (Y/N)
    set /p "_ws= > "
    if /i "%_ws%"=="Y" (
        call :Run "sc config WSearch start= disabled"
        call :Run "net stop WSearch"
    )
)

:: Uninstall OneDrive
call :AskAndRun "Uninstall OneDrive" ^
    "taskkill /f /im OneDrive.exe ^>nul 2^>^&1 ^& if exist ""%SystemRoot%\SysWOW64\OneDriveSetup.exe"" (""%SystemRoot%\SysWOW64\OneDriveSetup.exe"" /uninstall) else if exist ""%SystemRoot%\System32\OneDriveSetup.exe"" (""%SystemRoot%\System32\OneDriveSetup.exe"" /uninstall)"

:: Disable Notification Center
call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" "DisableNotificationCenter" REG_DWORD 1 "Disable Action Center (HKLM)"
call :SafeRegAdd "HKCU\Software\Policies\Microsoft\Windows\Explorer"  "DisableNotificationCenter" REG_DWORD 1 "Disable Action Center (HKCU)"

:: Optional cleanup
if "%AUTO%"=="0" (
    echo.
    echo Optional: Clear TEMP, Windows\Temp, and Prefetch? (Y/N)
    set /p "_cl= > "
    if /i "%_cl%"=="Y" (
        call :Run "del /f /s /q ""%temp%\*.*"""
        call :Run "del /f /s /q ""%SystemRoot%\Temp\*.*"""
        call :Run "del /f /s /q ""%SystemRoot%\Prefetch\*.*"""
    )
)

:: Optional clear Event Logs
if "%AUTO%"=="0" (
    echo.
    echo Optional: Clear ALL Event Viewer logs? (Y/N)
    set /p "_ev= > "
    if /i "%_ev%"=="Y" (
       for /F "tokens=*" %%G in ('wevtutil el') do (
            call :Run "wevtutil cl ""%%G"""
       )
    )
)

echo [OK] Additional tweaks completed.
pause
goto MainMenu

:: ========================== Optional Extras =====================================
:OptionalTweaks
cls
echo =================================================================================================
echo                                       Optional Extras
echo =================================================================================================
call :ConfirmMode

call :AskAndRun "Remove '3D Objects' from This PC" ^
    "reg delete ""HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"" /f"

call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" REG_DWORD 1 "Hide 'Network' in nav pane"

call :AskAndRun "Hide OneDrive from Explorer nav pane" ^
    "reg add ""HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder"" /v Attributes /t REG_DWORD /d 0x00000000 /f ^& reg add ""HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder"" /v ""System.IsPinnedToNameSpaceTree"" /t REG_DWORD /d 0 /f"

call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" REG_DWORD 1 "Disable Windows Error Reporting (policy)"
call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting"         "Disabled" REG_DWORD 1 "Disable Windows Error Reporting"
call :SafeRegAdd "HKCU\Control Panel\Sound" "Beep" REG_SZ no "Disable system beep"
call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" REG_DWORD 255 "Disable AutoPlay for all drives"

call :AskAndRun "Create GodMode folder on Desktop" ^
    "if not exist ""%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"" md ""%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"""

call :SafeRegAdd "HKCU\Control Panel\Accessibility\StickyKeys"        "Flags" REG_SZ 506 "Disable StickyKeys popup"
call :SafeRegAdd "HKCU\Control Panel\Accessibility\Keyboard Response" "Flags" REG_SZ 122 "Disable FilterKeys popup"
call :SafeRegAdd "HKCU\Control Panel\Accessibility\ToggleKeys"        "Flags" REG_SZ 58  "Disable ToggleKeys popup"

echo [OK] Optional extras applied.
pause
goto MainMenu

:: ========================== Maintenance Submenu =================================
:MaintenanceMenu
cls
echo =================================================================================================
echo                               System ^& Network Maintenance
echo =================================================================================================
echo   1. Clear Temporary Files and Prefetch Cache
echo   2. Reset Network Stack (flush DNS, release/renew, winsock, ip reset)
echo.
echo   0. Back to Main Menu
echo =================================================================================================
choice /c 120 /n /m "Enter your choice: "
if errorlevel 3 goto MainMenu
if errorlevel 2 goto Tweak_NetworkReset
if errorlevel 1 goto Tweak_SystemCleanup
goto MainMenu

:Tweak_SystemCleanup
cls
echo [INFO] Clearing temporary file caches...
call :Run "del /f /s /q ""%temp%\*.*"""
call :Run "del /f /s /q ""%SystemRoot%\Temp\*.*"""
call :Run "del /f /s /q ""%SystemRoot%\Prefetch\*.*"""
echo [OK] System caches cleared.
pause
goto MaintenanceMenu

:Tweak_NetworkReset
cls
echo =================================================================================================
echo WARNING: This will reset all network settings, including static IPs and saved Wi-Fi passwords.
echo =================================================================================================
choice /c YN /m "Continue with full network reset? (Y/N): "
if errorlevel 2 goto MaintenanceMenu
call :Run "ipconfig /flushdns"
call :Run "ipconfig /release"
call :Run "ipconfig /renew"
call :Run "netsh winsock reset"
call :Run "netsh int ip reset"
echo [OK] Network stack has been reset. A reboot is recommended.
pause
goto MaintenanceMenu

:: ========================== Revert BCDEdit Tweaks ===============================
:RevertBCDTweaks
cls
echo =================================================================================================
echo                         Reverting BCDEdit Timer Tweaks to Defaults
echo =================================================================================================
call :Run "bcdedit /deletevalue useplatformclock"
call :Run "bcdedit /deletevalue disabledynamictick"
call :Run "bcdedit /deletevalue tscsyncpolicy"
call :Run "bcdedit /deletevalue useplatformtick"
echo [OK] Default timer settings restored. A reboot is recommended.
pause
goto MainMenu

:: ========================== On-demand helpers ===================================
:MakeRestorePoint
call :CreateRestorePoint
pause
goto MainMenu

:MakeRegBackup
call :CreateRegBackup
pause
goto MainMenu

:: ========================== Reboot / Exit =======================================
:RebootSystem
cls
echo =================================================================================================
echo                                      Reboot System
echo =================================================================================================
echo System will reboot in 5 seconds...
call :Log "Initiating reboot..."
timeout /t 5 >nul
shutdown /r /t 0
goto ExitScript

:ExitScript
echo.
echo Exiting. Log saved to: "%LOGFILE%"
echo Thanks for using the Windows 10-11 Ultimate Optimizer ^& Hardener.
pause
exit /b

:: ========================== Subroutines =========================================

:Banner
rem Prints banner safely from embedded data lines (#>) at the bottom of this file.
setlocal DisableDelayedExpansion
for /f "usebackq delims=" %%# in (`findstr /b "#>" "%~f0"`) do (
    set "L=%%#"
    setlocal EnableDelayedExpansion
    echo(!L:#> =!
    endlocal
)
endlocal & goto :EOF

:ConfirmMode
if "%FORCE_AUTO%"=="1" (
    set "AUTO=1"
    call :Log "Mode: Automatic (forced)"
    goto :EOF
)
echo.
echo Apply all tweaks in this category Automatically (A)
echo or Confirm each tweak Individually (I)?
choice /C AI /N /M "Choose [A/I]: "
if errorlevel 2 ( set "AUTO=0" & call :Log "Mode: Interactive" ) else ( set "AUTO=1" & call :Log "Mode: Automatic" )
goto :EOF

:AskAndRun
:: %1 = Description, %2 = Command
setlocal EnableDelayedExpansion
set "_desc=%~1"
set "_cmd=%~2"
echo.
echo [TASK] %_desc%
echo Apply? (Y/N)
set /p "_ok= > "
if /i not "!_ok!"=="Y" ( echo [SKIP] %_desc% & endlocal & goto :EOF )
call :Log "EXEC: %_desc% -> %_cmd%"
echo [RUN] %_cmd%
cmd /s /c "%_cmd%" 1>>"%LOGFILE%" 2>>&1
if errorlevel 1 ( echo [WARN] Command failed. See log. & call :Log "FAIL: %_desc%" ) else ( echo [OK] Done. & call :Log "OK: %_desc%" )
endlocal
goto :EOF

:Run
:: %1 = Command line (silent + logged)
setlocal EnableDelayedExpansion
set "_cmd=%~1"
echo.
echo [RUN] %_cmd%
call :Log "EXEC: %_cmd%"
cmd /s /c "%_cmd%" 1>>"%LOGFILE%" 2>>&1
if errorlevel 1 ( echo [WARN] Command failed. See log. & call :Log "FAIL: %_cmd%" ) else ( echo [OK] Done. & call :Log "OK: %_cmd%" )
endlocal
goto :EOF

:SafeRegAdd
:: %1 = Key, %2 = ValueName, %3 = Type, %4 = Data, %5 = Description
setlocal EnableDelayedExpansion
set "_key=%~1"
set "_val=%~2"
set "_type=%~3"
set "_data=%~4"
set "_desc=%~5"

echo.
echo [REG] %_desc%
echo [REG] Querying current: %_key%\%_val%
reg query "%_key%" /v "%_val%" >"%TEMP%\_regq.txt" 2>nul
if errorlevel 1 (
    echo [REG] Current: (not set)
) else (
    for /f "tokens=1,2,*" %%A in ('type "%TEMP%\_regq.txt" ^| findstr /I /R " %_val% "') do (
        echo [REG] Current: %%C
    )
)
del "%TEMP%\_regq.txt" >nul 2>&1

if "%AUTO%"=="0" (
    set /p "_conf=Update this registry value? (Y/N) > "
    if /i not "!_conf!"=="Y" ( echo [SKIP] %_key%\%_val% & endlocal & goto :EOF )
)

:: Export key backup
set "_bfile=%BACKUP_DIR%\%_val%_%RANDOM%.reg"
reg export "%_key%" "%_bfile%" /y >nul 2>&1
call :Log "Backup: %_key% -> %_bfile%"

:: Apply value
call :Log "REG ADD: ""%_key%"" /v ""%_val%"" /t %_type% /d %_data% /f"
reg add "%_key%" /v "%_val%" /t %_type% /d %_data% /f 1>>"%LOGFILE%" 2>>&1
if errorlevel 1 ( echo [WARN] Failed to update %_val%. See log. & call :Log "FAIL REG: %_key%\%_val%" ) else ( echo [OK] Updated %_val%. & call :Log "OK REG: %_key%\%_val%" )
endlocal
goto :EOF

:CreateRestorePoint
echo [INFO] Creating System Restore Point...
call :Log "Creating system restore point..."
powershell -NoProfile -ExecutionPolicy Bypass -Command "Checkpoint-Computer -Description 'W_Optimizer_Restore' -RestorePointType 'MODIFY_SETTINGS'" 1>>"%LOGFILE%" 2>>&1
if errorlevel 1 (echo [WARN] Restore point creation may have failed. See log.) else echo [OK] Restore point created.
goto :EOF

:CreateRegBackup
echo [INFO] Creating full Registry backup...
set "TS="
for /f "usebackq delims=" %%T in (`powershell -NoProfile -Command "(Get-Date).ToString('yyyy-MM-dd_HH-mm-ss')"`) do set "TS=%%T"
if not defined TS set "TS=unknown"
set "REG_BK_DIR=%USERPROFILE%\Documents\RegistryBackup_%TS%"
mkdir "%REG_BK_DIR%" >nul 2>&1
if not exist "%REG_BK_DIR%" ( echo [ERROR] Failed to create backup directory. & call :Log "ERROR: mkdir %REG_BK_DIR%" & goto :EOF )
echo [INFO] Backing up to: %REG_BK_DIR%
reg export HKCR "%REG_BK_DIR%\HKCR.reg" /y >nul
reg export HKCU "%REG_BK_DIR%\HKCU.reg" /y >nul
reg export HKLM "%REG_BK_DIR%\HKLM.reg" /y >nul
reg export HKU  "%REG_BK_DIR%\HKU.reg"  /y >nul
reg export HKCC "%REG_BK_DIR%\HKCC.reg" /y >nul
echo [OK] Registry backup completed.
call :Log "Registry backup -> %REG_BK_DIR%"
goto :EOF

:Log
:: %* = message
setlocal EnableDelayedExpansion
echo [!date! !time!] %*>>"%LOGFILE%"
endlocal
goto :EOF

:: ========================== Data block for banner ===============================
#> =================================================================================================
#>   __        __         _           _                  ____   _       _             _
#>   \ \      / /__  _ __| |__   __ _| |_ ___  _ __     / ___| | |_ ___| |_ _ __ __ _| | ___  _ __
#>    \ \ /\ / / _ \| '__| '_ \ / _` | __/ _ \| '_ \   | |  _  | __/ __| __| '__/ _` | |/ _ \| '__|
#>     \ V  V / (_) | |  | | | | (_| | || (_) | | | |  | |_| | | |_\__ \ |_| | | (_| | | (_) | |
#>      \_/\_/ \___/|_|  |_| |_|\__,_|\__\___/|_| |_|   \____|  \__|___/\__|_|  \__,_|_|\___/|_|
#> -------------------------------------------------------------------------------------------------
#>   Windows 10-11 Ultimate Optimizer & Hardener  •  Interactive or Automatic  •  Logged operations
#> =================================================================================================
