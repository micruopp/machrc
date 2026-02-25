#!/bin/bash
# nvim/uninstall.sh
#
# @desc Uninstall neovim configuration files

set -e

echo "Uninstalling neovim configuration..."

# Remove symlinks and restore backups if they exist
restore_backup() {
    local file="$1"
    if [[ -L "$file" ]]; then
        echo "  Removing symlink: $file"
        rm "$file"
    elif [[ -d "$file" ]]; then
        echo "  Removing directory: $file"
        rm -rf "$file"
    fi

    # Find most recent backup and restore it
    local backup=$(ls -td "${file}.machrc.backup."* 2>/dev/null | head -n 1)
    if [[ -n "$backup" ]]; then
        echo "  Restoring backup: $backup -> $file"
        mv "$backup" "$file"
    fi
}

restore_backup "$HOME/.config/nvim"

echo "✓ neovim configuration uninstalled successfully"
