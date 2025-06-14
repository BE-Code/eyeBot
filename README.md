# Minimal Raspberry Pi Kiosk Setup

This project provides a script to set up a minimal web kiosk on a Raspberry Pi, following the guide at [r0b.io](https://blog.r0b.io/post/minimal-rpi-kiosk/).

## Features
- Boots directly to Chromium in kiosk mode
- Minimal X11/Openbox environment
- Fast startup, no desktop environment

## Usage
```sh
git clone https://github.com/BE-Code/eyeBot.git
cd eyeBot
./setup-kiosk.sh
```
After running the script, the Raspberry Pi will launch `raspi-config` automatically. Use it to enable autologin:

- In the `raspi-config` menu, navigate to:
  - **System Options**
  - **Boot / Auto Login**
  - **Desktop Autologin** (or **Console Autologin** if you prefer to start X manually)
- Finish and exit `raspi-config`. The Pi will reboot.

Once autologin is enabled, the kiosk will start automatically after each boot.

## Customization
- Edit `~/.xinitrc` to change the kiosk URL or Chromium flags.
