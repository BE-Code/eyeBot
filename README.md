# eyeBot
My pi based robot with eyes

## Project Overview

This project is a Pygame application designed to display a robot animation, primarily intended for a Raspberry Pi outputting to an HDMI display via framebuffer. It includes scripts for easy setup on both a Raspberry Pi and a general development environment.

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

This script will guide you to ensure system dependencies are met, create a Python virtual environment, and install required Python packages.

Run the development setup script:
```bash
./management/first_time_setup_dev.sh
```
Follow the on-screen instructions.

### 4. Raspberry Pi Setup (for target deployment)

This script automates the setup process on a Raspberry Pi, including installing dependencies, setting up a Python virtual environment, installing Python packages, and configuring a systemd service to run the application on boot.

Ensure you are logged in as the `pi` user or a user with `sudo` privileges.

Run the Pi setup script:
```bash
./management/first_time_setup_pi.sh
```
This will set up the application to start automatically on boot.

## Running the Application

### Development Environment

1.  Navigate to the project directory:
    ```bash
    cd /path/to/eyeBot
    ```
2.  Run the start script:
    ```bash
    ./management/start.sh
    ```
    This script will activate the virtual environment and run `main.py`.
    If you need to manually manage the virtual environment (e.g., to install additional packages):
    ```bash
    source venv/bin/activate      # To activate
    pip install <package_name>
    deactivate                    # To deactivate when done
    ```

### Raspberry Pi

*   **Automatic Start**: The application is configured to start automatically when the Raspberry Pi boots up, thanks to the systemd service created by `first_time_setup_pi.sh`.
*   **Manual Control / Updates**:
    *   To restart the application (e.g., after pulling updates):
        ```bash
        sudo systemctl restart robot-animation
        ```
    *   To stop the application:
        ```bash
        sudo systemctl stop robot-animation
        ```
    *   To check the status of the application:
        ```bash
        sudo systemctl status robot-animation
        ```
    *   To view logs:
        ```bash
        journalctl -u robot-animation -f
        ```

## Updating the Application (on Raspberry Pi)

The `on_boot.sh` script, which is run by the systemd service, automatically runs `management/update.sh` before starting the application. The `update.sh` script pulls the latest changes from Git and installs any new Python dependencies from `requirements.txt`.

To apply updates:

1.  SSH into your Raspberry Pi.
2.  Restart the service. This will trigger the update and then start the application:
    ```bash
    sudo systemctl restart robot-animation
    ```

## Management Scripts Overview

Located in the `management/` directory:

*   `first_time_setup_dev.sh`: Sets up a development environment (PC/Mac).
*   `first_time_setup_pi.sh`: Sets up the application on a Raspberry Pi, including a systemd service.
*   `start.sh`: Activates the virtual environment and runs the `main.py` script. Used for development and by `on_boot.sh`.
*   `update.sh`: Pulls latest Git changes and updates Python dependencies from `requirements.txt`.
*   `on_boot.sh`: Called by the systemd service on the Pi. Runs `update.sh` then `start.sh`.
