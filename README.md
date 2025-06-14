# Minimal Raspberry Pi Kiosk Setup

This project provides a script to set up a minimal web kiosk on a Raspberry Pi, following the guide at [r0b.io](https://blog.r0b.io/post/minimal-rpi-kiosk/).

## Features
- Boots directly to Chromium in kiosk mode
- Minimal X11/Openbox environment
- Fast startup, no desktop environment

## Usage
```sh
git clone <repo-url>
cd eyeBot
./setup-kiosk.sh
```
The Pi will automatically reboot when setup is complete.

## Customization
- Edit `~/.xinitrc` to change the kiosk URL or Chromium flags.
