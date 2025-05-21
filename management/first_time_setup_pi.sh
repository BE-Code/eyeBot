#!/bin/bash

set -e

# -- Config --
SERVICE_NAME="robot-kiosk"
# Determine the script execution user for the service
# If this script is run with sudo, $USER might be root.
# We want the user who owns the script/repo, typically the one calling sudo.
SERVICE_USER="${SUDO_USER:-$(whoami)}"
APP_NAME="robotKiosk" # For the .desktop file

echo "=== Kiosk Setup Starting (Service will run as user: $SERVICE_USER) === "
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$REPO_DIR"

# -- Install system dependencies --
echo "Updating package lists..."
sudo apt update
echo "Installing git, Node.js, npm, Chromium, unclutter, and openbox..."
# Install prerequisites for NodeSource script if any (e.g., curl, gpg)
sudo apt install -y curl gpg
# Add NodeSource repository for a specific Node.js version (e.g., Node 20)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs git chromium-browser unclutter openbox # fbset and Python/SDL deps removed

# -- Install Node.js project dependencies --
echo "Installing Node.js dependencies..."
if [ -f "package.json" ]; then
    if [ -f "package-lock.json" ]; then
        echo "package-lock.json found, using npm ci for clean install."
        npm ci --production
    else
        echo "package-lock.json not found, using npm install. This will generate a lock file."
        npm install --production
    fi
else
    echo "Error: package.json not found. Please ensure your Node.js project is initialized."
    exit 1
fi

# -- Create autostart .desktop file for the user --
AUTOSTART_DIR="/home/$SERVICE_USER/.config/autostart"
DESKTOP_FILE="$AUTOSTART_DIR/$APP_NAME.desktop"

echo "Creating autostart file: $DESKTOP_FILE"
sudo -u "$SERVICE_USER" mkdir -p "$AUTOSTART_DIR" # Ensure the directory exists, create as the user

# Create the .desktop file as the SERVICE_USER
# Note: on_boot.sh will be responsible for launching the browser in kiosk mode
# and the Node.js application.
sudo -u "$SERVICE_USER" bash -c "cat > '$DESKTOP_FILE'" <<EOF
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$REPO_DIR/management/on_boot.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Starts the kiosk application
EOF

echo "Setting permissions for .desktop file..."
sudo -u "$SERVICE_USER" chmod +x "$DESKTOP_FILE"

# -- Clean up apt cache --
sudo apt autoremove -y
sudo apt clean

# Return to original directory
cd "$ORIGINAL_DIR"

echo "=== Setup Complete! ==="
echo "The kiosk application will attempt to start on the next login for user $SERVICE_USER."
echo "Please ensure $SERVICE_USER is configured for automatic login if required."
echo "To manually test the boot script, you can run: $REPO_DIR/management/on_boot.sh"
# Systemd service parts removed
