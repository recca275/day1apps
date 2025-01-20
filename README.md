# README: Cross-Platform Application Installer Script

## Overview
This script is Bash-based designed to download and install applications on both Windows and Linux platforms. It automatically detects your operating system asks you to select a browser and downloads and installs the applications

---

## Features
- **Automatic OS Detection**: Supports Windows and Linux.
- **Custom Browser Selection**: Choose between Firefox and Google Chrome.
- **Predefined Apps**: Includes Spotify, Steam, and Discord in addition to the selected browser.
- **Automated Installation**: Handles both `.exe` (Windows) and `.deb` (Linux) files.
- **Cross-Platform Compatibility**: Runs in Bash, compatible with Linux natively and with Git Bash or WSL on Windows.

---

## Requirements
### Linux
- Bash shell (pre-installed on most distributions).
- `curl` or `wget` for downloading files.
- `dpkg` for installing `.deb` packages.
- `sudo` privileges for installations.

### Windows
- Git Bash or Windows Subsystem for Linux (WSL).
- `curl` or `wget` for downloading files.

---

## How to Use the Script

1. **Download the Script**
   Save the script file to your local machine as `install_apps.sh`.

2. **Make the Script Executable**
   Open a terminal in the directory containing the script and run:
   ```bash
   chmod +x install_apps.sh
   ```

3. **Run the Script**
   Execute the script with:
   ```bash
   ./install_apps.sh
   ```

4. **Follow the Prompts**
   - The script will detect your operating system.
   - You will be prompted to choose a browser (either Firefox or Chrome).
   - The script will download and install the selected browser along with Spotify, Steam, and Discord.

---

## What the Script Does
1. **OS Detection**: Identifies if you're running on Windows or Linux.
2. **Browser Choice**: Prompts for a choice between Firefox and Chrome.
3. **Download Directory**: Creates a `downloads` directory in the script's location to store the downloaded files.
4. **File Download**: Fetches the appropriate installers for your operating system.
5. **Installation**:
   - **Windows**: Runs `.exe` files directly.
   - **Linux**: Installs `.deb` files using `dpkg` and resolves dependencies.

---

## Notes
- The script relies on either `curl` or `wget` for downloading files. Ensure at least one is installed.
- For Linux installations, administrative (`sudo`) privileges are required to install `.deb` packages.
- On Windows, you may need to run Git Bash or WSL with administrative permissions if file execution fails.

---

## Troubleshooting
- **Download Issues**: Ensure your internet connection is active and `curl` or `wget` is installed.
- **Permission Denied**: Check file permissions and run the script as an administrator or with `sudo`.
- **Unsupported OS**: If the script doesn't detect your OS, ensure you're running it in Bash on a supported platform.

---


