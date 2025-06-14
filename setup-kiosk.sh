#!/bin/bash
# Minimal Raspberry Pi Kiosk Setup Script
# Based on https://blog.r0b.io/post/minimal-rpi-kiosk/

set -e

# Update and install required packages
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends xserver-xorg-video-all \
  xserver-xorg-input-all xserver-xorg-core xinit x11-xserver-utils \
  chromium-browser unclutter

# Determine the script's directory and set the kiosk URL to local index.html
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIOSK_URL="file://$SCRIPT_DIR/index.html"

# Create .xinitrc to launch Chromium in kiosk mode
cat > ~/.xinitrc <<EOF
#!/usr/bin/env sh
xset -dpms
xset s off
xset s noblank

unclutter &
chromium-browser $KIOSK_URL \
  --window-size=1920,1080 \
  --window-position=0,0 \
  --start-fullscreen \
  --kiosk \
  --incognito \
  --noerrdialogs \
  --disable-translate \
  --no-first-run \
  --fast \
  --fast-start \
  --disable-infobars \
  --disable-features=TranslateUI \
  --disk-cache-dir=/dev/null \
  --overscroll-history-navigation=0 \
  --disable-pinch
EOF
chmod +x ~/.xinitrc

# Enable auto-login and auto-start of kiosk on boot
cat > "$HOME/.bash_profile" <<'EOL'
if [ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ]
then
  startx
fi
EOL

echo "Setup complete! The Raspberry Pi will now launch raspi-config. After you finish, the system will reboot."
sleep 2
sudo raspi-config
echo "Rebooting now..."
sleep 2
sudo reboot
