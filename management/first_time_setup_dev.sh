#!/bin/bash

set -e

echo "=== Development Environment Setup Starting ==="
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$REPO_DIR"

# -- Check for Node.js and npm --
echo "---------------------------------------------------------------------"
echo "Checking for Node.js and npm..."
if ! command -v node > /dev/null || ! command -v npm > /dev/null; then
    echo "Node.js or npm not found."
    echo "Please install Node.js (which includes npm). You can download it from https://nodejs.org/"
    echo "Or use a version manager like nvm: https://github.com/nvm-sh/nvm"
    echo "For example, on Debian/Ubuntu: sudo apt install nodejs npm"
    echo "On macOS (using Homebrew): brew install node"
    echo "---------------------------------------------------------------------"
    read -p "Press [Enter] to continue after ensuring Node.js and npm are installed, or Ctrl+C to exit..."
else
    echo "Node.js and npm found:"
    node -v
    npm -v
fi
echo "---------------------------------------------------------------------"

# -- Install Node.js dependencies --
echo "Installing Node.js dependencies from package.json..."
if [ -f "package.json" ]; then
    npm install
else
    echo "Error: package.json not found. Cannot install dependencies."
    echo "Please ensure your Node.js project is initialized (e.g., with 'npm init')."
    exit 1
fi

# Return to original directory
cd "$ORIGINAL_DIR"

echo "
=== Development Setup Complete! ===
Node.js dependencies are installed in the project root: $REPO_DIR
To run the application, type: npm start
"
