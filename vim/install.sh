#!/bin/bash
# vim/install.sh
#
# @desc Install vim configuration files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACHRC_DIR="${MACHRC_DIR:-$(dirname "$SCRIPT_DIR")}"

# Backup existing files if they exist and check for existing links
backup_if_exists() {
    local file="$1"
    local source="$2"

    if [[ -L "$file" ]] && [[ "$(readlink "$file")" == "$source" ]]; then
        echo "$(basename "$file") already linked to machrc configuration"
        return 0
    elif [[ -f "$file" ]] || [[ -L "$file" ]]; then
        local backup="${file}.machrc.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing $(basename "$file")"
        mv "$file" "$backup"
        return 1
    fi
    return 1
}

# Create .vim directory if it doesn't exist
mkdir -p "$HOME/.vim"

# Create symlinks for vim config files
if backup_if_exists "$HOME/.vimrc" "$SCRIPT_DIR/vimrc"; then
    : # Already linked
else
    echo "Linking .vimrc"
    ln -sf "$SCRIPT_DIR/vimrc" "$HOME/.vimrc"
fi

# Link individual vim config files to .vim directory
for config_file in opts.vim remaps.vim local.vim; do
    if [[ -f "$SCRIPT_DIR/$config_file" ]]; then
        if backup_if_exists "$HOME/.vim/$config_file" "$SCRIPT_DIR/$config_file"; then
            : # Already linked
        else
            echo "Linking $config_file"
            ln -sf "$SCRIPT_DIR/$config_file" "$HOME/.vim/$config_file"
        fi
    fi
done

echo "✓ vim configuration installed successfully"
