# eyeBot
My pi based robot with eyes

## Project Overview

This project provides a Node.js application designed to display a robot animation, primarily intended for a Raspberry Pi connected to a display. It includes scripts for easy setup on both a Raspberry Pi (for kiosk deployment) and a general development environment (Linux/macOS).

The application serves a local HTML page and launches a web browser (Chromium) in kiosk mode to display it.

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/BE-Code/eyeBot.git
cd eyeBot
```

### 2. Make Management Scripts Executable

After cloning, make all management scripts executable:
```bash
chmod +x management/*
```

### 3. Development Environment Setup (e.g., on your PC/Mac)

This script will guide you to ensure system dependencies like Node.js and npm are met and install required Node.js packages from `package.json`.

Run the development setup script:
```bash
./management/first_time_setup_dev.sh
```
Follow the on-screen instructions.

### 4. Raspberry Pi Kiosk Setup (for target deployment)

This script automates the setup process on a Raspberry Pi for kiosk mode. It includes:
*   Installing dependencies: Node.js, npm, Chromium browser, unclutter (to hide the mouse cursor), and openbox (minimal window manager, useful for kiosk).
*   Installing Node.js project dependencies (`npm ci`).
*   Configuring an autostart `.desktop` file to run the `management/on_boot.sh` script when the user logs into the graphical desktop environment.

Ensure you are logged in as the user who will be auto-logging into the desktop (e.g., `pi` user or another dedicated user) and has `sudo` privileges for the installation parts.

Run the Pi setup script:
```bash
./management/first_time_setup_pi.sh
```
This will set up the application to start automatically upon graphical login for that user.
**Note:** For a true kiosk, you will likely want to configure the Raspberry Pi for automatic login to the desktop environment for the designated user.

## Running the Application

### Development Environment

1.  Navigate to the project directory:
    ```bash
    cd /path/to/eyeBot
    ```
2.  Start the Node.js server:
    ```bash
    npm start
    ```
    Or run the start script (which also does `npm start`):
    ```bash
    ./management/start.sh
    ```
    This will start the local web server (typically on `http://localhost:3000`). You can then open this URL in your browser.
    The `start.sh` script is primarily designed for the Pi's kiosk mode and will attempt to launch Chromium; this might not be desired during local development if you prefer a different browser.

### Raspberry Pi (Kiosk Mode)

*   **Automatic Start**: The application is configured to start automatically when the designated user logs into the Raspberry Pi's desktop environment. The `on_boot.sh` script is triggered, which first runs `update.sh` and then `start.sh`.
*   `start.sh` will:
    1.  Start the Node.js server (if not already running).
    2.  Launch Chromium browser in fullscreen kiosk mode, pointing to the local Node.js server.
    3.  Run `unclutter` to hide the mouse cursor after a period of inactivity.
*   **Manual Control / Troubleshooting**:
    *   The primary way to manage the application is by logging out and logging back in, or rebooting the Pi.
    *   To manually test the startup process, you can execute:
        ```bash
        ./management/on_boot.sh
        ```
    *   To check the Node.js application logs (if it's running via `npm start` and outputting to console):
        This depends on how `npm start` is configured or if you run `node index.js` directly. The `start.sh` script now logs its own output and the Node.js app output to `kiosk.log` in the project root.
        ```bash
        tail -f kiosk.log
        ```
    *   To stop the Node.js application:
        ```bash
        pkill -f "node .*index.js"
        # or find PID with pgrep and use kill <PID>
        ```
    *   To close Chromium (this might be difficult in true kiosk mode, Alt+F4 might work, or switch to a TTY (Ctrl+Alt+F1) and kill the process):
        ```bash
        pkill chromium-browser
        ```
    *   Logs for the `update.sh` script are in `update.log` in the project root.

## Updating the Application (on Raspberry Pi)

The `on_boot.sh` script, which is run automatically on desktop login, first executes `management/update.sh`. The `update.sh` script pulls the latest changes from Git and installs/updates Node.js dependencies using `npm ci` (or `npm install`).

To apply updates:

1.  Ensure your changes are pushed to the Git repository.
2.  Log out and log back into the Raspberry Pi's desktop, or simply reboot the Pi.
The update process will run automatically.

To manually trigger an update (e.g., via SSH):
1.  SSH into your Raspberry Pi.
2.  Navigate to the project directory: `cd /path/to/eyeBot`
3.  Run the update script:
    ```bash
    ./management/update.sh
    ```
4.  If you want to restart the application components immediately after a manual update:
    ```bash
    # Stop existing processes (if any)
    pkill -f "node .*index.js"
    pkill chromium-browser
    # Then run the start script
    ./management/start.sh
    ```

## Management Scripts Overview

Located in the `management/` directory:

*   `first_time_setup_dev.sh`: Sets up a development environment (PC/Mac) for Node.js.
*   `first_time_setup_pi.sh`: Sets up the application on a Raspberry Pi for desktop kiosk mode, including dependencies and autostart.
*   `start.sh`: Starts the Node.js server and launches Chromium in kiosk mode. Includes basic logging to `kiosk.log`.
*   `update.sh`: Pulls latest Git changes and updates Node.js dependencies. Includes basic logging to `update.log`.
*   `on_boot.sh`: Called by the autostart mechanism on the Pi. Runs `update.sh` then `start.sh`.

## Kiosk Customization

The content displayed is served from `public/index.html` by the `index.js` Node server. You can modify `public/index.html` and any associated CSS/JavaScript files to change the kiosk display.

The Node.js server (`index.js`) is very basic. For more complex applications, consider using a framework like Express.js.

Chromium kiosk flags in `start.sh` can be adjusted for different behaviors.
