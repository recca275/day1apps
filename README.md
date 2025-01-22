# day1apps by recca275

**For gamers too lazy to download their apps manually.**

This script automates the process of downloading and installing common applications for gamers. It detects your operating system and downloads the appropriate version of the selected applications.

## Supported Platforms
- Windows
- Linux

## Requirments

### Windows
- PowerShell 5.0 or later (pre-installed on most modern Windows versions)

### Linux
- A terminal with `bash` or `zsh`
- `dpkg` (for `.deb` package installations)
- `wget` or `curl` for downloading files
- `tar` for extracting `.tar.xz` files (Lutris)

---

## How to Use

### Windows
1. Save the script to downloads folder as `day1apps.ps1`.
2. Open POwerShell as an Administrator
3. Navigate to the folder containing the script:
   ```powershell
   cd users\USERNAMEHERE\downloads 
   ```
4. Run the script:
   ```powershell
   .\day1apps.ps1
   ```
5. Follow the on-screen prompts to select and install applications.

### Linux
1. Save the script as `day1apps.sh`.
2. Open a terminal.
3. Navigate to the folder containing the script:
   ```bash
   cd /path/to/script
   ```
4. Make the script executable:
   ```bash
   chmod +x day1apps.sh
   ```
5. Run the script:
   ```bash
   ./day1apps.sh
   ```
6. Follow the on-screen prompts to select and install applications.

---

## Applications Available for Download
- **Browsers**: Firefox, Google Chrome
- **Gaming Clients**: Steam, Battle.net(Windows only), Epic Games Launcher(Windows only), Lutris (Linux only)
- **Other**: Spotify, Discord

---

## Features
- Detects your operating system automatically (Windows/Linux).
- Downloads and installs applications or sets up `.deb`/`.tar` packages for Linux.
- Creates shortcuts on the desktop for installed applications.
- Skips already installed applications.

---

## Donation
If you enjoy this tool and wish to support further development, consider donating!

- [GitHub](https://www.github.com/recca275)
- [PayPal](https://www.paypal.me/recca275)

Thank you for your support!**
