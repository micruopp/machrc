#!/bin/bash
# zsh/install.sh
#
# @desc Install zsh configuration files

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

# Create symlinks for zsh config files
if backup_if_exists "$HOME/.zshenv" "$SCRIPT_DIR/zshenv"; then
    : # Already linked
else
    echo "Linking .zshenv"
    ln -sf "$SCRIPT_DIR/zshenv" "$HOME/.zshenv"
fi

if backup_if_exists "$HOME/.zprofile" "$SCRIPT_DIR/zprofile"; then
    : # Already linked
else
    echo "Linking .zprofile"
    ln -sf "$SCRIPT_DIR/zprofile" "$HOME/.zprofile"
fi

if backup_if_exists "$HOME/.zshrc" "$SCRIPT_DIR/zshrc"; then
    : # Already linked
else
    echo "Linking .zshrc"
    ln -sf "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
fi

if backup_if_exists "$HOME/.zlogin" "$SCRIPT_DIR/zlogin"; then
    : # Already linked
else
    echo "Linking .zlogin"
    ln -sf "$SCRIPT_DIR/zlogin" "$HOME/.zlogin"
fi

if backup_if_exists "$HOME/.zlogout" "$SCRIPT_DIR/zlogout"; then
    : # Already linked
else
    echo "Linking .zlogout"
    ln -sf "$SCRIPT_DIR/zlogout" "$HOME/.zlogout"
fi

echo "✓ zsh configuration installed successfully"
echo "Note: Restart your terminal or run 'source ~/.zshrc' to apply changes"
