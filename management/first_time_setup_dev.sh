#!/bin/bash

set -e

# -- Config --
SCRIPT_NAME="main.py"
VENV_DIR="venv"

echo "=== Development Environment Setup Starting ==="
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$REPO_DIR"

# -- Instructions for system dependencies (manual step) --
echo "---------------------------------------------------------------------"
echo "Please ensure you have Python 3, pip, and venv installed."
echo "For example, on Debian/Ubuntu: sudo apt install python3 python3-pip python3-venv"
echo "On macOS (using Homebrew): brew install python"
echo "---------------------------------------------------------------------"
read -p "Press [Enter] to continue after ensuring dependencies are met..."

# -- Create virtual environment --
echo "Creating Python virtual environment in $VENV_DIR..."
python3 -m venv "$VENV_DIR"

# -- Install Python dependencies (will use the new venv automatically if script is sourced or pip is called from venv) --
echo "Activating virtual environment to install packages..."
source "$VENV_DIR/bin/activate"

echo "Installing/updating pip..."
pip install --upgrade pip

echo "Installing Python dependencies from requirements.txt..."
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "Warning: requirements.txt not found. Skipping dependency installation."
fi

# Return to original directory
cd "$ORIGINAL_DIR"

echo "
=== Development Setup Complete! ===
Virtual environment '$VENV_DIR' is ready in the project root: $REPO_DIR
To run the application, navigate to $REPO_DIR and use: ./management/start.sh

If you need to install more packages or run Python tools directly,
activate the environment first with: source $VENV_DIR/bin/activate
"
