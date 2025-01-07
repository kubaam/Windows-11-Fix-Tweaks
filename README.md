# Windows 11 Fix & Tweaks – All-in-One Batch Script

> **Ultimate** Windows 11 **optimization**, **fixes**, and **performance** enhancements – all in a single script.

This **all-in-one batch file** aims to streamline essential **Windows 11 fixes**, **speed tweaks**, **privacy enhancements**, and **performance** boosts. It combines **System File Checker (SFC)**, **DISM** repairs, **Windows Update resets**, **Microsoft Store repairs**, plus advanced registry and boot tweaks for maximum **system optimization**. 

---

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Usage](#usage)
- [Important Notes & Disclaimers](#important-notes--disclaimers)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## Introduction
This repository provides a **free** and **open-source** solution to help **Windows 11** users quickly fix common issues, **optimize performance**, and tweak privacy settings. Whether you're experiencing **system crashes**, **sluggish performance**, or want to remove **bloatware** and disable **telemetry**, this script can do it all in just a few steps.

---

## Features
1. **System File Checker (SFC)** – Automatically scans and repairs corrupted system files.  
2. **DISM** – Restores system health with the `/scanhealth`, `/checkhealth`, and `/restorehealth` commands.  
3. **Windows Update Reset** – Stops relevant services, clears `SoftwareDistribution` and `catroot2` folders, and restarts services.  
4. **Microsoft Store Repair** – Re-registers Store applications to fix many **Windows Store** and **UWP** app issues.  
5. **Privacy Tweaks** – Disables **telemetry**, **Cortana**, and location services for enhanced **privacy**.  
6. **Visual Effects Adjustment** – Disables animations and set performance-based visual settings.  
7. **Optional Bloatware Removal** – Remove common **pre-installed apps** to declutter your system.  
8. **BCD Tweaks** – Includes advanced boot tweaks like:
   - `bcdedit /set tscsyncpolicy enhanced`  
   - `bcdedit /deletevalue useplatformtick`  
   - `bcdedit /set bootmenupolicy legacy`  
9. **Advanced Registry Edits** –  
   - **Graphics Drivers Scheduler**: Disable preemption  
   - **LargeSystemCache** enabled  
   - **Multimedia Class Scheduler Service** disabled  
   - **TCP Ack Frequency** optimization  
   - **Diagnostic Tracking** services disabled  
   - **Win32PrioritySeparation** set for **gaming performance**  

---

## Usage
1. **Download** or **clone** this repository.
2. Locate the file `Win11_AllInOneTweaks.bat`.
3. **Right-click** on the `.bat` file and select **“Run as administrator.”**
4. Follow on-screen instructions. Some operations (like **SFC** or **DISM**) may take a while.
5. **Restart** your computer once the script completes to ensure all changes take effect.

> **Tip:** Always **review** the `.bat` file contents. You can **comment out** any lines you don’t want to use.

---

## Important Notes & Disclaimers
- **Backup Your System**: It’s highly recommended to create a **System Restore Point** or a **full system backup** before running the script.
- **Use at Your Own Risk**: This script applies **advanced tweaks** to your system’s registry and **BCD**. It may result in **unexpected behavior** if not used carefully.
- **Administrator Privileges**: Must be run with elevated privileges. Otherwise, most tweaks won’t apply, and you may see errors.
- **Check Compatibility**: Some of these tweaks are specifically for **Windows 11** but may also work on Windows 10.  
- **Network Adapters**: Certain **TCP/IP** tweaks (e.g., `TcpAckFrequency`) may need manual edits per adapter in the registry.  
- **No Warranty**: The author(s) of this repository provide no warranty. **You assume all responsibility** for system changes.

---

## Screenshots
> Coming Soon!

We plan to include screenshots of the script running in **Command Prompt** or **PowerShell** and examples of **successful** fixes.

---

## Contributing
We welcome **pull requests** to update, improve, or refine the script. Please ensure:
1. Your code is **commented** and **tested**.
2. You **adhere** to best practices to avoid system instability.
3. Provide a clear description in your **Pull Request**.

### Issue Reporting
If you find a bug or want to request a feature:
1. **Open an Issue** in this repo.  
2. Provide a **detailed description** of the bug or request.  
3. Include steps to **reproduce** or expected vs. actual behavior.

---

**Enjoy your optimized Windows 11!**  

For any questions or feedback, open an issue or reach out on GitHub. We look forward to hearing your **success stories** or **improvements**. 

> **Remember**: If this script helped you, please **star** the repository and **share** with others looking for a comprehensive **Windows 11 fix and tweaks** solution!
---

## **Support and Contributions** 🤝  

Feel free to contribute or report bugs via GitHub. Pull requests are welcome!  
If you appreciate this tool, you can support its development by donating here:  
[**PayPal - Jakub Ambrus**](https://paypal.me/JakubAmbrus)  

---

## **License** 📜  

This project is licensed under the **MIT License**. See `LICENSE` for details.  

---

### Key SEO Highlights
- **Windows 11 Fix**  
- **Advanced Tweaks**  
- **Performance Optimization**  
- **Privacy and Telemetry**  
- **Batch Script**  
- **DISM / SFC**  
- **Bloatware Removal**  

These keywords help **maximize traffic** and ensure that anyone looking for a **Windows 11 optimization** tool can find this repository easily.

---
