#!/bin/bash
# zsh/uninstall.sh
#
# @desc Uninstall zsh configuration files

set -e

echo "Uninstalling zsh configuration..."

# Remove symlinks and restore backups if they exist
restore_backup() {
    local file="$1"
    if [[ -L "$file" ]]; then
        echo "  Removing symlink: $file"
        rm "$file"
    fi

    # Find most recent backup and restore it
    local backup=$(ls -t "${file}.machrc.backup."* 2>/dev/null | head -n 1)
    if [[ -n "$backup" ]]; then
        echo "  Restoring backup: $backup -> $file"
        mv "$backup" "$file"
    fi
}

restore_backup "$HOME/.zshenv"
restore_backup "$HOME/.zprofile"
restore_backup "$HOME/.zshrc"
restore_backup "$HOME/.zlogin"
restore_backup "$HOME/.zlogout"

echo "✓ zsh configuration uninstalled successfully"
echo "  Note: Restart your terminal to apply changes"
