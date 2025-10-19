#!/bin/bash
# vscode/install.sh
#
# @desc Install and configure Visual Studio Code

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR=""

# Determine VS Code user settings directory based on OS
case "$(uname -s)" in
  Darwin)
    VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
    ;;
  Linux)
    VSCODE_USER_DIR="$HOME/.config/Code/User"
    ;;
  *)
    echo "Unsupported operating system"
    exit 1
    ;;
esac

# Create VS Code user directory if it doesn't exist
mkdir -p "$VSCODE_USER_DIR"

# Check and handle settings.json
if [[ -L "$VSCODE_USER_DIR/settings.json" ]] && [[ "$(readlink "$VSCODE_USER_DIR/settings.json")" == "$SCRIPT_DIR/settings.json" ]]; then
  echo "settings.json already linked to machrc configuration"
elif [[ -f "$VSCODE_USER_DIR/settings.json" ]]; then
  echo "Backing up existing settings.json"
  cp "$VSCODE_USER_DIR/settings.json" "$VSCODE_USER_DIR/settings.json.backup"
  echo "Linking settings.json"
  ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
else
  echo "Linking settings.json"
  ln -sf "$SCRIPT_DIR/settings.json" "$VSCODE_USER_DIR/settings.json"
fi

# Check and handle keybindings if file exists
if [[ -f "$SCRIPT_DIR/keybindings.json" ]]; then
  if [[ -L "$VSCODE_USER_DIR/keybindings.json" ]] && [[ "$(readlink "$VSCODE_USER_DIR/keybindings.json")" == "$SCRIPT_DIR/keybindings.json" ]]; then
    echo "keybindings.json already linked to machrc configuration"
  elif [[ -f "$VSCODE_USER_DIR/keybindings.json" ]]; then
    echo "Backing up existing keybindings.json"
    cp "$VSCODE_USER_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json.backup"
    echo "Linking keybindings.json"
    ln -sf "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
  else
    echo "Linking keybindings.json"
    ln -sf "$SCRIPT_DIR/keybindings.json" "$VSCODE_USER_DIR/keybindings.json"
  fi
fi

# Check shell command availability on macOS
if [[ "$(uname -s)" == "Darwin" ]]; then
  if ! command -v code &> /dev/null; then
    echo "Installing 'code' shell command"
    echo "Note: Ensure VS Code shell command is installed via VS Code Command Palette"
  else
    echo "code command already available"
  fi
fi

echo "✓ VS Code configuration installed successfully"
echo "Settings location: $VSCODE_USER_DIR"
