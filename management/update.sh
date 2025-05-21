#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_ROOT/update.log"

# Redirect stdout and stderr for the entire script to a log file
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting Update - $(date)"

# Store the original directory
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$PROJECT_ROOT"

echo "Pulling latest changes from git..."
git pull

# Install/update Node.js dependencies if package.json exists
echo "Checking for Node.js dependencies..."
if [ -f "package.json" ]; then
    echo "Installing/updating Node.js dependencies..."
    # Using npm ci if package-lock.json exists, otherwise npm install
    # npm ci is generally preferred for reproducible builds in CI/deployment
    if [ -f "package-lock.json" ]; then
        npm ci --production
    else
        npm install --production
    fi
    echo "Node.js dependencies updated."
else
    echo "Warning: package.json not found. Skipping Node.js dependency installation."
fi

# Return to original directory
cd "$ORIGINAL_DIR"

echo "Update script finished - $(date)"
