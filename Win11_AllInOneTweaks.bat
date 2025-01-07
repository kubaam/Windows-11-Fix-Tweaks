@echo off
title Windows 11 Fix & Tweaks (with Advanced Options & Network Fixes)
echo ==================================================
echo  Windows 11 Fix & Tweaks - USE AT YOUR OWN RISK
echo ==================================================
echo.

::--------------------------------------------------------------------------
:: SAFETY CHECK: Must be run as administrator
::--------------------------------------------------------------------------
:CheckAdmin
echo Checking for elevated privileges...
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo.
    echo ==================================================
    echo  ERROR: This script must be run as Administrator.
    echo ==================================================
    pause
    exit /b
)

::--------------------------------------------------------------------------
:: Create a Restore Point (Only works if System Protection is enabled)
::--------------------------------------------------------------------------
echo Creating a restore point (if enabled)...
powershell -command "Checkpoint-Computer -Description 'Win11_AllInOneTweaks' -RestorePointType 'MODIFY_SETTINGS'"

::--------------------------------------------------------------------------
:: Step 1: System File Checker (SFC)
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 1: System File Checker (SFC)
echo ==================================================
echo Running SFC /scannow...
sfc /scannow

::--------------------------------------------------------------------------
:: Step 2: DISM Checks
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 2: DISM Checks
echo ==================================================
echo Scanning for health (this may take a while)...
dism /online /cleanup-image /scanhealth
echo.
echo Checking for issues...
dism /online /cleanup-image /checkhealth
echo.
echo Restoring health if needed...
dism /online /cleanup-image /restorehealth

::--------------------------------------------------------------------------
:: Step 3: Reset Windows Update Components
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 3: Reset Windows Update Components
echo ==================================================
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver

echo Deleting Windows Update cache and logs...
rd /s /q %systemroot%\SoftwareDistribution
rd /s /q %systemroot%\system32\catroot2

net start wuauserv
net start cryptSvc
net start bits
net start msiserver

::--------------------------------------------------------------------------
:: Step 4: Repair Microsoft Store and Re-register Apps
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 4: Repair Microsoft Store and Apps
echo ==================================================
powershell -command "Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"
powershell -command "Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"

::--------------------------------------------------------------------------
:: Step 5: Some Basic Privacy Tweaks (Telemetry, Cortana, etc.)
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 5: Basic Privacy Tweaks
echo ==================================================
:: Turn off Telemetry via registry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Disable Cortana
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

:: Disable location (system-wide) - may or may not work as expected
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f

::--------------------------------------------------------------------------
:: Step 6: Adjust Visual Effects for Performance (Optional)
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 6: Adjusting Visual Effects (Optional)
echo ==================================================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 90120000 /f

::--------------------------------------------------------------------------
:: Step 7: (Optional) Remove Preinstalled Apps
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 7: Remove Some Preinstalled Apps (Optional)
echo ==================================================
:: Uncomment any lines for apps you really want removed:
:: powershell -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
:: powershell -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
:: powershell -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
:: powershell -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
:: powershell -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"

::--------------------------------------------------------------------------
:: Step 8: Other Common Registry Tweaks
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 8: Other Common Registry Tweaks
echo ==================================================
:: Disable Lock Screen Ads / Spotlight
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f

:: Disable Quick Access and set This PC as default in File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f

::--------------------------------------------------------------------------
:: Step 9: Advanced System & Registry Tweaks
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 9: Advanced System & Registry Tweaks
echo ==================================================

echo.
echo [INFO] Checking for DISM to ensure Admin privileges...
dism >nul 2>&1 || (
    echo [ERROR] This script must be run as Administrator.
    pause
    exit /b 1
)

:: TSC SYNCHRONIZATION POLICY - ENHANCED
bcdedit /set tscsyncpolicy enhanced >nul 2>&1
if %errorlevel%==0 (
    echo [OK] TscSyncPolicy is now set to enhanced.
) else (
    echo [ERROR] Failed to set TscSyncPolicy.
)

:: DISABLE USEPLATFORMTICK (ENABLE SYNTHETIC TIMERS)
bcdedit /deletevalue useplatformtick >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Synthetic Timers are now enabled (UsePlatformTick disabled).
) else (
    echo [ERROR] Failed to disable UsePlatformTick.
)

:: SET BOOT MENU POLICY TO LEGACY
bcdedit /set bootmenupolicy legacy >nul 2>&1
if %errorlevel%==0 (
    echo [OK] BootMenuPolicy set to legacy.
) else (
    echo [ERROR] Failed to set BootMenuPolicy to legacy.
)

:: GRAPHICS DRIVERS SCHEDULER - DISABLE PREEMPTION
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler" /v EnablePreemption /t REG_DWORD /d 0 /f >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Graphics Drivers Scheduler preemption disabled.
) else (
    echo [ERROR] Failed to modify Graphics Drivers Scheduler settings.
)

:: MEMORY MANAGEMENT - ENABLE LARGE SYSTEM CACHE
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Large System Cache enabled.
) else (
    echo [ERROR] Failed to enable Large System Cache.
)

:: MULTIMEDIA CLASS SCHEDULER SERVICE - DISABLE
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\MMCSS" /v Start /t REG_DWORD /d 4 /f >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Multimedia Class Scheduler Service disabled.
) else (
    echo [ERROR] Failed to disable Multimedia Class Scheduler Service.
)

:: NETWORK PERFORMANCE - ENABLE TCP ACK FREQUENCY OPTIMIZATION
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul 2>&1
if %errorlevel%==0 (
    echo [OK] TCP Ack Frequency optimization enabled.
) else (
    echo [ERROR] Failed to optimize TCP Ack Frequency.
)

:: DISABLE DIAGNOSTIC TRACKING SERVICES
sc config DiagTrack start= disabled >nul 2>&1
if %errorlevel%==0 (
    echo [OK] Diagnostic Tracking Service disabled.
) else (
    echo [ERROR] Failed to disable Diagnostic Tracking Service.
)

sc config dmwappushservice start= disabled >nul 2>&1
if %errorlevel%==0 (
    echo [OK] DMWAP Push Service disabled.
) else (
    echo [ERROR] Failed to disable DMWAP Push Service.
)

:: ENABLE SYSTEM RESPONSIVENESS FOR GAMING
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul 2>&1
if %errorlevel%==0 (
    echo [OK] System responsiveness optimized for gaming.
) else (
    echo [ERROR] Failed to optimize system responsiveness.
)

::--------------------------------------------------------------------------
:: Step 10: Network Issues Fixes
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  Step 10: Network Issues Fixes
echo ==================================================
echo Resetting TCP/IP stack...
netsh int ip reset
echo Flushing DNS...
ipconfig /flushdns
echo Resetting Winsock...
netsh winsock reset
echo Releasing and Renewing IP...
ipconfig /release
ipconfig /renew
echo.
echo [INFO] Network related fixes have been applied.

::--------------------------------------------------------------------------
:: Done
::--------------------------------------------------------------------------
echo.
echo ==================================================
echo  All Done! Some changes may require a restart.
echo ==================================================
echo.
echo Please restart your computer for all changes to take effect.
pause
exit /b 0
