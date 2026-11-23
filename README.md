# Windows 10/11 Ultimate Optimizer & Hardener

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg?logo=windows)](https://github.com/kubaam/Windows-11-Fix-Tweaks)
[![CI](https://github.com/kubaam/Windows-11-Fix-Tweaks/actions/workflows/ci.yml/badge.svg)](https://github.com/kubaam/Windows-11-Fix-Tweaks/actions/workflows/ci.yml)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/kubaam/Windows-11-Fix-Tweaks/badge)](https://securityscorecards.dev/viewer/?repo=github.com/kubaam/Windows-11-Fix-Tweaks)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Security Policy](https://img.shields.io/badge/Security-Policy-informational.svg)](SECURITY.md)

> Safe-by-default, audited, and reversible maintenance and privacy-hardening framework for Windows 10 & 11 environments.

A transparent, single-file administrative utility that unifies **system integrity repairs** (SFC / DISM), **Windows Update servicing resets**, **Microsoft Store repairs**, **telemetry & privacy hardening**, **performance optimizations**, and **safe debloating** behind an interactive menu and automated execution flags.

Every action is logged in real-time, every modified registry key is backed up before mutation, and boot-critical tweaks feature one-click rollbacks.

---

## Table of Contents

- [Ecosystem Reach & Impact](#ecosystem-reach--impact)
- [Architecture & Safety Guarantees](#architecture--safety-guarantees)
- [Highlights](#highlights)
- [Requirements](#requirements)
- [Quick Start](#quick-start)
- [Menu Overview](#menu-overview)
- [Safety Mechanisms](#safety-mechanisms)
- [Security & Compliance](#security--compliance)
- [Contributing](#contributing)
- [License](#license)

---

## Ecosystem Reach & Impact

Unlike opaque compiled executables that bundle unwanted dependencies or apply undocumented destructive hacks, `Windows-11-Fix-Tweaks` is 100% plain text, inspectable, and reproducible:

- **Active User Base:** Over **1,200 unique monthly visitors** and **2,000+ page views/month** directly tracked via GitHub traffic telemetry, with steady organic clone adoption across technician and lab environments.
- **Transparent Auditing:** Every command utilizes native Windows binaries (`dism.exe`, `sfc.exe`, `reg.exe`, `bcdedit.exe`, `powershell.exe`). Zero external third-party binaries or network payloads.
- **Critical Gap Filled:** Provides system administrators, technicians, and everyday users with an enterprise-conscious, safe debloating and telemetry-disabling script that guarantees zero unrecoverable states.

---

## Architecture & Safety Guarantees

```
[ Elevated Launch (Run as Admin) ]
              │
              ▼
[ OS Build & Architecture Detection (19041+ / 22000+) ]
              │
              ▼
[ Pre-Flight Snapshots: System Restore Point & Full Hive Backup ]
              │
              ▼
┌─────────────────────────────────────────────────────────────┐
│                 Execution Engine (SafeRegAdd)               │
│  1. Check existing registry key value                       │
│  2. Export target key snapshot to %TEMP%\W_Tweaks_Backups   │
│  3. Apply vetted configuration                              │
│  4. Log exit codes and timestamps to %TEMP%\W_Tweaks_*.log  │
└─────────────────────────────────────────────────────────────┘
              │
              ▼
[ Non-Destructive Reversals & Verification (DISM / SFC / BCD) ]
```

---

## Highlights

- **Interactive or Automated** — Choose menu option `1` ("Apply ALL") for automated deployment, or inspect individual tweaks with current-value previews and manual confirmations.
- **Isolated Timestamped Logs** — Every operation, command string, and error code is logged to `%TEMP%\W_Tweaks_<random>.log`.
- **Atomic Registry Rollback Staging** — Modified keys are automatically exported to `%TEMP%\W_Tweaks_Backups` prior to writing new values.
- **One-Click Restore Point** — Prompts for a Windows System Restore Point and full registry hive backup (`Documents\RegistryBackup_<timestamp>`) on start.
- **OS-Gated Tweaks** — Build detection prevents Windows 11-only tweaks (e.g. `WaitForIdleState`) from running on Windows 10 kernels.
- **Reversible Boot Configuration** — Built-in restore routine to undo BCDEdit changes immediately.

---

## Requirements

- **Operating System:** Windows 10 (version 21H2+ / build 19041+) or Windows 11 (22H2 / 23H2 / 24H2).
- **Privileges:** Administrator elevation (verified on launch).
- **Shell:** Windows Command Prompt with PowerShell 5.1+ (installed by default on Windows).

---

## Quick Start

### Standard Run
1. Download or clone this repository.
2. Right-click `Win11_AllInOneTweaks.bat` and select **Run as administrator**.
3. Accept the prompts to create a System Restore Point.
4. Select `1` to apply recommended defaults, or pick individual modules.
5. Reboot when prompted to finalize kernel and service configurations.

### PowerShell Automation One-Liner (Admin)
```powershell
irm https://raw.githubusercontent.com/kubaam/Windows-11-Fix-Tweaks/main/Win11_AllInOneTweaks.bat -OutFile "$env:TEMP\Win11_Tweaks.bat"; Start-Process cmd -ArgumentList "/c `"$env:TEMP\Win11_Tweaks.bat`"" -Verb RunAs
```

---

## Menu Overview

| # | Module | Operations Executed |
|---|---|---|
| **1** | **Apply ALL Recommended** | Runs sections 5, 6, 7, 9, 10, 11, 12 in sequence non-interactively. |
| **2** | **System Integrity: DISM + SFC** | Executes `dism /restorehealth` followed by `sfc /scannow` system image repair. |
| **3** | **Reset Windows Update** | Stops update services, clears corrupted `SoftwareDistribution` and `catroot2`, and restarts services. |
| **4** | **Repair Microsoft Store** | Clears Store cache and re-registers standard UWP application packages. |
| **5** | **Performance Tweaks** | Optimizes process startup delays, service kill timeouts, and scheduler responsiveness. |
| **6** | **Visual Effects & UI** | Applies best-performance UI profile while preserving font smoothing and UI clarity. |
| **7** | **Privacy & Hardening** | Disables diagnostic telemetry (`DiagTrack`), Cortana, Bing search in Start, and advertising ID. |
| **8** | **Curated Debloat** | Safely removes preinstalled third-party trialware and redundant provisioned packages. |
| **9** | **Explorer & Shell Settings** | Opens File Explorer to "This PC", disables consumer feature suggestions. |
| **10** | **Advanced System & Network** | Network throttling adjustments, MMCSS optimization, and optional timer tuning. |
| **11** | **Network Stack Reset** | Flushes DNS cache, resets Winsock catalog, and reinitializes TCP/IP stack. |
| **12** | **Power & Footprint Tweaks** | Configures Ultimate Performance plan, disables hibernation file if requested. |
| **13** | **Optional Utilities** | Toggles GodMode folder, hides redundant navigation pane entries, error reporting controls. |
| **14** | **Maintenance Tools** | Cleanup temp caches, event logs, and complete network refresh. |
| **15** | **Revert BCDEdit Timers** | Restores default boot configuration data values. |
| **16** | **Create Restore Point** | Triggers an immediate VSS system checkpoint. |
| **17** | **Full Registry Backup** | Exports HKCR, HKCU, HKLM, HKU, HKCC to an on-disk backup folder. |
| **18** | **Reboot System** | Orderly 5-second countdown system restart. |
| **19** | **Exit** | Flushes audit log and closes cleanly. |

---

## Safety Mechanisms

1. **Elevation Barrier:** Fails immediately with instructions if launched without administrator rights.
2. **SafeRegAdd Engine:** Automatically exports every registry branch before applying edits:
   ```cmd
   call :SafeRegAdd "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" "AllowTelemetry" "REG_DWORD" "0"
   ```
3. **Auditable Plain Text:** No encrypted routines or binary payloads; all logic is human-readable.
4. **Isolated Logging:** Log path is shown in the banner and recorded upon script exit.

---

## Security & Compliance

- **Vulnerability Reporting:** See [SECURITY.md](SECURITY.md) for supported versions and private disclosure instructions.
- **Code of Conduct:** See [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
- **Contributing Standards:** See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## License

This project is licensed under the [MIT License](LICENSE).
