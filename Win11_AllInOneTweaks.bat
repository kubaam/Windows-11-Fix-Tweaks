@echo off
:: Set a friendly color: Black background (0) with Aqua text (B)
color 0B

:: Initialize variables
set AUTO=0

title Windows 10/11 Ultimate Fix and Tweaks (Interactive Version)
echo ============================================================
echo         Windows 10/11 Ultimate Fix and Tweaks Interactive
echo                   by ambry/kubaam
echo ============================================================
echo.
echo WARNING: This script modifies system settings and registry keys.
echo It is HIGHLY recommended that you create a system restore point
echo and back up your registry before running any tweaks.
echo.
:: Check for Administrator rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] This script must be run as Administrator.
    pause
    exit /b
)

:: Optional: Create a System Restore Point
echo Would you like to create a System Restore Point? (Y/N)
set /p rchoice= 
if /i "%rchoice%"=="Y" (
    echo [INFO] Creating restore point...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Checkpoint-Computer -Description 'Win11_UltimateTweaks' -RestorePointType 'MODIFY_SETTINGS'"
    echo [INFO] Restore point created.
    timeout /t 2 >nul
)

:MainMenu
cls
echo ============================================================
echo         Windows 10/11 Tweaks Main Menu
echo ============================================================
echo.
echo 1. Run SFC and DISM (System Integrity)
echo 2. Reset Windows Update Components
echo 3. Repair Microsoft Store and Re-register Apps
echo 4. Apply Performance Tweaks
echo 5. Adjust Visual Effects and Basic UI Tweaks
echo 6. Apply Privacy Tweaks
echo 7. Remove Preinstalled Apps (Optional)
echo 8. Apply Common Registry Tweaks
echo 9. Apply Advanced System and Registry Tweaks
echo 10. Apply Network Fixes
echo 11. Apply Additional Advanced Tweaks
echo 12. Apply Even More Optional Tweaks
echo 13. Reboot System
echo 14. Exit
echo.
set /p option="Enter your choice (1-14): "

if "%option%"=="1" goto SFC_DISM
if "%option%"=="2" goto WindowsUpdateReset
if "%option%"=="3" goto StoreRepair
if "%option%"=="4" goto PerformanceTweaks
if "%option%"=="5" goto VisualUITweaks
if "%option%"=="6" goto PrivacyTweaks
if "%option%"=="7" goto RemovePreApps
if "%option%"=="8" goto CommonRegistryTweaks
if "%option%"=="9" goto AdvancedTweaks
if "%option%"=="10" goto NetworkFixes
if "%option%"=="11" goto AdditionalTweaks
if "%option%"=="12" goto OptionalTweaks
if "%option%"=="13" goto RebootSystem
if "%option%"=="14" goto ExitScript
echo Invalid option.
pause
goto MainMenu

:SFC_DISM
cls
echo ============================================================
echo       Running SFC and DISM Checks
echo ============================================================
echo.
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Running System File Checker (SFC /scannow)" "sfc /scannow"
    call :AskAndRun "Running DISM scanhealth" "dism /online /cleanup-image /scanhealth"
    call :AskAndRun "Running DISM checkhealth" "dism /online /cleanup-image /checkhealth"
    call :AskAndRun "Running DISM restorehealth" "dism /online /cleanup-image /restorehealth"
) else (
    echo [INFO] Running SFC /scannow...
    sfc /scannow
    echo [INFO] Running DISM scanhealth...
    dism /online /cleanup-image /scanhealth
    echo [INFO] Running DISM checkhealth...
    dism /online /cleanup-image /checkhealth
    echo [INFO] Running DISM restorehealth...
    dism /online /cleanup-image /restorehealth
)
pause
goto MainMenu

:WindowsUpdateReset
cls
echo ============================================================
echo       Resetting Windows Update Components
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Stopping Windows Update services" "net stop wuauserv >nul 2>&1 && net stop cryptSvc >nul 2>&1 && net stop bits >nul 2>&1 && net stop msiserver >nul 2>&1"
    call :AskAndRun "Deleting SoftwareDistribution folder" "rd /s /q %systemroot%\SoftwareDistribution >nul 2>&1"
    call :AskAndRun "Deleting catroot2 folder" "rd /s /q %systemroot%\system32\catroot2 >nul 2>&1"
    call :AskAndRun "Restarting Windows Update services" "net start wuauserv >nul 2>&1 && net start cryptSvc >nul 2>&1 && net start bits >nul 2>&1 && net start msiserver >nul 2>&1"
) else (
    echo [INFO] Stopping Windows Update services...
    net stop wuauserv >nul 2>&1
    net stop cryptSvc >nul 2>&1
    net stop bits >nul 2>&1
    net stop msiserver >nul 2>&1
    echo [INFO] Deleting SoftwareDistribution folder...
    rd /s /q %systemroot%\SoftwareDistribution >nul 2>&1
    echo [INFO] Deleting catroot2 folder...
    rd /s /q %systemroot%\system32\catroot2 >nul 2>&1
    echo [INFO] Restarting Windows Update services...
    net start wuauserv >nul 2>&1
    net start cryptSvc >nul 2>&1
    net start bits >nul 2>&1
    net start msiserver >nul 2>&1
)
pause
goto MainMenu

:StoreRepair
cls
echo ============================================================
echo   Repairing Microsoft Store and Re-registering Apps
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Re-registering Microsoft Store" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \\\"$($_.InstallLocation)\\\\AppxManifest.xml\\\"}\""
    call :AskAndRun "Re-registering apps for all users" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \\\"$($_.InstallLocation)\\\\AppxManifest.xml\\\"}\""
) else (
    echo [INFO] Re-registering Microsoft Store...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\\AppxManifest.xml\"}"
    echo [INFO] Re-registering apps for all users...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\\AppxManifest.xml\"}"
)
pause
goto MainMenu

:PerformanceTweaks
cls
echo ============================================================
echo         Applying Performance Tweaks
echo ============================================================
echo.
call :ConfirmMode
if "%AUTO%"=="0" (
    :: Use safe registry update for performance-related keys.
    call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" "StartupDelayInMSec" REG_DWORD 0 "Disabling startup delay"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control" "WaitToKillServiceTimeout" REG_SZ 2000 "Speeding up shutdown (WaitToKillServiceTimeout = 2000ms)"
    call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "SystemResponsiveness" REG_DWORD 10 "Prioritizing foreground apps (SystemResponsiveness = 10)"
    call :SafeRegAdd "HKCU\Control Panel\Desktop" "MenuShowDelay" REG_SZ 100 "Reducing menu show delay (MenuShowDelay = 100)"
    call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" "NetworkThrottlingIndex" REG_DWORD 4294967295 "Disabling network throttling"
    call :AskAndRun "Optimizing HPET and dynamic tick settings" "bcdedit /deletevalue useplatformclock >nul 2>&1 && bcdedit /set disabledynamictick yes >nul 2>&1"
) else (
    echo [INFO] Disabling startup delay...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul
    echo [INFO] Speeding up shutdown...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul
    echo [INFO] Prioritizing foreground apps...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul
    echo [INFO] Reducing menu show delay...
    reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 100 /f >nul
    echo [INFO] Disabling network throttling...
    reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul
    echo [INFO] Optimizing HPET and dynamic tick settings...
    bcdedit /deletevalue useplatformclock >nul 2>&1
    bcdedit /set disabledynamictick yes >nul 2>&1
)
echo [INFO] Performance tweaks applied.
pause
goto MainMenu

:VisualUITweaks
cls
echo ============================================================
echo   Adjusting Visual Effects and Basic UI Tweaks
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" "VisualFXSetting" REG_DWORD 2 "Setting VisualFXSetting to 2 (best performance)"
    echo [WARNING] Adjusting UserPreferencesMask may cause visual glitches.
    call :SafeRegAdd "HKCU\Control Panel\Desktop" "UserPreferencesMask" REG_BINARY 90120000 "Adjusting UserPreferencesMask for optimized UI"
) else (
    echo [INFO] Setting VisualFXSetting to 2...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
    echo [WARNING] Adjusting UserPreferencesMask may cause visual glitches.
    echo [INFO] Adjusting UserPreferencesMask...
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120000 /f >nul
)
echo [INFO] Visual and UI tweaks applied.
pause
goto MainMenu

:PrivacyTweaks
cls
echo ============================================================
echo            Applying Privacy Tweaks
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" REG_DWORD 0 "Disabling Telemetry"
    call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" "AllowCortana" REG_DWORD 0 "Disabling Cortana"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" "Status" REG_DWORD 0 "Disabling system-wide location service"
) else (
    echo [INFO] Disabling Telemetry...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul
    echo [INFO] Disabling Cortana...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f >nul
    echo [INFO] Disabling system-wide location service...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f >nul
)
echo [INFO] Privacy tweaks applied.
pause
goto MainMenu

:RemovePreApps
cls
echo ============================================================
echo         Remove Preinstalled Apps (Optional)
echo ============================================================
echo This section can remove some preinstalled apps (e.g., Xbox, Bing News, etc.).
echo WARNING: These commands remove apps permanently.
echo Do you want to proceed? (Y/N)
set /p removeapps=
if /i not "%removeapps%"=="Y" (
    echo [INFO] Skipping removal of preinstalled apps.
    pause
    goto MainMenu
)
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Removing Xbox app" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *xboxapp* | Remove-AppxPackage\""
    call :AskAndRun "Removing Bing News" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *bingnews* | Remove-AppxPackage\""
    call :AskAndRun "Removing Bing Weather" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *bingweather* | Remove-AppxPackage\""
    call :AskAndRun "Removing Zune Video" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *zunevideo* | Remove-AppxPackage\""
    call :AskAndRun "Removing Solitaire Collection" "powershell -NoProfile -ExecutionPolicy Bypass -command \"Get-AppxPackage *solitairecollection* | Remove-AppxPackage\""
) else (
    echo [INFO] Removing preinstalled apps...
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
    powershell -NoProfile -ExecutionPolicy Bypass -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
)
echo [INFO] Preinstalled apps removal executed.
pause
goto MainMenu

:CommonRegistryTweaks
cls
echo ============================================================
echo         Applying Common Registry Tweaks
echo ============================================================
call :ConfirmMode
:: (Consider backing up affected registry keys before applying these tweaks)
if "%AUTO%"=="0" (
    call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableConsumerFeatures" REG_DWORD 1 "Disabling Lock Screen Ads and Spotlight (DisableConsumerFeatures)"
    call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableSoftLanding" REG_DWORD 1 "Disabling Lock Screen Ads and Spotlight (DisableSoftLanding)"
    call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "LaunchTo" REG_DWORD 1 "Setting File Explorer to open 'This PC' by default"
) else (
    echo [INFO] Disabling Lock Screen Ads and Spotlight...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f >nul
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f >nul
    echo [INFO] Setting File Explorer to open 'This PC' by default...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f >nul
)
echo [INFO] Common registry tweaks applied.
pause
goto MainMenu

:AdvancedTweaks
cls
echo ============================================================
echo    Applying Advanced System and Registry Tweaks
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Setting TSC Synchronization Policy to enhanced" "bcdedit /set tscsyncpolicy enhanced >nul 2>&1"
    call :AskAndRun "Removing UsePlatformTick value" "bcdedit /deletevalue useplatformtick >nul 2>&1"
    call :AskAndRun "Setting Boot Menu Policy to legacy" "bcdedit /set bootmenupolicy legacy >nul 2>&1"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" "EnablePreemption" REG_DWORD 0 "Disabling Graphics Driver Preemption"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" "LargeSystemCache" REG_DWORD 1 "Enabling Large System Cache"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" "Start" REG_DWORD 4 "Disabling Multimedia Class Scheduler (MMCSS)"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" "TcpAckFrequency" REG_DWORD 1 "Optimizing TCP Ack Frequency"
    call :AskAndRun "Disabling Diagnostic Tracking and dmwappushservice" "sc config DiagTrack start= disabled >nul 2>&1 && sc config dmwappushservice start= disabled >nul 2>&1"
    call :SafeRegAdd "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" "Win32PrioritySeparation" REG_DWORD 26 "Adjusting Win32PrioritySeparation for gaming"
) else (
    echo [INFO] Setting TSC Synchronization Policy to enhanced...
    bcdedit /set tscsyncpolicy enhanced >nul 2>&1
    echo [INFO] Removing UsePlatformTick value...
    bcdedit /deletevalue useplatformtick >nul 2>&1
    echo [INFO] Setting Boot Menu Policy to legacy...
    bcdedit /set bootmenupolicy legacy >nul 2>&1
    echo [INFO] Disabling Graphics Driver Preemption...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul
    echo [INFO] Enabling Large System Cache...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul
    echo [INFO] Disabling Multimedia Class Scheduler (MMCSS)...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\MMCSS" /v Start /t REG_DWORD /d 4 /f >nul
    echo [INFO] Optimizing TCP Ack Frequency...
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul
    echo [INFO] Disabling Diagnostic Tracking and dmwappushservice...
    sc config DiagTrack start= disabled >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
    echo [INFO] Adjusting Win32PrioritySeparation for gaming...
    reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul
)
echo [INFO] Advanced tweaks applied.
pause
goto MainMenu

:NetworkFixes
cls
echo ============================================================
echo         Applying Network Fixes
echo ============================================================
echo WARNING: Network settings will be reset and connectivity may be temporarily lost.
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Resetting TCP/IP stack" "netsh int ip reset >nul"
    call :AskAndRun "Flushing DNS" "ipconfig /flushdns >nul"
    call :AskAndRun "Resetting Winsock" "netsh winsock reset >nul"
    call :AskAndRun "Releasing IP address" "ipconfig /release >nul"
    call :AskAndRun "Renewing IP address" "ipconfig /renew >nul"
) else (
    echo [INFO] Resetting TCP/IP stack...
    netsh int ip reset >nul
    echo [INFO] Flushing DNS...
    ipconfig /flushdns >nul
    echo [INFO] Resetting Winsock...
    netsh winsock reset >nul
    echo [INFO] Releasing IP address...
    ipconfig /release >nul
    echo [INFO] Renewing IP address...
    ipconfig /renew >nul
)
echo [INFO] Network fixes applied.
pause
goto MainMenu

:AdditionalTweaks
cls
echo ============================================================
echo       Applying Additional Advanced Tweaks
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Disabling Hibernation" "powercfg /h off"
    call :AskAndRun "Enabling Ultimate Performance Power Plan" "powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1 && powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1"
    call :AskAndRun "Disabling IPv6 on all interfaces" "for /F \"skip=3 tokens=1,*\" %%A in ('netsh interface ipv6 show interfaces') do (netsh interface ipv6 set interface \"%%B\" admin=disabled >nul 2>&1)"
    call :AskAndRun "Disabling Windows Search Indexing" "sc config WSearch start= disabled >nul 2>&1 && net stop WSearch >nul 2>&1"
    call :AskAndRun "Uninstalling OneDrive" "taskkill /f /im OneDrive.exe >nul 2>&1 && %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1"
    call :AskAndRun "Disabling Action Center and Notification Center" "reg add \"HKCU\Software\Policies\Microsoft\Windows\Explorer\" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Clearing Temp and Prefetch folders" "del /f /s /q \"%temp%\*.*\" >nul 2>&1 && del /f /s /q \"%SystemRoot%\Temp\*.*\" >nul 2>&1 && del /f /s /q \"%SystemRoot%\Prefetch\*.*\" >nul 2>&1"
    call :AskAndRun "Clearing ALL Event Logs" "for /F \"tokens=*\" %%G in ('wevtutil el') do (wevtutil cl \"%%G\" >nul 2>&1)"
) else (
    echo [INFO] Disabling Hibernation...
    powercfg /h off
    echo [INFO] Enabling Ultimate Performance Power Plan...
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    echo [INFO] Disabling IPv6 on all interfaces...
    for /F "skip=3 tokens=1,*" %%A in ('netsh interface ipv6 show interfaces') do (
        netsh interface ipv6 set interface "%%B" admin=disabled >nul 2>&1
    )
    echo [INFO] Disabling Windows Search Indexing...
    sc config WSearch start= disabled >nul 2>&1
    net stop WSearch >nul 2>&1
    echo [INFO] Uninstalling OneDrive...
    taskkill /f /im OneDrive.exe >nul 2>&1
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
    echo [INFO] Disabling Action Center and Notification Center...
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul
    echo [INFO] Clearing Temp and Prefetch folders...
    del /f /s /q "%temp%\*.*" >nul 2>&1
    del /f /s /q "%SystemRoot%\Temp\*.*" >nul 2>&1
    del /f /s /q "%SystemRoot%\Prefetch\*.*" >nul 2>&1
    echo [INFO] Clearing ALL Event Logs...
    for /F "tokens=*" %%G in ('wevtutil el') do (wevtutil cl "%%G" >nul 2>&1)
)
echo [INFO] Additional advanced tweaks applied.
pause
goto MainMenu

:OptionalTweaks
cls
echo ============================================================
echo         Applying Even More Optional Tweaks
echo ============================================================
call :ConfirmMode
if "%AUTO%"=="0" (
    call :AskAndRun "Removing '3D Objects' folder from This PC" "reg delete \"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}\" /f >nul 2>nul"
    call :SafeRegAdd "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" REG_DWORD 1 "Removing 'Network' icon from Navigation Pane"
    call :AskAndRun "Hiding OneDrive from Navigation Pane" "reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v Attributes /t REG_DWORD /d 0x00000000 /f >nul && reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v \"System.IsPinnedToNameSpaceTree\" /t REG_DWORD /d 0 /f >nul"
    call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" "Disabled" REG_DWORD 1 "Disabling Windows Error Reporting"
    call :SafeRegAdd "HKCU\Control Panel\Sound" "Beep" REG_SZ no "Disabling system beep on errors"
    call :SafeRegAdd "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" "NoDriveTypeAutoRun" REG_DWORD 255 "Disabling AutoPlay for all drives"
    call :AskAndRun "Creating 'God Mode' folder on Desktop" "if not exist \"%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}\" md \"%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}\""
    call :SafeRegAdd "HKCU\Control Panel\Accessibility\StickyKeys" "Flags" REG_SZ 506 "Disabling Sticky/Filter/Toggle Keys popups (StickyKeys)"
    call :SafeRegAdd "HKCU\Control Panel\Accessibility\Keyboard Response" "Flags" REG_SZ 122 "Disabling Sticky/Filter/Toggle Keys popups (Keyboard Response)"
    call :SafeRegAdd "HKCU\Control Panel\Accessibility\ToggleKeys" "Flags" REG_SZ 58 "Disabling Sticky/Filter/Toggle Keys popups (ToggleKeys)"
) else (
    echo [INFO] Removing '3D Objects' folder...
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f >nul 2>nul
    echo [INFO] Removing 'Network' icon from Navigation Pane...
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f >nul
    echo [INFO] Hiding OneDrive from Navigation Pane...
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v Attributes /t REG_DWORD /d 0x00000000 /f >nul
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f >nul
    echo [INFO] Disabling Windows Error Reporting...
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f >nul
    echo [INFO] Disabling system beep on errors...
    reg add "HKCU\Control Panel\Sound" /v Beep /t REG_SZ /d no /f >nul
    echo [INFO] Disabling AutoPlay for all drives...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f >nul
    echo [INFO] Creating 'God Mode' folder on Desktop...
    if not exist "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" md "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"
    echo [INFO] Disabling Sticky/Filter/Toggle Keys popups...
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f >nul
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f >nul
    reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f >nul
)
echo [INFO] Optional tweaks applied.
pause
goto MainMenu

:RebootSystem
cls
echo ============================================================
echo             Rebooting System
echo ============================================================
echo Your system will reboot in 5 seconds...
timeout /t 5 >nul
shutdown /r /t 0
goto ExitScript

:ExitScript
echo.
echo Exiting script. Thank you for using Windows 10/11 Ultimate Fix and Tweaks.
echo Developed by ambry/kubaam.
pause
exit /b

:: ------------------------------------------------------
:: Subroutine: ConfirmMode
:: Asks if the user wants to apply all tweaks automatically (A)
:: or confirm each tweak individually (I).
:ConfirmMode
echo.
echo Would you like to apply all tweaks in this category automatically (A)
echo or confirm each tweak individually (I)?
choice /C AI /M "Choose [A/I]: "
if errorlevel 2 (
    set "AUTO=0"
) else (
    set "AUTO=1"
)
goto :EOF

:: ------------------------------------------------------
:: Subroutine: AskAndRun
:: %1 = Tweak description
:: %2 = Command to execute
:AskAndRun
echo [INFO] Starting: %~1
if "%AUTO%"=="0" (
    set /p confirm="Apply this tweak? (Y/N): "
    if /i not "%confirm%"=="Y" goto :AskAndRunEnd
) else (
    echo [INFO] Automatically applying tweak: %~1
)
setlocal enabledelayedexpansion
set "TWEAK_CMD=%~2"
echo [INFO] Executing: !TWEAK_CMD!
cmd /s /c !TWEAK_CMD!
if errorlevel 1 echo [WARNING] Command failed: !TWEAK_CMD!
endlocal
:AskAndRunEnd
goto :EOF

:: ------------------------------------------------------
:: Subroutine: SafeRegAdd
:: Safely updates a registry value by first querying the current setting.
:: Parameters:
::   %1 = Registry key (e.g., HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize)
::   %2 = Value name (e.g., StartupDelayInMSec)
::   %3 = Type (e.g., REG_DWORD, REG_SZ, REG_BINARY)
::   %4 = Data to set (e.g., 0, 2000, 90120000)
::   %5 = Description of the tweak
:SafeRegAdd
echo.
echo [INFO] %~5
echo [INFO] Querying current value of %~1\%~2 ...
reg query "%~1" /v %~2 >temp_reg.txt 2>nul
if errorlevel 1 (
    echo [INFO] Value does not exist; it will be created.
) else (
    for /f "tokens=2,*" %%A in ('findstr /r /c:"%~2" temp_reg.txt') do (
        set "CURRENT=%%B"
    )
    echo [INFO] Current value: %CURRENT%
)
del temp_reg.txt
set /p safeconfirm="Do you want to update this registry value? (Y/N): "
if /i not "%safeconfirm%"=="Y" goto :EOF
echo [INFO] Updating registry...
reg add "%~1" /v %~2 /t %~3 /d %~4 /f
if errorlevel 1 (
   echo [WARNING] Failed to update registry value %~2 in %~1.
) else (
   echo [INFO] Updated registry value %~2 in %~1.
)
goto :EOF
