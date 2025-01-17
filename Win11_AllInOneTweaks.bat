@echo off
title Windows 11 Ultimate Fix & Tweaks (Massive Interactive Version)
echo ============================================================
echo   Windows 11 Ultimate Fix & Tweaks (Interactive + Expanded)
echo   USE AT YOUR OWN RISK - PROCEED WITH CAUTION
echo ============================================================
echo.

::--------------------------------------------------------------------------
:: SAFETY CHECK: Must be run as administrator
::--------------------------------------------------------------------------
:CheckAdmin
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] This script must be run as Administrator.
    pause
    exit /b
)

::--------------------------------------------------------------------------
:: STEP 0: CREATE A RESTORE POINT?
::--------------------------------------------------------------------------
set "RSTRPNT_CHOICE=N"
echo Do you want to create a Restore Point (if enabled)? (Y/N)
set /p RSTRPNT_CHOICE=
if /i "%RSTRPNT_CHOICE%"=="Y" (
    echo Creating a restore point...
    powershell -command "Checkpoint-Computer -Description 'Win11_UltimateTweaks' -RestorePointType 'MODIFY_SETTINGS'"
)

::--------------------------------------------------------------------------
:: STEP 1: SFC /SCANNOW
::--------------------------------------------------------------------------
set "SFC_CHOICE=N"
echo.
echo Step 1: System File Checker (SFC)
echo ---------------------------------
echo Run 'sfc /scannow'? (Y/N)
set /p SFC_CHOICE=
if /i "%SFC_CHOICE%"=="Y" (
    echo Running SFC...
    sfc /scannow
)

::--------------------------------------------------------------------------
:: STEP 2: DISM Checks
::--------------------------------------------------------------------------
set "DISM_CHOICE=N"
echo.
echo Step 2: DISM Checks
echo ---------------------------------
echo Perform DISM scanhealth/checkhealth/restorehealth? (Y/N)
set /p DISM_CHOICE=
if /i "%DISM_CHOICE%"=="Y" (
    echo Scanning for health...
    dism /online /cleanup-image /scanhealth
    echo Checking for issues...
    dism /online /cleanup-image /checkhealth
    echo Restoring health...
    dism /online /cleanup-image /restorehealth
)

::--------------------------------------------------------------------------
:: STEP 3: Reset Windows Update Components
::--------------------------------------------------------------------------
set "WU_CHOICE=N"
echo.
echo Step 3: Reset Windows Update Components
echo ---------------------------------
echo Reset Windows Update components (deletes cache)? (Y/N)
set /p WU_CHOICE=
if /i "%WU_CHOICE%"=="Y" (
    net stop wuauserv
    net stop cryptSvc
    net stop bits
    net stop msiserver

    echo Deleting Windows Update cache...
    rd /s /q %systemroot%\SoftwareDistribution
    rd /s /q %systemroot%\system32\catroot2

    net start wuauserv
    net start cryptSvc
    net start bits
    net start msiserver
)

::--------------------------------------------------------------------------
:: STEP 4: Repair Microsoft Store and Re-register Apps
::--------------------------------------------------------------------------
set "STORE_CHOICE=N"
echo.
echo Step 4: Repair Microsoft Store and Re-register Apps
echo ---------------------------------
echo Repair Store and re-register all apps? (Y/N)
set /p STORE_CHOICE=
if /i "%STORE_CHOICE%"=="Y" (
    powershell -command "Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"
    powershell -command "Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"
)

::--------------------------------------------------------------------------
:: STEP 5: Basic Privacy Tweaks
::--------------------------------------------------------------------------
set "PRIVACY_CHOICE=N"
echo.
echo Step 5: Basic Privacy Tweaks
echo ---------------------------------
echo - Disable Telemetry
echo - Disable Cortana
echo - Disable system-wide location
echo Enable these privacy tweaks? (Y/N)
set /p PRIVACY_CHOICE=
if /i "%PRIVACY_CHOICE%"=="Y" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
    reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f
)

::--------------------------------------------------------------------------
:: STEP 6: Adjust Visual Effects for Performance
::--------------------------------------------------------------------------
set "VISUAL_CHOICE=N"
echo.
echo Step 6: Adjust Visual Effects for Performance
echo ---------------------------------
echo Reduce animations and visual effects? (Y/N)
set /p VISUAL_CHOICE=
if /i "%VISUAL_CHOICE%"=="Y" (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
    reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120000 /f
)

::--------------------------------------------------------------------------
:: STEP 7: Remove Some Preinstalled Apps (Optional)
::--------------------------------------------------------------------------
set "REMOVE_APPS_CHOICE=N"
echo.
echo Step 7: Remove Some Preinstalled Apps
echo ---------------------------------
echo (Uncomment lines in the script if you want to remove specific apps.)
echo Proceed with removal commands as currently scripted? (Y/N)
set /p REMOVE_APPS_CHOICE=
if /i "%REMOVE_APPS_CHOICE%"=="Y" (
    :: Example lines -- uncomment as needed:
    :: powershell -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
    :: powershell -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    :: powershell -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
    :: powershell -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
    :: powershell -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
    echo [INFO] Removal commands (if uncommented) executed.
)

::--------------------------------------------------------------------------
:: STEP 8: Other Common Registry Tweaks
::--------------------------------------------------------------------------
set "COMMONREG_CHOICE=N"
echo.
echo Step 8: Other Common Registry Tweaks
echo ---------------------------------
echo - Disable Lock Screen Ads/Spotlight
echo - Set File Explorer default view to "This PC"
echo Enable these tweaks? (Y/N)
set /p COMMONREG_CHOICE=
if /i "%COMMONREG_CHOICE%"=="Y" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f
)

::--------------------------------------------------------------------------
:: STEP 9: Advanced System & Registry Tweaks
::--------------------------------------------------------------------------
set "ADV_CHOICE=N"
echo.
echo Step 9: Advanced System & Registry Tweaks
echo ---------------------------------
echo - TSC Synchronization Policy (enhanced)
echo - Synthetic Timers (disable UsePlatformTick)
echo - Legacy Boot Menu
echo - Disable Graphics Driver Preemption
echo - Enable Large System Cache
echo - Disable Multimedia Class Scheduler (MMCSS)
echo - TCP Ack Frequency optimization
echo - Disable Diagnostic Tracking & dmwappush
echo - Win32PrioritySeparation for gaming
echo Enable these advanced tweaks? (Y/N)
set /p ADV_CHOICE=
if /i "%ADV_CHOICE%"=="Y" (
    echo [INFO] Checking DISM to ensure Admin privileges...
    dism >nul 2>&1 || (
        echo [ERROR] Script must be run as Administrator.
        pause
        exit /b 1
    )
    bcdedit /set tscsyncpolicy enhanced >nul 2>&1
    bcdedit /deletevalue useplatformtick >nul 2>&1
    bcdedit /set bootmenupolicy legacy >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MMCSS" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
    sc config DiagTrack start= disabled >nul 2>&1
    sc config dmwappushservice start= disabled >nul 2>&1
    reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
    echo [INFO] Advanced tweaks applied.
)

::--------------------------------------------------------------------------
:: STEP 10: Network Issues Fixes
::--------------------------------------------------------------------------
set "NETFIX_CHOICE=N"
echo.
echo Step 10: Network Issues Fixes
echo ---------------------------------
echo - Reset TCP/IP stack
echo - Flush DNS
echo - Reset Winsock
echo - Release/Renew IP
echo Apply network fixes? (Y/N)
set /p NETFIX_CHOICE=
if /i "%NETFIX_CHOICE%"=="Y" (
    netsh int ip reset
    ipconfig /flushdns
    netsh winsock reset
    ipconfig /release
    ipconfig /renew
    echo [INFO] Network fixes applied.
)

::--------------------------------------------------------------------------
:: STEP 11: Additional Advanced Tweaks
::--------------------------------------------------------------------------
echo.
echo Step 11: Additional Advanced Tweaks
echo ---------------------------------
echo This section provides even more granular toggles. 

::-- 11.1 Disable Hibernation
set "HIBER_CHOICE=N"
echo Disable hibernation (frees disk space, no Fast Startup)? (Y/N)
set /p HIBER_CHOICE=
if /i "%HIBER_CHOICE%"=="Y" (
    powercfg /h off
    echo [INFO] Hibernation disabled.
)

::-- 11.2 Enable Ultimate Performance Power Plan
set "ULT_CHOICE=N"
echo Enable Ultimate Performance Power Plan? (Y/N)
echo (Typically for Pro/Enterprise editions)
set /p ULT_CHOICE=
if /i "%ULT_CHOICE%"=="Y" (
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61
    echo [INFO] Ultimate Performance Plan enabled.
)

::-- 11.3 Disable IPv6 (Ethernet & Wi-Fi)
set "IPV6_CHOICE=N"
echo Disable IPv6 on Ethernet & Wi-Fi adapters? (Y/N)
echo (May break IPv6-only services)
set /p IPV6_CHOICE=
if /i "%IPV6_CHOICE%"=="Y" (
    netsh interface ipv6 set interface "Ethernet" admin=disabled
    netsh interface ipv6 set interface "Wi-Fi" admin=disabled
    echo [INFO] IPv6 disabled on Ethernet and Wi-Fi.
)

::-- 11.4 Disable Windows Search Indexing
set "SEARCH_CHOICE=N"
echo Disable Windows Search Indexing service? (Y/N)
echo (Speeds up some systems, but slower file searches)
set /p SEARCH_CHOICE=
if /i "%SEARCH_CHOICE%"=="Y" (
    sc config WSearch start= disabled
    net stop WSearch
    echo [INFO] Windows Search indexing disabled.
)

::-- 11.5 Uninstall OneDrive
set "ONEDRIVE_CHOICE=N"
echo Uninstall OneDrive? (Y/N)
set /p ONEDRIVE_CHOICE=
if /i "%ONEDRIVE_CHOICE%"=="Y" (
    taskkill /f /im OneDrive.exe >nul 2>&1
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
    echo [INFO] OneDrive uninstalled.
)

::-- 11.6 Disable Action Center / Notifications
set "NOTIF_CHOICE=N"
echo Disable Action Center / Notification Center? (Y/N)
echo (Might break Windows notifications)
set /p NOTIF_CHOICE=
if /i "%NOTIF_CHOICE%"=="Y" (
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
    echo [INFO] Notification Center disabled.
)

::-- 11.7 Clear Temp and Prefetch
set "CLEAN_TEMP_CHOICE=N"
echo Clear Temp and Prefetch folders? (Y/N)
echo (Frees space, but some caching benefits are lost)
set /p CLEAN_TEMP_CHOICE=
if /i "%CLEAN_TEMP_CHOICE%"=="Y" (
    rd /s /q %temp%
    rd /s /q %systemroot%\Temp
    rd /s /q %systemroot%\Prefetch
    echo [INFO] Temp and Prefetch cleaned.
)

::-- 11.8 Clear ALL Event Logs
set "EVENTLOG_CHOICE=N"
echo Clear ALL Event Logs? (Y/N)
echo (Removes all system/application/security logs)
set /p EVENTLOG_CHOICE=
if /i "%EVENTLOG_CHOICE%"=="Y" (
    for /F "tokens=*" %%G in ('wevtutil el') DO (
       wevtutil cl "%%G"
    )
    echo [INFO] All event logs cleared.
)

::--------------------------------------------------------------------------
:: STEP 12: Even More Optional Tweaks
::--------------------------------------------------------------------------
echo.
echo Step 12: Even More Optional Tweaks
echo ---------------------------------
echo More granular or cosmetic changes below.

::-- 12.1 Remove '3D Objects' from This PC
set "REMOVE_3DOBJ_CHOICE=N"
echo Remove '3D Objects' folder from This PC? (Y/N)
set /p REMOVE_3DOBJ_CHOICE=
if /i "%REMOVE_3DOBJ_CHOICE%"=="Y" (
    reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" /f 2>nul
    echo [INFO] '3D Objects' removed from This PC.
)

::-- 12.2 Remove 'Network' from Navigation Pane
set "REMOVE_NETWORK_CHOICE=N"
echo Remove 'Network' icon from File Explorer navigation pane? (Y/N)
set /p REMOVE_NETWORK_CHOICE=
if /i "%REMOVE_NETWORK_CHOICE%"=="Y" (
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum" /v "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /t REG_DWORD /d 1 /f
    echo [INFO] 'Network' removed from navigation pane.
)

::-- 12.3 Remove OneDrive from Navigation Pane (Hide, not uninstall)
set "REMOVE_ONEDRIVE_NAV=N"
echo Hide OneDrive from File Explorer navigation pane? (Y/N)
set /p REMOVE_ONEDRIVE_NAV=
if /i "%REMOVE_ONEDRIVE_NAV%"=="Y" (
    :: Requires changing attributes to hide from nav
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v Attributes /t REG_DWORD /d 0x00000000 /f
    reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d 0 /f
    echo [INFO] OneDrive hidden from navigation pane.
)

::-- 12.4 Disable Error Reporting
set "ERRORREP_CHOICE=N"
echo Disable Windows Error Reporting? (Y/N)
echo (Prevents error-report pop-ups and data sending)
set /p ERRORREP_CHOICE=
if /i "%ERRORREP_CHOICE%"=="Y" (
    reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
    echo [INFO] Windows Error Reporting disabled.
)

::-- 12.5 Disable Beep on Errors
set "BEEPS_CHOICE=N"
echo Disable beep on Windows errors? (Y/N)
echo (Stops the "default beep" system sound)
set /p BEEPS_CHOICE=
if /i "%BEEPS_CHOICE%"=="Y" (
    reg add "HKCU\Control Panel\Sound" /v Beep /t REG_SZ /d no /f
    echo [INFO] System beep disabled.
)

::-- 12.6 Disable AutoPlay for all drives
set "AUTOPLAY_CHOICE=N"
echo Disable AutoPlay for all drives? (Y/N)
set /p AUTOPLAY_CHOICE=
if /i "%AUTOPLAY_CHOICE%"=="Y" (
    :: 255 decimal = 0xFF (disables autoplay on all drives)
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f
    echo [INFO] AutoPlay disabled for all drives.
)

::-- 12.7 Create 'God Mode' folder on Desktop
set "GODMODE_CHOICE=N"
echo Create 'God Mode' folder on Desktop? (Y/N)
echo (Centralized Control Panel features)
set /p GODMODE_CHOICE=
if /i "%GODMODE_CHOICE%"=="Y" (
    md "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" 2>nul
    echo [INFO] 'God Mode' folder created on Desktop.
)

::-- 12.8 Disable Sticky Keys / Filter Keys / Toggle Keys
set "STICKY_CHOICE=N"
echo Disable Sticky/Filter/Toggle Keys popups? (Y/N)
set /p STICKY_CHOICE=
if /i "%STICKY_CHOICE%"=="Y" (
    :: StickyKeys
    reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 506 /f
    :: FilterKeys
    reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v Flags /t REG_SZ /d 122 /f
    :: ToggleKeys
    reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v Flags /t REG_SZ /d 58 /f
    echo [INFO] Sticky/Filter/Toggle Keys disabled.
)

::--------------------------------------------------------------------------
:: COMPLETE
::--------------------------------------------------------------------------
echo.
echo ============================================================
echo   All Done! Some changes may require a system restart.
echo ============================================================
echo Please restart your computer for all changes to take effect.
pause
exit /b 0
