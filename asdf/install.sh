#!/bin/bash
# asdf/install.sh
#
# @desc Install asdf configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MACHRC_DIR="${MACHRC_DIR:-$(dirname "$SCRIPT_DIR")}"

# Backup existing files if they exist and check for existing links
backup_if_exists() {
    local file="$1"
    local source="$2"

    if [[ -L "$file" ]] && [[ "$(readlink "$file")" == "$source" ]]; then
        echo ".tool-versions already linked to machrc configuration"
        return 0
    elif [[ -f "$file" ]] || [[ -L "$file" ]]; then
        local backup="${file}.machrc.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Backing up existing .tool-versions"
        mv "$file" "$backup"
        return 1
    fi
    return 1
}

# Link .tool-versions file
if backup_if_exists "$HOME/.tool-versions" "$SCRIPT_DIR/tool-versions"; then
    : # Already linked
else
    echo "Linking .tool-versions"
    ln -sf "$SCRIPT_DIR/tool-versions" "$HOME/.tool-versions"
fi

echo "✓ asdf configuration installed successfully"
