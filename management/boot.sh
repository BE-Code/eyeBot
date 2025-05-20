#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Store the original directory
ORIGINAL_DIR="$(pwd)"

# Change to project root
cd "$PROJECT_ROOT"

# Run update script
"$SCRIPT_DIR/update.sh"

# Run start script
"$SCRIPT_DIR/start.sh"

# Return to original directory
cd "$ORIGINAL_DIR"
