#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_ROOT/kiosk.log"

# Ensure X server is available
if [ -z "$DISPLAY" ]; then
  export DISPLAY=:0
fi

# Redirect stdout and stderr for the entire script to a log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting Kiosk Mode - $(date)"

# Change to project root
cd "$PROJECT_ROOT"

# Check if Node.js app is already running
if pgrep -f "node .*index.js" > /dev/null; then
    echo "Node.js application already running."
else
    echo "Starting Node.js application..."
    # Start the Node.js application in the background
    # Assuming your start script is defined in package.json as "start": "node index.js"
    # Or directly: node index.js &
    npm start &
    NODE_PID=$!
    echo "Node.js app started with PID $NODE_PID"
    # Wait a few seconds for the server to start
    sleep 5
fi

# Kiosk mode browser command
KIOSK_URL="http://localhost:3005" # Assuming your Node.js app serves on port 3005

# Check if Chromium is already running in kiosk mode for this URL
# This is a basic check; a more robust check might involve checking window titles or specific chromium flags
if pgrep -af "chromium-browser.*kiosk.*$KIOSK_URL" > /dev/null; then
    echo "Chromium kiosk mode already running for $KIOSK_URL."
else
    echo "Starting Chromium in kiosk mode for $KIOSK_URL..."
    # Options for kiosk mode with Chromium:
    # --kiosk: True fullscreen, locks down the browser.
    # --start-fullscreen: Starts fullscreen but might allow exiting.
    # --incognito: Starts in incognito mode.
    # --disable-infobars: Hides "Chrome is being controlled by automated test software" type bars.
    # --noerrdialogs: Suppresses error dialogs.
    # --disable-session-crashed-bubble: Disables the "session crashed" bubble.
    # --check-for-update-interval=31536000: Effectively disables updates (1 year in seconds)
    # unclutter -idle 1 -root: Hides mouse cursor after 1 second of inactivity on the root window

    # Start unclutter to hide the mouse cursor
    unclutter -idle 1 -root &

    # Attempt to start Chromium. If it fails, log and try again or handle error.
    # The while loop is to ensure it retries if it fails to connect to X display immediately.
    MAX_RETRIES=5
    RETRY_COUNT=0
    while ! chromium-browser --kiosk --incognito --disable-infobars --noerrdialogs --disable-session-crashed-bubble "$KIOSK_URL" > /dev/null 2>&1;
    do
        RETRY_COUNT=$((RETRY_COUNT+1))
        if [ "$RETRY_COUNT" -ge "$MAX_RETRIES" ]; then
            echo "Chromium failed to start after $MAX_RETRIES attempts. Check X server and display configuration."
            # Optionally, kill the Node.js app if the browser can't start
            # if [ -n "$NODE_PID" ]; then kill $NODE_PID; fi
            exit 1
        fi
        echo "Chromium failed to start, retrying in 5 seconds... (Attempt $RETRY_COUNT/$MAX_RETRIES)"
        sleep 5
    done &
    echo "Chromium kiosk mode launched."
fi

echo "Kiosk startup script finished."
# The script will now exit, but the Node.js app and Chromium will continue running in the background.
