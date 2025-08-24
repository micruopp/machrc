#!/bin/sh


export MACHRC_DIR="$HOME/Developer/machrc"


# Helpers

link_machrc_file() {
	local src_file="$1"
	local tgt_file="$2"
	
	echo "Linking $src_file to $tgt_file"
	ln -s "$src_file" "$tgt_file"
}


# x. Zsh
#   - Link .zshenv
#   - Link .zshrc
#   - Link .zlogin
#   - Link .zlogout

# install-zsh.sh

link_zsh_files() {
	local src_zshenv="$MACHRC_DIR/zsh/zshenv"
	local tgt_zshenv="$HOME/.zshenv"
	link_machrc_file "$src_zshenv" "$tgt_zshenv"

	local src_zshrc="$MACHRC_DIR/zsh/zshrc"
	local tgt_zshrc="$HOME/.zshrc"
	link_machrc_file "$src_zshrc" "$tgt_zshrc"
}


# x. Package manager
#   - Homebrew
#   - MacPorts
#
# x. asdf
#   - Link root .tool-versions
#
# x. Vim
#   - Link .vimrc

# install-vim.sh

link_vim_config_files() {
	local src_vimrc="$MACHRC_DIR/vim/vimrc"
	local tgt_vimrc="$HOME/.vimrc"
	link_machrc_file "$src_vimrc" "$tgt_vimrc"
}


# x. Neovim
#   - 

# install-neovim.sh


# Run install

# 1. Zsh
link_zsh_files

# X. Vim
link_vim_config_files


# macOS Sequoia 15.3.1 environment variables
#
# MANPATH=:/usr/share/man:/usr/local/share/man:/Applications/Ghostty.app/Contents/Resources/ghostty/../man:
# GHOSTTY_RESOURCES_DIR=/Applications/Ghostty.app/Contents/Resources/ghostty
# TERM_PROGRAM=ghostty
# SHELL=/bin/zsh
# TERM=xterm-ghostty
# TMPDIR=/var/folders/32/_dltnlq90dd693kv76ghhgjc0000gn/T/
# TERM_PROGRAM_VERSION=1.1.3
# USER=michalruopp
# COMMAND_MODE=unix2003
# SSH_AUTH_SOCK=/private/tmp/com.apple.launchd.hg75gNIoL4/Listeners
# __CF_USER_TEXT_ENCODING=0x0:0:0
# PATH=/Users/michalruopp/.asdf/shims:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/Ghostty.app/Contents/MacOS
# __CFBundleIdentifier=com.mitchellh.ghostty
# PWD=/Users/michalruopp/Developer/machrc
# LANG=en_US.UTF-8
# XPC_FLAGS=0x0
# XPC_SERVICE_NAME=0
# SHLVL=1
# HOME=/Users/michalruopp
# TERMINFO=/Applications/Ghostty.app/Contents/Resources/terminfo
# GHOSTTY_SHELL_INTEGRATION_NO_SUDO=1
# LOGNAME=michalruopp
# XDG_DATA_DIRS=/usr/local/share:/usr/share:/Applications/Ghostty.app/Contents/Resources/ghostty/..
# GHOSTTY_BIN_DIR=/Applications/Ghostty.app/Contents/MacOS
# COLORTERM=truecolor
# OLDPWD=/Users/michalruopp
# HOMEBREW_PREFIX=/opt/homebrew
# HOMEBREW_CELLAR=/opt/homebrew/Cellar
# HOMEBREW_REPOSITORY=/opt/homebrew
# INFOPATH=/opt/homebrew/share/info:
# _=/usr/bin/printenv
