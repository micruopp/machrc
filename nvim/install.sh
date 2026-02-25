#!/bin/bash
# nvim/install.sh
#
# @desc Install neovim configuration files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACHRC_DIR="${MACHRC_DIR:-$(dirname "$SCRIPT_DIR")}"

# Backup existing files if they exist and check for existing links
backup_if_exists() {
    local file="$1"
    local source="$2"

    if [[ -L "$file" ]] && [[ "$(readlink "$file")" == "$source" ]]; then
        echo "nvim directory already linked to machrc configuration"
        return 0
    elif [[ -f "$file" ]] || [[ -L "$file" ]] || [[ -d "$file" ]]; then
        local backup="${file}.machrc.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing nvim configuration"
        mv "$file" "$backup"
        return 1
    fi
    return 1
}

# Create neovim config directory
mkdir -p "$HOME/.config"

# Create symlinks for neovim config
if backup_if_exists "$HOME/.config/nvim" "$SCRIPT_DIR"; then
    : # Already linked
else
    echo "Linking nvim configuration directory"
    ln -sf "$SCRIPT_DIR" "$HOME/.config/nvim"
fi

echo "✓ neovim configuration installed successfully"
