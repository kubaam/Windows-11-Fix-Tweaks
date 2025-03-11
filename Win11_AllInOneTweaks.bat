@echo off
:: Set a friendly color: Black background (0) with Aqua text (B)
color 0B

title Windows 10/11 Ultimate Fix and Tweaks (Interactive Version)
echo ============================================================
echo         Windows 10/11 Ultimate Fix and Tweaks Interactive
echo                   by ambry/kubaam
echo ============================================================
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
    powershell -NoProfile -command "Checkpoint-Computer -Description 'Win11_UltimateTweaks' -RestorePointType 'MODIFY_SETTINGS'"
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
    call :AskAndRun "Re-registering Microsoft Store" "powershell -NoProfile -command \"Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}\""
    call :AskAndRun "Re-registering apps for all users" "powershell -NoProfile -command \"Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}\""
) else (
    echo [INFO] Re-registering Microsoft Store...
    powershell -NoProfile -command "Get-AppxPackage *WindowsStore* | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"
    echo [INFO] Re-registering apps for all users...
    powershell -NoProfile -command "Get-AppxPackage -AllUsers | Foreach-Object {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppxManifest.xml'}"
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
    call :AskAndRun "Disabling startup delay" "reg add \"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize\" /v StartupDelayInMSec /t REG_DWORD /d 0 /f >nul"
    call :AskAndRun "Speeding up shutdown (WaitToKillServiceTimeout = 2000ms)" "reg add \"HKLM\SYSTEM\CurrentControlSet\Control\" /v WaitToKillServiceTimeout /t REG_SZ /d 2000 /f >nul"
    call :AskAndRun "Prioritizing foreground apps (SystemResponsiveness = 10)" "reg add \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\" /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul"
    call :AskAndRun "Reducing menu show delay (MenuShowDelay = 100)" "reg add \"HKCU\Control Panel\Desktop\" /v MenuShowDelay /t REG_SZ /d 100 /f >nul"
    call :AskAndRun "Disabling network throttling" "reg add \"HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f >nul"
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
    call :AskAndRun "Setting VisualFXSetting to 2 (best performance)" "reg add \"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul"
    call :AskAndRun "Adjusting UserPreferencesMask for optimized UI" "reg add \"HKCU\Control Panel\Desktop\" /v UserPreferencesMask /t REG_BINARY /d 90120000 /f >nul"
) else (
    echo [INFO] Setting VisualFXSetting to 2...
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
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
    call :AskAndRun "Disabling Telemetry" "reg add \"HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection\" /v AllowTelemetry /t REG_DWORD /d 0 /f >nul"
    call :AskAndRun "Disabling Cortana" "reg add \"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search\" /v AllowCortana /t REG_DWORD /d 0 /f >nul"
    call :AskAndRun "Disabling system-wide location service" "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration\" /v Status /t REG_DWORD /d 0 /f >nul"
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
    call :AskAndRun "Removing Xbox app" "powershell -NoProfile -command \"Get-AppxPackage *xboxapp* | Remove-AppxPackage\""
    call :AskAndRun "Removing Bing News" "powershell -NoProfile -command \"Get-AppxPackage *bingnews* | Remove-AppxPackage\""
    call :AskAndRun "Removing Bing Weather" "powershell -NoProfile -command \"Get-AppxPackage *bingweather* | Remove-AppxPackage\""
    call :AskAndRun "Removing Zune Video" "powershell -NoProfile -command \"Get-AppxPackage *zunevideo* | Remove-AppxPackage\""
    call :AskAndRun "Removing Solitaire Collection" "powershell -NoProfile -command \"Get-AppxPackage *solitairecollection* | Remove-AppxPackage\""
) else (
    echo [INFO] Removing preinstalled apps...
    powershell -NoProfile -command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
    powershell -NoProfile -command "Get-AppxPackage *bingnews* | Remove-AppxPackage"
    powershell -NoProfile -command "Get-AppxPackage *bingweather* | Remove-AppxPackage"
    powershell -NoProfile -command "Get-AppxPackage *zunevideo* | Remove-AppxPackage"
    powershell -NoProfile -command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
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
if "%AUTO%"=="0" (
    call :AskAndRun "Disabling Lock Screen Ads and Spotlight" "reg add \"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\" /v DisableConsumerFeatures /t REG_DWORD /d 1 /f >nul && reg add \"HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\" /v DisableSoftLanding /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Setting File Explorer to open 'This PC' by default" "reg add \"HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /v LaunchTo /t REG_DWORD /d 1 /f >nul"
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
    call :AskAndRun "Disabling Graphics Driver Preemption" "reg add \"HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers\Scheduler\" /v EnablePreemption /t REG_DWORD /d 0 /f >nul"
    call :AskAndRun "Enabling Large System Cache" "reg add \"HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\" /v LargeSystemCache /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Disabling Multimedia Class Scheduler (MMCSS)" "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\MMCSS\" /v Start /t REG_DWORD /d 4 /f >nul"
    call :AskAndRun "Optimizing TCP Ack Frequency" "reg add \"HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" /v TcpAckFrequency /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Disabling Diagnostic Tracking and dmwappushservice" "sc config DiagTrack start= disabled >nul 2>&1 && sc config dmwappushservice start= disabled >nul 2>&1"
    call :AskAndRun "Adjusting Win32PrioritySeparation for gaming" "reg add \"HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl\" /v Win32PrioritySeparation /t REG_DWORD /d 26 /f >nul"
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
    call :AskAndRun "Disabling IPv6 on Ethernet and Wi-Fi" "netsh interface ipv6 set interface \"Ethernet\" admin=disabled >nul 2>&1 && netsh interface ipv6 set interface \"Wi-Fi\" admin=disabled >nul 2>&1"
    call :AskAndRun "Disabling Windows Search Indexing" "sc config WSearch start= disabled >nul 2>&1 && net stop WSearch >nul 2>&1"
    call :AskAndRun "Uninstalling OneDrive" "taskkill /f /im OneDrive.exe >nul 2>&1 && %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1"
    call :AskAndRun "Disabling Action Center and Notification Center" "reg add \"HKCU\Software\Policies\Microsoft\Windows\Explorer\" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Clearing Temp and Prefetch folders" "rd /s /q \"%temp%\" >nul 2>&1 && rd /s /q \"%SystemRoot%\Temp\" >nul 2>&1 && rd /s /q \"%SystemRoot%\Prefetch\" >nul 2>&1"
    call :AskAndRun "Clearing ALL Event Logs" "for /F \"tokens=*\" %%G in ('wevtutil el') do (wevtutil cl \"%%G\" >nul 2>&1)"
) else (
    echo [INFO] Disabling Hibernation...
    powercfg /h off
    echo [INFO] Enabling Ultimate Performance Power Plan...
    powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    powercfg /setactive e9a42b02-d5df-448d-aa00-03f14749eb61 >nul 2>&1
    echo [INFO] Disabling IPv6 on Ethernet and Wi-Fi...
    netsh interface ipv6 set interface "Ethernet" admin=disabled >nul 2>&1
    netsh interface ipv6 set interface "Wi-Fi" admin=disabled >nul 2>&1
    echo [INFO] Disabling Windows Search Indexing...
    sc config WSearch start= disabled >nul 2>&1
    net stop WSearch >nul 2>&1
    echo [INFO] Uninstalling OneDrive...
    taskkill /f /im OneDrive.exe >nul 2>&1
    %SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>&1
    echo [INFO] Disabling Action Center and Notification Center...
    reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f >nul
    echo [INFO] Clearing Temp and Prefetch folders...
    rd /s /q "%temp%" >nul 2>&1
    rd /s /q "%SystemRoot%\Temp" >nul 2>&1
    rd /s /q "%SystemRoot%\Prefetch" >nul 2>&1
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
    call :AskAndRun "Removing 'Network' icon from Navigation Pane" "reg add \"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\NonEnum\" /v \"{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\" /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Hiding OneDrive from Navigation Pane" "reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v Attributes /t REG_DWORD /d 0x00000000 /f >nul && reg add \"HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder\" /v \"System.IsPinnedToNameSpaceTree\" /t REG_DWORD /d 0 /f >nul"
    call :AskAndRun "Disabling Windows Error Reporting" "reg add \"HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\" /v Disabled /t REG_DWORD /d 1 /f >nul"
    call :AskAndRun "Disabling system beep on errors" "reg add \"HKCU\Control Panel\Sound\" /v Beep /t REG_SZ /d no /f >nul"
    call :AskAndRun "Disabling AutoPlay for all drives" "reg add \"HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\" /v NoDriveTypeAutoRun /t REG_DWORD /d 255 /f >nul"
    call :AskAndRun "Creating 'God Mode' folder on Desktop" "md \"%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}\" 2>nul"
    call :AskAndRun "Disabling Sticky/Filter/Toggle Keys popups" "reg add \"HKCU\Control Panel\Accessibility\StickyKeys\" /v Flags /t REG_SZ /d 506 /f >nul && reg add \"HKCU\Control Panel\Accessibility\Keyboard Response\" /v Flags /t REG_SZ /d 122 /f >nul && reg add \"HKCU\Control Panel\Accessibility\ToggleKeys\" /v Flags /t REG_SZ /d 58 /f >nul"
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
    md "%USERPROFILE%\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}" 2>nul
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
if %errorlevel%==1 (
    set "AUTO=1"
) else (
    set "AUTO=0"
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
:: Use delayed expansion with /s switch for proper command execution.
setlocal enabledelayedexpansion
set "TWEAK_CMD=%~2"
echo [INFO] Executing: !TWEAK_CMD!
cmd /s /c !TWEAK_CMD!
echo [INFO] Completed: %~1
endlocal
:AskAndRunEnd
goto :EOF
