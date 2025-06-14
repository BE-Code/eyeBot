#!/bin/bash
# Minimal Raspberry Pi Kiosk Setup Script
# Based on https://blog.r0b.io/post/minimal-rpi-kiosk/

set -e

# Update and install required packages
sudo apt-get update
sudo apt-get install -y --no-install-recommends xorg xinit openbox chromium-browser

# Create .xinitrc to launch Chromium in kiosk mode
cat > ~/.xinitrc <<EOF
#!/bin/sh
xset -dpms      # Disable DPMS (Energy Star) features.
xset s off       # Disable screen saver
xset s noblank   # Don't blank the video device
openbox-session &
chromium-browser --noerrdialogs --kiosk --incognito --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI "http://example.com"
EOF
chmod +x ~/.xinitrc

# Enable auto-login and auto-start of kiosk on boot
PROFILE_FILE="$HOME/.bash_profile"
if [ ! -f "$PROFILE_FILE" ]; then
  PROFILE_FILE="$HOME/.profile"
fi
if ! grep -q 'startx' "$PROFILE_FILE"; then
  echo "[[ -z \$DISPLAY && \$XDG_VTNR -eq 1 ]] && startx" >> "$PROFILE_FILE"
fi

echo "Setup complete! The Raspberry Pi will now reboot to apply changes."
sleep 3
sudo reboot
