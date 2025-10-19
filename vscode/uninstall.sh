#!/bin/bash
# vscode/uninstall.sh
#
# @desc Uninstall Visual Studio Code configuration

set -e

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

echo "Uninstalling VS Code configuration..."

# Remove symlinked settings
if [[ -L "$VSCODE_USER_DIR/settings.json" ]]; then
  echo "Removing linked settings.json..."
  rm "$VSCODE_USER_DIR/settings.json"

  # Restore backup if it exists
  if [[ -f "$VSCODE_USER_DIR/settings.json.backup" ]]; then
    echo "Restoring settings.json from backup..."
    mv "$VSCODE_USER_DIR/settings.json.backup" "$VSCODE_USER_DIR/settings.json"
  fi
else
  echo "No linked settings.json found"
fi

# Remove symlinked keybindings
if [[ -L "$VSCODE_USER_DIR/keybindings.json" ]]; then
  echo "Removing linked keybindings.json..."
  rm "$VSCODE_USER_DIR/keybindings.json"

  # Restore backup if it exists
  if [[ -f "$VSCODE_USER_DIR/keybindings.json.backup" ]]; then
    echo "Restoring keybindings.json from backup..."
    mv "$VSCODE_USER_DIR/keybindings.json.backup" "$VSCODE_USER_DIR/keybindings.json"
  fi
else
  echo "No linked keybindings.json found"
fi

echo "VS Code configuration uninstalled successfully!"
