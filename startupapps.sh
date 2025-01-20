#!/bin/bash

echo "welcome to Hydrose's program installer"
echo "my paypal is recca275@gmail.com for tips and donations"

# URLs for downloading the applications
declare -A urls
urls["firefox_windows"]="https://download.mozilla.org/?product=firefox-latest&os=win64&lang=en-US"
urls["firefox_linux"]="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=en-US"
urls["chrome_windows"]="https://dl.google.com/chrome/install/latest/chrome_installer.exe"
urls["chrome_linux"]="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
urls["spotify_windows"]="https://download.scdn.co/SpotifySetup.exe"
urls["spotify_linux"]="https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_latest_amd64.deb"
urls["steam_windows"]="https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
urls["steam_linux"]="https://cdn.akamai.steamstatic.com/client/installer/steam.deb"
urls["discord_windows"]="https://discord.com/api/download?platform=win"
urls["discord_linux"]="https://discord.com/api/download?platform=linux&format=deb"

# Detect operating system
OS_TYPE=""
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_TYPE="linux"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    OS_TYPE="windows"
else
    echo "Unsupported operating system: $OSTYPE"
    exit 1
fi

# Prompt user for browser choice
read -p "Choose a browser to download (firefox/chrome): " browser_choice
browser_choice=$(echo "$browser_choice" | tr '[:upper:]' '[:lower:]')

if [[ "$browser_choice" != "firefox" && "$browser_choice" != "chrome" ]]; then
    echo "Invalid choice. Please select either 'firefox' or 'chrome'."
    exit 1
fi

# Create a downloads directory
DOWNLOAD_DIR="./downloads"
mkdir -p "$DOWNLOAD_DIR"

# Download the selected browser
key="${browser_choice}_${OS_TYPE}"
url="${urls[$key]}"

if [[ -z "$url" ]]; then
    echo "No download URL found for $browser_choice on $OS_TYPE."
    exit 1
fi

output_file="$DOWNLOAD_DIR/${browser_choice}.$([[ "$OS_TYPE" == "windows" ]] && echo "exe" || echo "deb")"
echo "Downloading $browser_choice from $url..."
if command -v curl &>/dev/null; then
    curl -L "$url" -o "$output_file"
elif command -v wget &>/dev/null; then
    wget "$url" -O "$
else
    echo "Neither curl nor wget is installed. Cannot download files."
    exit 1
fi

echo "Downloaded to $output_file"

# Install or run the file
if [[ "$OS_TYPE" == "windows" ]]; then
    echo "Running installer..."
    cmd.exe /c "$output_file"
else
    if [[ "$output_file" == *.deb ]]; then
        echo "Installing package..."
        sudo dpkg -i "$output_file"
        sudo apt-get -f install -y
    else
        echo "Unsupported file format for Linux."
    fi
fi

echo "Process complete."
