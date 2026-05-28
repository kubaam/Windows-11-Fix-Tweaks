# Windows 10/11 Ultimate Optimizer & Hardener

> Interactive, logged, safe-by-default batch script for Windows 10/11 maintenance, performance tuning, and privacy hardening.

A single-file utility that bundles **system integrity repairs** (SFC / DISM), **Windows Update component resets**, **Microsoft Store repairs**, **privacy hardening**, **performance tweaks**, **debloat**, and **network fixes** behind a menu-driven interface. Every action is logged, every registry change is backed up before it is applied, and dangerous changes can be reverted from the menu.

---

## Table of Contents

- [Highlights](#highlights)
- [Requirements](#requirements)
- [Usage](#usage)
- [Menu Overview](#menu-overview)
- [Safety Mechanisms](#safety-mechanisms)
- [Important Notes & Disclaimers](#important-notes--disclaimers)
- [Contributing](#contributing)
- [License](#license)

---

## Highlights

- **Interactive or Automatic** — pick "Apply ALL" for a hands-off run, or step through each tweak with current-value previews and Y/N confirmations.
- **Logged operations** — every command and registry change is appended to a timestamped log file in `%TEMP%`.
- **Registry backups** — each affected key is exported to `%TEMP%\W_Tweaks_Backups` before modification, plus optional full-hive backup to `Documents\RegistryBackup_<timestamp>`.
- **System Restore Point** — optional one-click checkpoint before any changes.
- **Revertible boot tweaks** — built-in menu option to undo BCDEdit timer changes.
- **OS-aware** — detects build number and applies Windows 11–only keys (e.g. `WaitForIdleState`) only when appropriate.

---

## Requirements

- Windows 10 or Windows 11 (build 19041+ recommended).
- Administrator privileges (the script verifies this on launch).
- PowerShell 5.1+ (ships with Windows).

---

## Usage

1. Download or clone this repository.
2. Right-click `Win11_AllInOneTweaks.bat` and choose **Run as administrator**.
3. (Recommended) Accept the prompts to create a **System Restore Point** and a **full Registry backup**.
4. Pick an option from the menu, or `1` to apply the curated default set without further prompts.
5. Reboot when prompted to let all changes take effect.

The log file path is printed under the banner and again at exit — keep a copy of it if you want to review what was changed.

---

## Menu Overview

| # | Option | Notes |
|---|---|---|
| 1 | Apply ALL Recommended Tweaks | Runs sections 5, 6, 7, 9, 10, 11, 12 non-interactively. |
| 2 | System Integrity: DISM + SFC | `dism /scanhealth`, `/checkhealth`, `/restorehealth`, then `sfc /scannow`. |
| 3 | Reset Windows Update Components | Stops services, renames `SoftwareDistribution` and `catroot2`, restarts services. |
| 4 | Repair Microsoft Store | Re-registers Store and built-in UWP apps. |
| 5 | Performance Tweaks | Startup delays, hang/kill timeouts, foreground priority, menu show delay, network throttling. |
| 6 | Visual Effects / UI | Best-performance visual settings, optional refined `UserPreferencesMask`. |
| 7 | Privacy & Security Hardening | Telemetry, Cortana, Bing, location, suggestions, DiagTrack service. |
| 8 | Remove Preinstalled Apps | Optional debloat for a curated list. Some apps may return after feature updates. |
| 9 | Common Registry Tweaks | Disable Consumer Features, open Explorer to "This PC". |
| 10 | Advanced System Tweaks | BCDEdit timers, GPU scheduler, `LargeSystemCache`, MMCSS, per-NIC `TcpAckFrequency`, `Win32PrioritySeparation`. |
| 11 | Network Fixes | Reset TCP/IP, flush DNS, reset Winsock, release/renew IP. |
| 12 | Additional Advanced Tweaks | Disable Hibernation, Ultimate Performance plan, optional IPv6 disable, OneDrive uninstall, Notification Center off, optional TEMP/Prefetch/event log cleanup. |
| 13 | Optional Extras | Remove "3D Objects", hide Network / OneDrive in nav pane, disable Error Reporting & system beep, AutoPlay off, GodMode folder, disable accessibility shortcut popups. |
| 14 | System & Network Maintenance Tools | Quick submenu for cleanup and a full network stack reset. |
| 15 | Revert BCDEdit Timer Tweaks | Restores default boot timer values. |
| 16 | Create System Restore Point | On-demand restore point. |
| 17 | Create Full Registry Backup | Exports HKCR/HKCU/HKLM/HKU/HKCC to `Documents\RegistryBackup_<timestamp>`. |
| 18 | Reboot System | 5-second countdown, then reboot. |
| 19 | Exit | Prints the log path and exits. |

---

## Safety Mechanisms

- **Admin gate** — refuses to run without elevation.
- **Per-key backups** — `SafeRegAdd` exports the target key before writing the new value.
- **Current-value preview** — interactive mode shows the existing value before asking to update it.
- **Dry-friendly logging** — every command and its outcome is appended to the log file with timestamps.
- **Force-auto flag** — "Apply ALL" sets a single internal flag that downstream prompts honor automatically, so prompts are never silently bypassed when you're running the script section-by-section.

---

## Important Notes & Disclaimers

- **Back up first.** Even with built-in safeguards, registry and BCD edits can leave a system in a state you do not want.
- **Use at your own risk.** This tool is provided "as-is" with no warranty. You assume full responsibility for any system changes.
- **Compatibility.** Tested on Windows 10 21H2+ and Windows 11. Some keys are no-ops on older builds; that is logged but not treated as a failure.
- **Network reset wipes state.** Option 11 (and the maintenance submenu's full reset) clears static IPs, custom DNS, and saved Wi-Fi profiles.
- **Debloat is permanent for the session.** Removed apps can be reinstalled from the Microsoft Store, and some return automatically after feature updates.
- **Some "performance" tweaks are controversial.** `disabledynamictick`, `useplatformclock`, `EnablePreemption=0`, and `MMCSS Start=4` can hurt as often as they help — apply them in interactive mode if you want fine-grained control.

---

## Contributing

Issues and pull requests are welcome.

1. Fork the repository.
2. Create a branch for your change.
3. Test on a non-production system or a virtual machine.
4. Open a PR describing what changed and why.

If you are reporting a bug, please include the relevant lines from the log file and the Windows build number (`winver`).

---

## License

MIT — see [LICENSE](LICENSE).

---

## Support

If this tool helps you, a star is appreciated. Donations are optional and entirely up to you: [PayPal — Jakub Ambrus](https://paypal.me/JakubAmbrus).
