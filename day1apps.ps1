#day1apps by recca275/hydrose for gamers to lazy to download their apps manually

$Green = "`e[0;32m"
$NC = "`e[0m" # No Color

function Donate {
    Write-Output "${Green}****************************************${NC}"
    Write-Output "${Green}*                                      *${NC}"
    Write-Output "${Green}*   Enjoy & thank you for considering  *${NC}"
    Write-Output "${Green}*   a donation! You can find and       *${NC}"
    Write-Output "${Green}*         support me at:               *${NC}"
    Write-Output "${Green}*   https://www.github.com/recca275    *${NC}"
    Write-Output "${Green}*   https://www.paypal.me/recca275     *${NC}"
    Write-Output "${Green}*                                      *${NC}"
    Write-Output "${Green}****************************************${NC}"
}

# URLs for downloading the applications
$urls = @{
    "firefox_windows" = "https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
    "firefox_linux"   = "https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
    "chrome_windows"  = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"
    "chrome_linux"    = "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    "spotify_windows" = "https://download.scdn.co/SpotifySetup.exe"
    "spotify_linux"   = "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_latest_amd64.deb"
    "steam_windows"   = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
    "steam_linux"     = "https://cdn.akamai.steamstatic.com/client/installer/steam.deb"
    "discord_windows" = "https://discord.com/api/download?platform=win"
    "discord_linux"   = "https://discord.com/api/download?platform=linux&format=deb"
    "battlenet_windows" = "https://www.battle.net/download/getInstaller?os=win"
    "epicgames_windows" = "https://launcher-public-service-prod06.ol.epicgames.com/launcher/api/installer/download/EpicGamesLauncherInstaller.msi"
    "lutris_linux" = "https://github.com/lutris/lutris/releases/download/latest/lutris_latest.tar.xz"
}

# Detect operating system
$OS_TYPE = if ($IsWindows) { "windows" } elseif ($IsLinux) { "linux" } else { "unsupported" }
if ($OS_TYPE -eq "unsupported") {
    Write-Output "Unsupported operating system. Exiting."
    exit 1
}

# Ensure required commands are available
function CheckCommand {
    param (
        [string]$command
    )
    if (-not (Get-Command $command -ErrorAction SilentlyContinue)) {
        Write-Output "Required command '$command' is not available. Exiting."
        exit 1
    }
}

if ($OS_TYPE -eq "linux") {
    CheckCommand -command "dpkg"
    CheckCommand -command "tar"
}

# Prompt user for browser choice
do {
    $browser_choice = Read-Host "Choose a browser to download (firefox/chrome/none)"
    $browser_choice = $browser_choice.ToLower()
    if ($browser_choice -notin @("firefox", "chrome", "none")) {
        Write-Output "Invalid choice. Please select either 'firefox', 'chrome', or 'none'."
    }
} until ($browser_choice -in @("firefox", "chrome", "none"))

# Create a downloads directory
$DOWNLOAD_DIR = (Resolve-Path -Path "./downloads").Path
if (-not (Test-Path $DOWNLOAD_DIR)) {
    New-Item -ItemType Directory -Path $DOWNLOAD_DIR | Out-Null
}

# Function to check if a program is installed
function IsProgramInstalled {
    param (
        [string]$programName
    )
    if ($IsWindows) {
        $installed = Get-Command $programName -ErrorAction SilentlyContinue
        return $null -ne $installed
    } elseif ($IsLinux) {
        $installed = dpkg -l | grep $programName
        return $null -ne $installed
    }
    return $false
}

# Function to create a shortcut on the desktop
function CreateShortcut {
    param (
        [string]$shortcutName,
        [string]$targetPath
    )
    $desktopPath = [System.Environment]::GetFolderPath('Desktop')
    if ($IsWindows) {
        $shortcutPath = Join-Path $desktopPath "$shortcutName.lnk"
        $wshShell = New-Object -ComObject WScript.Shell
        $shortcut = $wshShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $targetPath
        $shortcut.Save()
    } elseif ($IsLinux) {
        $shortcutPath = Join-Path $desktopPath "$shortcutName.desktop"
        $shortcutContent = "[Desktop Entry]
Name=$shortcutName
Exec=$targetPath
Type=Application
Terminal=false"
        $shortcutContent | Out-File -FilePath $shortcutPath -Encoding utf8
        chmod +x $shortcutPath
    }
}

# Download the selected browser
if ($browser_choice -ne "none") {
    $key = "${browser_choice}_${OS_TYPE}"
    $url = $urls[$key]

    if (-not $url) {
        Write-Output "No download URL found for $browser_choice on $OS_TYPE."
        exit 1
    }

    $output_file = Join-Path $DOWNLOAD_DIR "${browser_choice}." + if ($OS_TYPE -eq "windows") { "exe" } else { "deb" }

    if (-not (IsProgramInstalled $browser_choice)) {
        Write-Output "Downloading $browser_choice from $url..."
        try {
            Invoke-WebRequest -Uri $url -OutFile $output_file
            Write-Output "Downloaded to $output_file"
        } catch {
            Write-Output "Failed to download $browser_choice. Error: $_"
            exit 1
        }
    } else {
        Write-Output "$browser_choice is already installed. Skipping download."
    }

    # Install or run the file
    if ($OS_TYPE -eq "windows") {
        if (-not (IsProgramInstalled $browser_choice)) {
            Write-Output "Running installer..."
            Start-Process -FilePath $output_file -Wait
            CreateShortcut -shortcutName $browser_choice -targetPath $output_file
        }
    } else {
        if ($output_file -like "*.deb" -and -not (IsProgramInstalled $browser_choice)) {
            Write-Output "Installing package..."
            sudo dpkg -i $output_file
            sudo apt-get -f install -y
            CreateShortcut -shortcutName $browser_choice -targetPath $output_file
        } else {
            Write-Output "$browser_choice is already installed. Skipping installation."
        }
    }
}

# Prompt for additional clients
if ($OS_TYPE -eq "windows") {
    $battlenet_choice = Read-Host "Do you want to download Battle.net client? (y/n)"
    if ($battlenet_choice -eq "y" -and -not (IsProgramInstalled "Battle.net")) {
        $battlenet_url = $urls["battlenet_windows"]
        $battlenet_file = Join-Path $DOWNLOAD_DIR "BattleNet-Setup.exe"
        Write-Output "Downloading Battle.net client from $battlenet_url..."
        Invoke-WebRequest -Uri $battlenet_url -OutFile $battlenet_file
        Write-Output "Downloaded to $battlenet_file"
        Write-Output "Running Battle.net installer..."
        Start-Process -FilePath $battlenet_file -Wait
        CreateShortcut -shortcutName "Battle.net" -targetPath $battlenet_file
    } else {
        Write-Output "Battle.net client is already installed. Skipping download."
    }

    $epicgames_choice = Read-Host "Do you want to download Epic Games client? (y/n)"
    if ($epicgames_choice -eq "y" -and -not (IsProgramInstalled "EpicGamesLauncher")) {
        $epicgames_url = $urls["epicgames_windows"]
        $epicgames_file = Join-Path $DOWNLOAD_DIR "EpicGamesLauncherInstaller.msi"
        Write-Output "Downloading Epic Games client from $epicgames_url..."
        Invoke-WebRequest -Uri $epicgames_url -OutFile $epicgames_file
        Write-Output "Downloaded to $epicgames_file"
        Write-Output "Running Epic Games installer..."
        Start-Process -FilePath $epicgames_file -Wait
        CreateShortcut -shortcutName "Epic Games Launcher" -targetPath $epicgames_file
    } else {
        Write-Output "Epic Games client is already installed. Skipping download."
    }
} else {
    # Prompt for Lutris
    $lutris_choice = Read-Host "Do you want to download Lutris? (y/n)"
    if ($lutris_choice -eq "y" -and -not (IsProgramInstalled "lutris")) {
        $lutris_url = $urls["lutris_linux"]
        $lutris_file = Join-Path $DOWNLOAD_DIR "lutris_latest.tar.xz"
        Write-Output "Downloading Lutris from $lutris_url..."
        Invoke-WebRequest -Uri $lutris_url -OutFile $lutris_file
        Write-Output "Downloaded to $lutris_file"
        Write-Output "Extracting Lutris..."
        tar -xf $lutris_file -C $DOWNLOAD_DIR
        Write-Output "Lutris extracted to $DOWNLOAD_DIR"
        CreateShortcut -shortcutName "Lutris" -targetPath "$DOWNLOAD_DIR/lutris"
    } else {
        Write-Output "Lutris is already installed. Skipping download."
    }
}

# End of program
Write-Output "Process complete."
Donate