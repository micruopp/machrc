# machrc dotfiles

_what is a dotfile?_

A modern, polished dotfiles management system with beautiful terminal output and intelligent configuration management.

## Supported Programs

- **asdf** - Version manager for multiple languages
- **Firefox** - Web browser with custom profiles
- **Neovim** - Modern Vim-based editor
- **Terminal.app** - macOS terminal configurations
- **tmux** - Terminal multiplexer
- **Vim** - Classic text editor
- **VS Code** - Modern code editor with extensions and settings
- **Z-shell** - Advanced shell with custom prompts and aliases

## Installation

### Quick Start
```bash
# Install all configurations
./install.sh

# Install specific programs
./install.sh vscode zsh vim

# List available programs
./install.sh --list

# Show help
./install.sh --help
```

### Example Output
```
╔══════════════════════════════════════════════════════════════════════╗
║ machrc Setup • host=MyMac • user=johndoe • shell=zsh • EST           ║
╚══════════════════════════════════════════════════════════════════════╝
Started: 2025-10-19 14:30:15  •  Repo: ~/dotfiles  •  Dry-run: false

  → DOING  Discovering available programs
  ✓ OK     Found 6 programs: vim asdf nvim tmux zsh vscode

VSCODE
  → DOING  Installing vscode configuration
      - settings.json ................. already configured
      - keybindings.json .............. linked
      - code command .................. already configured
        • INFO Settings location: ~/Library/Application Support/Code/User
  ✓ OK     vscode configured

SUMMARY
  ✓ OK     3 succeeded
  ↻ SKIP   2 skipped (already configured)
  Duration: 00:00:02

Next steps:
  - Open a new terminal to load shell changes
  - Optional: set NO_COLOR=1 to disable colors in future runs

Done.
```

### Uninstallation
```bash
# Uninstall all configurations (with confirmation)
./uninstall.sh

# Uninstall specific programs
./uninstall.sh vscode

# List programs available for uninstall
./uninstall.sh --list
```

## Features

### 🎨 **Beautiful Output**
- **Professional UI**: Color-coded status messages with consistent formatting
- **Progress Tracking**: Clear indication of what's happening at each step
- **Smart Alignment**: Dotted lines for easy scanning of results
- **Summary Reports**: Detailed completion statistics with timing

### 🧠 **Intelligent Management**
- **Smart Detection**: Automatically detects existing configurations
- **Safe Operations**: Creates timestamped backups before making changes
- **Idempotent**: Safe to run multiple times without side effects
- **Clean Uninstall**: Restores original configurations when uninstalling

### 🔧 **Developer Friendly**
- **Modular Design**: Each program has its own install/uninstall scripts
- **Cross-Platform**: Works on macOS and Linux
- **NO_COLOR Support**: Respects the NO_COLOR environment variable
- **Error Handling**: Comprehensive error reporting with actionable hints

### 📦 **Extensible**
Adding a new program is as simple as:
1. Create a new directory (e.g., `myprogram/`)
2. Add `install.sh` and `uninstall.sh` scripts
3. The global installer automatically discovers and includes it

## Environment Variables

- `NO_COLOR=1` - Disable colored output while preserving formatting
- `MACHRC_DIR` - Automatically set to the dotfiles directory path

## Requirements

- **macOS**: macOS 10.15+ (tested on macOS 15+)
- **Linux**: Ubuntu 20.04+ or equivalent
- **Shell**: bash 3.2+ or zsh
- **Tools**: git, find, standard UNIX utilities

## Contributing

1. Fork the repository
2. Create your feature branch
3. Add install/uninstall scripts for your program
4. Test with `./install.sh --list` and `./install.sh yourprogram`
5. Submit a pull request

---

*Built with ❤️ for developers who love clean, automated setups*
