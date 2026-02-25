#!/bin/bash
# vim/uninstall.sh
#
# @desc Uninstall vim configuration files

set -e

echo "Uninstalling vim configuration..."

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

restore_backup "$HOME/.vimrc"

# Remove vim config files from .vim directory
for config_file in opts.vim remaps.vim local.vim; do
    restore_backup "$HOME/.vim/$config_file"
done

echo "✓ vim configuration uninstalled successfully"
