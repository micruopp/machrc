#!/bin/bash
# asdf/uninstall.sh
#
# @desc Uninstall asdf configuration

set -e

echo "> Uninstalling asdf configuration..."

# Remove symlinks and restore backups if they exist
restore_backup() {
    local file="$1"
    if [[ -L "$file" ]]; then
        echo "> Removing symlink: $file"
        rm "$file"
    fi

    # Find most recent backup and restore it
    local backup=$(ls -t "${file}.machrc.backup."* 2>/dev/null | head -n 1)
    if [[ -n "$backup" ]]; then
        echo "> Restoring backup: $backup -> $file"
        mv "$backup" "$file"
    fi
}

restore_backup "$HOME/.tool-versions"

echo "> ✓ asdf configuration uninstalled successfully"
