#!/bin/bash
# tmux/uninstall.sh
#
# @desc Uninstall tmux configuration files

set -e

echo "Uninstalling tmux configuration..."

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

restore_backup "$HOME/.tmux.conf"

echo "✓ tmux configuration uninstalled successfully"
echo "  Note: Restart tmux to apply changes"
