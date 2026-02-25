#!/bin/bash
# tmux/install.sh
#
# @desc Install tmux configuration files

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

# Create symlinks for tmux config files
if backup_if_exists "$HOME/.tmux.conf" "$SCRIPT_DIR/tmux.conf"; then
    : # Already linked
else
    echo "Linking .tmux.conf"
    ln -sf "$SCRIPT_DIR/tmux.conf" "$HOME/.tmux.conf"
fi

# Install tmux-256color terminfo if it exists
if [[ -f "$SCRIPT_DIR/tmux-256color" ]]; then
    if infocmp tmux-256color &>/dev/null; then
        echo "tmux-256color terminfo already installed"
    else
        echo "Installing tmux-256color terminfo"
        tic -x "$SCRIPT_DIR/tmux-256color"
    fi
fi

echo "✓ tmux configuration installed successfully"
echo "Note: Restart tmux or run 'tmux source-file ~/.tmux.conf' to apply changes"
