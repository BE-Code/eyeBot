#!/bin/bash

set -e

# -- Config --
SCRIPT_NAME="main.py"
SERVICE_NAME="robot-animation"
VENV_DIR="venv"
# Determine the script execution user for the service
# If this script is run with sudo, $USER might be root.
# We want the user who owns the script/repo, typically the one calling sudo.
SERVICE_USER="${SUDO_USER:-$(whoami)}"

echo "=== Robot Setup Starting (Service will run as user: $SERVICE_USER) ==="
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$REPO_DIR"

# -- Install system dependencies --
sudo apt update
sudo apt install -y python3-pip python3-venv git fbset libsdl2-dev python3-sdl2 libsdl2-ttf-dev libsdl2-image-dev

# -- Create and activate virtual environment --
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# -- Install Python dependencies --
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "Error: requirements.txt not found"
    exit 1
fi

# -- Enable framebuffer support --
if ! grep -q "dtoverlay=vc4-fkms-v3d" /boot/config.txt; then
    echo "Adding framebuffer support to /boot/config.txt"
    sudo bash -c "echo 'dtoverlay=vc4-fkms-v3d' >> /boot/config.txt"
    echo "Note: A reboot will be required for framebuffer changes to take effect"
fi

# -- Create systemd service --
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "Creating systemd service file: $SERVICE_FILE"
sudo bash -c "cat > $SERVICE_FILE" <<EOF
[Unit]
Description=Robot Animation
After=multi-user.target

[Service]
ExecStart=$REPO_DIR/management/on_boot.sh
WorkingDirectory=$REPO_DIR
StandardOutput=inherit
StandardError=inherit
Restart=always
User=$SERVICE_USER

[Install]
WantedBy=multi-user.target
EOF

# -- Enable and start the service --
echo "Reloading systemd daemon, enabling and starting service..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

# Return to original directory
cd "$ORIGINAL_DIR"

echo "=== Setup Complete! ==="
echo "Robot should now be running on HDMI display."
echo "To update: Restart or SSH in and run 'sudo systemctl restart $SERVICE_NAME'"
