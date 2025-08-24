#!/bin/bash

# echo "Installing ghostty..."
# brew install --cask ghostty

GHOSTTY_CONFIG_DIR="/Users/$USER/Library/Application\ Support/com.mitchellh.ghostty"
echo "Backing up config file to $GHOSTTY_CONFIG_DIR/config.bak"
#cp ~/Library/Application\ Support/com.mitchellh.ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/config.bak
cp "$GHOSTTY_CONFIG_DIR"/config "$GHOSTTY_CONFIG_DIR"/config.bak

echo "Copying custom Ghostty config..."
#cp $MACHRC_DIR/ghostty/config ~/Library/Application\ Support/com.mitchellh.ghostty/

echo "Ghostty is installed and configured."
