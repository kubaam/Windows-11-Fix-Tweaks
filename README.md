# Windows 11 Fix and Tweaks – All-in-One Batch Script

> **Ultimate** Windows 11 **optimization**, **fixes**, and **performance** enhancements – all in a single script.

This **all-in-one batch file** aims to streamline essential **Windows 11 fixes**, **speed tweaks**, **privacy enhancements**, and **performance** boosts. It combines **System File Checker (SFC)**, **DISM** repairs, **Windows Update resets**, **Microsoft Store repairs**, plus advanced registry and boot tweaks for maximum **system optimization**.

---

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Important Notes--Disclaimers](#important-notes--disclaimers)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction
This repository provides a **free** and **open-source** solution to help **Windows 11** users quickly fix common issues, **optimize performance**, and tweak privacy settings. Whether you're experiencing **system crashes**, **sluggish performance**, or want to remove **bloatware** and disable **telemetry**, this script can do it all in just a few simple steps.

---

## Features
1. **System File Checker (SFC)** – Automatically scans and repairs corrupted system files.
2. **DISM** – Restores system health with the `/scanhealth`, `/checkhealth`, and `/restorehealth` commands.
3. **Windows Update Reset** – Stops relevant services, clears the `SoftwareDistribution` and `catroot2` folders, and restarts services.
4. **Microsoft Store Repair** – Re-registers Store applications to fix many **Windows Store** and **UWP** app issues.
5. **Privacy Tweaks** – Disables **telemetry**, **Cortana**, and location services for enhanced **privacy**.
6. **Visual Effects Adjustment** – Disables unnecessary animations and sets performance-based visual settings.
7. **Optional Bloatware Removal** – Removes common **pre-installed apps** to declutter your system.
8. **BCD Tweaks** – Includes advanced boot tweaks like:
   - `bcdedit /set tscsyncpolicy enhanced`
   - `bcdedit /deletevalue useplatformtick`
   - `bcdedit /set bootmenupolicy legacy`
9. **Advanced Registry Edits** – Optimizes several settings including:
   - **Graphics Driver Scheduler**: Disables preemption.
   - **Large System Cache**: Enabled for improved performance.
   - **Multimedia Class Scheduler Service**: Disabled.
   - **TCP Ack Frequency**: Optimized for smoother networking.
   - **Diagnostic Tracking**: Services disabled.
   - **Win32PrioritySeparation**: Set for **gaming performance**.

---

## Usage
1. **Download** or **clone** this repository.
2. Locate the file `WinTweaksInteractive.cmd`.
3. **Right-click** on the `.cmd` file and select **"Run as administrator."**
4. Follow the on-screen instructions. Some operations (like **SFC** or **DISM**) may take a while to complete.
5. **Restart** your computer once the script completes to ensure all changes take effect.

> **Tip:** Always **review** the script contents before running. You can **comment out** any lines you do not wish to execute.

---

## Important Notes -- Disclaimers
- **Backup Your System:** It is highly recommended to create a **System Restore Point** or a **full system backup** before running the script.
- **Use at Your Own Risk:** This script applies **advanced tweaks** to your system's registry and boot configuration. Incorrect modifications may cause **unexpected behavior**.
- **Administrator Privileges:** The script must be run with elevated privileges. Otherwise, most tweaks will not apply and errors may occur.
- **Check Compatibility:** While the tweaks are optimized for **Windows 11**, many are also compatible with Windows 10.
- **Network Adapters:** Some TCP/IP tweaks (such as `TcpAckFrequency`) might require manual adjustments per network adapter.
- **No Warranty:** This project is provided "as-is" with no warranty. **You assume full responsibility** for any system changes.

---

## Screenshots
> **Coming Soon!**

Screenshots of the script in action (in Command Prompt or PowerShell) and examples of successful fixes will be added soon.

---

## Contributing
Contributions are welcome! If you have suggestions for improvements or find a bug, please follow these steps:
1. **Fork** the repository.
2. Create a new **branch** for your feature or bug fix.
3. Ensure your code is well-**commented** and **tested**.
4. Open a **Pull Request** with a clear description of your changes.

### Issue Reporting
If you encounter issues or have feature requests:
1. **Open an Issue** in this repository.
2. Provide a detailed description along with steps to **reproduce** the problem or outline your suggestion.

---

## License
This project is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for details.

---

**Enjoy your optimized Windows 11!**

If this script helped you, please **star** the repository and **share** it with others looking for a comprehensive **Windows 11 fix and tweaks** solution.

---

## Support and Contributions 🤝

Feel free to contribute or report bugs via GitHub. Pull requests are welcome!  
If you appreciate this tool, you can support its development by donating here:  
[**PayPal - Jakub Ambrus**](https://paypal.me/JakubAmbrus)
---

## **License** 📜  

This project is licensed under the **MIT License**. See LICENSE for details.  

---


<!--
- Windows 11 Fix
- Advanced Tweaks
- Performance Optimization
- Privacy and Telemetry
- Batch Script
- DISM / SFC
- Bloatware Removal
- Windows 11 Performance Tweaks
- Windows 11 Registry Hacks
- Windows 11 Optimization Scripts
- Windows 11 Privacy Settings
- Windows 11 Telemetry Disable
- Windows 11 System Cleanup
- Windows 11 Speed Up
- Windows 11 Debloat Tools
- Windows 11 Customization
- Windows 11 Security Enhancements
- Windows 11 Resource Management
- Windows 11 Startup Optimization
- Windows 11 Service Tweaks
- Windows 11 Background Process Management
- Windows 11 Visual Effects Optimization
- Windows 11 Network Performance
- Windows 11 Gaming Performance Tweaks
- Windows 11 Power User Tips
- Windows 11 Command Line Tools
- Windows 11 PowerShell Scripts
- Windows 11 System Maintenance
- Windows 11 Disk Cleanup
- Windows 11 SSD Optimization
- Windows 11 RAM Optimization
- Windows 11 CPU Performance
- Windows 11 GPU Performance
- Windows 11 Boot Time Reduction
- Windows 11 Application Optimization
- Windows 11 System Restore Points
- Windows 11 Backup and Recovery
- Windows 11 System Monitoring
- Windows 11 Update Management
- Windows 11 Driver Management
- Windows 11 Security Policies
- Windows 11 Firewall Configuration
- Windows 11 Antivirus Settings
- Windows 11 User Account Control
- Windows 11 Group Policy Management
- Windows 11 Event Viewer Analysis
- Windows 11 Task Scheduler Management
- Windows 11 System Configuration
- Windows 11 Resource Monitor Usage
- Windows 11 Performance Monitor
- Windows 11 Reliability Monitor
- Windows 11 System Diagnostics
- Windows 11 Troubleshooting Tools
- Windows 11 Safe Mode Boot
- Windows 11 Clean Boot
- Windows 11 System File Checker
- Windows 11 Deployment Imaging Service Management
- Windows 11 Component Store Cleanup
- Windows 11 Windows Update Troubleshooting
- Windows 11 Software Distribution Folder Reset
- Windows 11 Catroot2 Folder Reset
- Windows 11 Microsoft Store Repair
- Windows 11 Appx Package Management
- Windows 11 Cortana Disable
- Windows 11 Location Services Disable
- Windows 11 Visual Effects Settings
- Windows 11 Animations Disable
- Windows 11 Performance-Based Visual Settings
- Windows 11 Boot Configuration Data Tweaks
- Windows 11 BCD Edit Commands
- Windows 11 Registry Edits
- Windows 11 Graphics Driver Scheduler
- Windows 11 Large System Cache
- Windows 11 Multimedia Class Scheduler Service
- Windows 11 TCP Ack Frequency Optimization
- Windows 11 Diagnostic Tracking Service Disable
- Windows 11 Win32 Priority Separation
- Windows 11 Gaming Performance Optimization
- Windows 11 System Health Check
- Windows 11 System Integrity Verification
- Windows 11 System Repair Tools
- Windows 11 System Optimization Guide
- Windows 11 Performance Enhancement
- Windows 11 System Tweaking
- Windows 11 Advanced Configuration
- Windows 11 System Enhancement Scripts
- Windows 11 Optimization Batch Files
- Windows 11 System Utility Scripts
- Windows 11 Performance Improvement
- Windows 11 System Speed Enhancement
- Windows 11 System Efficiency Optimization
- Windows 11 Resource Optimization
- Windows 11 System Responsiveness
- Windows 11 System Stability Improvement
- Windows 11 System Latency Reduction
- Windows 11 System Throughput Enhancement
- Windows 11 System Resource Allocation
- Windows 11 System Performance Metrics
- Windows 11 System Benchmarking
- Windows 11 System Performance Analysis
- Windows 11 System Resource Utilization
- Windows 11 System Performance Monitoring
- Windows 11 System Performance Tuning
- Windows 11 System Performance Management
- Windows 11 System Performance Diagnostics
- Windows 11 System Performance Solutions
- Windows 11 System Performance Strategies
- Windows 11 System Performance Techniques
- Windows 11 System Performance Methods
- Windows 11 System Performance Practices
- Windows 11 System Performance Procedures
- Windows 11 System Performance Approaches
- Windows 11 System Performance Enhancements
- Windows 11 System Performance Improvements
- Windows 11 System Performance Upgrades
- Windows 11 System Performance Boosts
- Windows 11 System Performance Gains
- Windows 11 System Performance Increases
- Windows 11 System Performance Elevation
- Windows 11 System Performance Acceleration
- Windows 11 System Performance Augmentation
- Windows 11 System Performance Amplification
- Windows 11 System Performance Intensification
- Windows 11 System Performance Expansion
- Windows 11 System Performance Advancement
- Windows 11 System Performance Progression
- Windows 11 System Performance Development
- Windows 11 System Performance Refinement
- Windows 11 System Performance Enhancement Techniques
- Windows 11 System Performance Optimization Strategies
- Windows 11 System Performance Improvement Methods
- Windows 11 System Performance Tuning Procedures
- Windows 11 System Performance Boosting Approaches
- Windows 11 System Performance Upgrading Practices
- Windows 11 System Performance Elevation Methods
- Windows 11 System Performance Acceleration Techniques
- Windows 11 System Performance Augmentation Strategies
- Windows 11 System Performance Amplification Methods
- Windows 11 System Performance Intensification Procedures
- Windows 11 System Performance Expansion Approaches
- Windows 11 System Performance Advancement Practices
- Windows 11 System Performance Progression Techniques
- Windows 11 System Performance Development Strategies
- Windows 11 System Performance Refinement Methods
- Windows 11 System Performance Enhancement Approaches
- Windows 11 System Performance Optimization Practices
- Windows 11 System Performance Improvement Procedures
- Windows 11 System Performance Tuning Approaches
- Windows 11 System Performance Boosting Practices
- Windows 11 System Performance Upgrading Methods
- Windows 11 System Performance Elevation Strategies
- Windows 11 System Performance Acceleration Approaches
- Windows 11 System Performance Augmentation Practices
- Windows 11 System Performance Amplification Techniques
- Windows 11 System Performance Intensification Strategies
- Windows 11 System Performance Expansion Methods
- Windows 11 System Performance Advancement Approaches
- Windows 11 System Performance Progression Practices
- Windows 11 System Performance Development Methods
- Windows 11 System Performance Refinement Strategies
- Windows 11 System Performance Enhancement Methods
- Windows 11 System Performance Optimization Approaches
- Windows 11 System Performance Improvement Practices
- Windows 11 System Performance Tuning Strategies
- Windows 11 System Performance Boosting Methods
- Windows 11 System Performance Upgrading Approaches
- Windows 11 System Performance Elevation Practices
- Windows 11 System Performance Acceleration Strategies
- Windows 11 System Performance Augmentation Methods
- Windows 11 System Performance Amplification Approaches
- Windows 11 System Performance Intensification Practices
- Windows 11 System Performance Expansion Strategies
- Windows 11 System
::contentReference[oaicite:0]{index=0}
 


---
