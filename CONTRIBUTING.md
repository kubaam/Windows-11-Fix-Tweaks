# Contribution Guidelines

Thank you for contributing to the Windows 10/11 Optimizer & Hardener project. We welcome bug reports, script improvements, and documentation enhancements.

## General Principles

1. **Safety First**: Any added tweak must be non-destructive, audited, and compatible with `SafeRegAdd` so it can be backed up automatically before modification.
2. **Native Tooling**: Only use built-in Windows utilities (`reg.exe`, `dism.exe`, `sfc.exe`, `powershell.exe`, `net.exe`). No third-party binaries or compiled code.
3. **OS-Aware Logic**: Ensure all Windows 11-specific keys are gated by OS build checks (`%WIN_BUILD% GEQ 22000`).

## Development & Testing Workflow

1. **Fork & Branch**: Create a feature branch from `main`.
2. **Virtual Machine Testing**: Test all modifications inside a clean Windows 10 (21H2+) or Windows 11 (22H2–24H2) virtual machine before submitting.
3. **Verify Logging**: Ensure changes write expected output to `%TEMP%\W_Tweaks_*.log`.
4. **Pull Request**: Open a pull request describing the rationale, affected registry paths, and test verification results.
