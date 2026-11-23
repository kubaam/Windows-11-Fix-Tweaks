## Summary of Changes
Provide a brief summary of the proposed tweak, bug fix, or refactor.

## Tweak Classification
- [ ] Bug fix / System repair
- [ ] Performance optimization
- [ ] Privacy & Telemetry hardening
- [ ] Debloat & UI enhancement
- [ ] Documentation update

## Verification Checklist
- [ ] Tested on a non-production system or clean VM.
- [ ] Verified on Windows 10 (Build 19041+) or Windows 11 (Build 22000+).
- [ ] Checked that `SafeRegAdd` creates a valid backup in `%TEMP%\W_Tweaks_Backups`.
- [ ] Confirmed that all commands append to `%TEMP%\W_Tweaks_*.log` without errors.
- [ ] Verified reversibility of added settings.
