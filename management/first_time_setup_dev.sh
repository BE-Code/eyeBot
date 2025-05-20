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

# -- Create and activate virtual environment --
echo "Creating Python virtual environment in $VENV_DIR..."
python3 -m venv "$VENV_DIR"

echo "Activating virtual environment..."
echo "To activate it manually in the future, run: source $VENV_DIR/bin/activate"
source "$VENV_DIR/bin/activate"

# -- Install Python dependencies --
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
To activate it, navigate to $REPO_DIR and run: source $VENV_DIR/bin/activate
To run the application, use: python $SCRIPT_NAME (after activating the venv)
"
