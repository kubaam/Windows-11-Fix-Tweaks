# Security Policy

## Supported Versions

The following table reflects the operating system environments currently supported and tested with the optimizer and hardening framework:

| OS Version | Build Range | Supported |
| --- | --- | --- |
| Windows 11 (24H2, 23H2, 22H2) | 22621+ | :white_check_mark: |
| Windows 10 (22H2, 21H2) | 19041 – 19045 | :white_check_mark: |
| Windows 10 (pre-2004) / Windows 7 / 8.1 | < 19041 | :x: Not supported |
| Windows Server (2022, 2025) | Core / Desktop | :warning: Limited (interactive mode only) |

## Security Architecture & Guarantees

This project follows a strict **Safe-by-Default** and **Audit-First** philosophy:

1. **Zero External Binaries:** All operations are executed using native operating system binaries (`dism.exe`, `sfc.exe`, `reg.exe`, `bcdedit.exe`, `powershell.exe`). No third-party compiled executables, external DLLs, or obfuscated payloads are ever downloaded or executed.
2. **Pre-Flight Snapshotting:** The framework prompts and initiates a Windows System Restore Point and full hive registry backup prior to applying system changes.
3. **Atomic Key Backups (`SafeRegAdd`):** Before any registry key is written, its existing configuration is exported to `%TEMP%\W_Tweaks_Backups`.
4. **Deterministic Audit Logging:** Every executed command, exit code, and modified value is written with UTC/local timestamps to an isolated log file in `%TEMP%`.
5. **Reversibility:** Boot timer tweaks (BCDEdit) and core system modifications provide built-in restoration commands directly accessible via the management menu.

## Reporting a Security Vulnerability

If you discover a security vulnerability, unintended privilege escalation, or a modification that impairs core system security without consent:

1. **Do not create a public GitHub issue.**
2. Send a detailed vulnerability report via email to **jakubambrus@gmail.com** (or open a Private Vulnerability Advisory on GitHub under the **Security** tab).
3. Include:
   - Target Windows version and build number (`winver`)
   - Description of the vulnerable command or registry setting
   - Reproduction steps and proof-of-concept
   - Relevant excerpts from `%TEMP%\W_Tweaks_*.log`

We acknowledge reports within 48 hours and aim to release remediation within 7 business days.
