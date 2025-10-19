#!/bin/bash

# echo "You didn't write the install script yet, dummy."

# Installation
#
# x. Zsh
#   - Link .zshenv
#   - Link .zshrc
#   - Link .zlogin
#   - Link .zlogout
#
# x. Package manager
#   - Homebrew
#   - MacPorts
#
# x. asdf
#   - Link root .tool-versions
#
# x. Vim
#   - Link .vimrc
#
# x. Neovim
#   -
#
# x. VS Code
#   - Link settings.json
#   - Link keybindings.json
#
# x. macOS
#   - Terminal.app
#     - Set profiles
#   - System settings
#     - Set Dock preferences
#     - Set Menu bar preferences
#   - Web browser (Firefox)
#   - Web browser (Chromium)
#
# x. Ubuntu Server
#   - Bash
#     - Link .bashrc
#     - Link .bash_profile


# install.sh - Polished installer for machrc dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export MACHRC_DIR="$SCRIPT_DIR"
START_TIME=$(date +%s)
START_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check for dry-run mode
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    shift # Remove --dry-run from arguments
fi

# Colors and formatting (respect NO_COLOR)
if [[ -z "${NO_COLOR:-}" ]]; then
    readonly C_OK='\033[32m'
    readonly C_SKIP='\033[33m'
    readonly C_DOING='\033[36m'
    readonly C_ERROR='\033[31m'
    readonly C_INFO='\033[35m'
    readonly C_HEADER='\033[1m\033[34m'
    readonly C_BOLD='\033[1m'
    readonly C_RESET='\033[0m'
    readonly C_WARNING='\033[1m\033[33m'
else
    readonly C_OK=''
    readonly C_SKIP=''
    readonly C_DOING=''
    readonly C_ERROR=''
    readonly C_INFO=''
    readonly C_HEADER=''
    readonly C_BOLD=''
    readonly C_RESET=''
    readonly C_WARNING=''
fi

# Status symbols
readonly S_OK="${C_OK}✓ OK${C_RESET}"
readonly S_SKIP="${C_SKIP}↻ SKIP${C_RESET}"
readonly S_DOING="${C_DOING}→ DOING${C_RESET}"
readonly S_ERROR="${C_ERROR}✖ ERROR${C_RESET}"
readonly S_INFO="${C_INFO}• INFO${C_RESET}"

# Global counters
COUNT_OK=0
COUNT_SKIP=0
COUNT_ERROR=0
COUNT_TOTAL=0

# Available programs
AVAILABLE_PROGRAMS=()

# Utility functions
log_status() {
    local status="$1"
    local message="$2"
    local indent="${3:-  }"
    echo -e "${indent}${status}  ${message}"

    case "$status" in
        *"OK"*) COUNT_OK=$((COUNT_OK + 1)) ;;
        *"SKIP"*) COUNT_SKIP=$((COUNT_SKIP + 1)) ;;
        *"ERROR"*) COUNT_ERROR=$((COUNT_ERROR + 1)) ;;
    esac
    COUNT_TOTAL=$((COUNT_TOTAL + 1))
}

log_sub_item() {
    local name="$1"
    local status="$2"
    local dots_count=$((30 - ${#name}))
    [[ $dots_count -lt 1 ]] && dots_count=1
    local dots=$(printf "%*s" $dots_count | tr ' ' '.')
    echo -e "      - ${name} ${dots} ${status}"
}

print_header() {
    local hostname=$(scutil --get ComputerName 2>/dev/null || hostname -s 2>/dev/null || echo "unknown")
    local username=$(whoami)
    local shell_name=$(basename "$SHELL")
    local timezone=$(date +%Z 2>/dev/null || echo "UTC")
    local dry_run_status="${C_ERROR}false${C_RESET}"

    if [[ "$DRY_RUN" == "true" ]]; then
        dry_run_status="${C_WARNING}true${C_RESET}"
    fi

    echo -e "${C_HEADER}╔══════════════╗${C_RESET}"
    echo -e "${C_HEADER}║ machrc Setup ║ host=${hostname} • user=${username} • shell=${shell_name} • ${timezone}${C_RESET}"
    echo -e "${C_HEADER}╚══════════════╝${C_RESET}"
    echo -e "Started: ${START_TIMESTAMP}  •  Repo: ${SCRIPT_DIR}  •  Dry-run: ${dry_run_status}\n"
}

print_summary() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local duration_formatted=$(printf "%02d:%02d:%02d" $((duration/3600)) $((duration%3600/60)) $((duration%60)))

    echo -e "\n${C_BOLD}${C_HEADER}SUMMARY${C_RESET}"
    log_status "$S_OK" "$COUNT_OK succeeded"
    log_status "$S_SKIP" "$COUNT_SKIP skipped (already configured)"
    if [[ $COUNT_ERROR -gt 0 ]]; then
        log_status "$S_ERROR" "$COUNT_ERROR failed"
    fi
    echo -e "  Duration: ${duration_formatted}\n"

    if [[ $COUNT_ERROR -eq 0 ]]; then
        echo "Next steps:"
        echo "  - Open a new terminal to load shell changes"
        echo "  - Optional: set NO_COLOR=1 to disable colors in future runs"
        echo ""
        echo -e "${C_BOLD}${C_HEADER}Done.${C_RESET}"
    else
        echo "Some operations failed. Check the output above for details."
        echo -e "You can retry with: ${C_BOLD}./install.sh --retry${C_RESET}\n"
    fi
}

discover_programs() {
    while IFS= read -r -d '' install_script; do
        program_dir=$(dirname "$install_script")
        program_name=$(basename "$program_dir")
        if [[ "$program_name" != "machrc" && "$program_name" != "." ]]; then
            AVAILABLE_PROGRAMS+=("$program_name")
        fi
    done < <(find "$SCRIPT_DIR" -name "install.sh" -not -path "$SCRIPT_DIR/install.sh" -print0)

    if [ ${#AVAILABLE_PROGRAMS[@]} -eq 0 ]; then
        echo -e "${C_ERROR}✖ ERROR${C_RESET}  No programs with install scripts found"
        return 1
    fi

    return 0
}

install_program() {
    local program="$1"
    local install_script="$SCRIPT_DIR/$program/install.sh"

    if [[ ! -f "$install_script" ]]; then
        log_status "$S_ERROR" "Install script not found for $program"
        return 1
    fi

    echo -e "\n${C_BOLD}$(echo "$program" | tr '[:lower:]' '[:upper:]')${C_RESET}"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_status "${C_INFO}📋 PREVIEW${C_RESET}" "Would install $program configuration"
        if dry_run_program "$program" "$install_script"; then
            log_status "$S_OK" "$program would be configured"
        else
            log_status "$S_SKIP" "$program already configured"
        fi
        return 0
    else
        log_status "$S_DOING" "Installing $program configuration"
    fi

    # Track whether any actual work was done
    local actual_work_done=false
    local skip_count=0

    if output=$(bash "$install_script" 2>&1); then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            line=${line#> }

            if [[ "$line" =~ "already linked"|"already configured"|"already present"|"already current"|"already available" ]]; then
                local item_name=$(echo "$line" | cut -d' ' -f1)
                log_sub_item "$item_name" "${C_SKIP}already configured${C_RESET}"
                skip_count=$((skip_count + 1))
            elif [[ "$line" =~ "Linking"|"Installing"|"Backing up" ]]; then
                local item_name=$(echo "$line" | sed 's/.*Linking \|.*Installing \|.*Backing up //' | cut -d' ' -f1)
                log_sub_item "$item_name" "${C_OK}linked${C_RESET}"
                actual_work_done=true
            elif [[ "$line" =~ "✓".*"successfully" ]]; then
                continue
            elif [[ "$line" =~ "Note:".*|"Settings location:" ]]; then
                echo -e "        ${S_INFO} ${line#Note: }"
            fi
        done <<< "$output"

        # Determine final status based on whether work was done
        if [[ "$actual_work_done" == "true" ]]; then
            log_status "$S_OK" "$program configured"
        elif [[ "$skip_count" -gt 0 ]]; then
            log_status "$S_SKIP" "$program already configured"
        else
            log_status "$S_OK" "$program configured"
        fi
        return 0
    else
        log_status "$S_ERROR" "$program installation failed"
        echo -e "        ${S_INFO} Hint: check the error above or rerun with --verbose"
        return 1
    fi
}

# Dry-run version that analyzes what would be done
dry_run_program() {
    local program="$1"
    local install_script="$2"
    local work_needed=false

    # Analyze what files would be affected based on the program
    case "$program" in
        "vscode")
            local vscode_dir=""
            case "$(uname -s)" in
                Darwin) vscode_dir="$HOME/Library/Application Support/Code/User" ;;
                Linux) vscode_dir="$HOME/.config/Code/User" ;;
            esac

            if [[ -L "$vscode_dir/settings.json" ]]; then
                log_sub_item "settings.json" "${C_SKIP}already linked${C_RESET}"
            elif [[ -f "$vscode_dir/settings.json" ]]; then
                log_sub_item "settings.json" "${C_WARNING}would backup and link${C_RESET}"
                work_needed=true
            else
                log_sub_item "settings.json" "${C_OK}would link${C_RESET}"
                work_needed=true
            fi

            if command -v code &> /dev/null; then
                log_sub_item "code command" "${C_SKIP}already available${C_RESET}"
            else
                log_sub_item "code command" "${C_INFO}would check availability${C_RESET}"
            fi
            ;;

        "zsh")
            for config in .zshenv .zprofile .zshrc .zlogin .zlogout; do
                if [[ -L "$HOME/$config" ]]; then
                    log_sub_item "$config" "${C_SKIP}already linked${C_RESET}"
                elif [[ -f "$HOME/$config" ]]; then
                    log_sub_item "$config" "${C_WARNING}would backup and link${C_RESET}"
                    work_needed=true
                else
                    log_sub_item "$config" "${C_OK}would link${C_RESET}"
                    work_needed=true
                fi
            done
            ;;

        "vim")
            if [[ -L "$HOME/.vimrc" ]]; then
                log_sub_item ".vimrc" "${C_SKIP}already linked${C_RESET}"
            elif [[ -f "$HOME/.vimrc" ]]; then
                log_sub_item ".vimrc" "${C_WARNING}would backup and link${C_RESET}"
                work_needed=true
            else
                log_sub_item ".vimrc" "${C_OK}would link${C_RESET}"
                work_needed=true
            fi

            for config in opts.vim remaps.vim local.vim; do
                if [[ -f "$SCRIPT_DIR/vim/$config" ]]; then
                    if [[ -L "$HOME/.vim/$config" ]]; then
                        log_sub_item "$config" "${C_SKIP}already linked${C_RESET}"
                    elif [[ -f "$HOME/.vim/$config" ]]; then
                        log_sub_item "$config" "${C_WARNING}would backup and link${C_RESET}"
                        work_needed=true
                    else
                        log_sub_item "$config" "${C_OK}would link${C_RESET}"
                        work_needed=true
                    fi
                fi
            done
            ;;

        "nvim")
            if [[ -L "$HOME/.config/nvim" ]]; then
                log_sub_item "nvim directory" "${C_SKIP}already linked${C_RESET}"
            elif [[ -d "$HOME/.config/nvim" ]]; then
                log_sub_item "nvim directory" "${C_WARNING}would backup and link${C_RESET}"
                work_needed=true
            else
                log_sub_item "nvim directory" "${C_OK}would link${C_RESET}"
                work_needed=true
            fi
            ;;

        "tmux")
            if [[ -L "$HOME/.tmux.conf" ]]; then
                log_sub_item ".tmux.conf" "${C_SKIP}already linked${C_RESET}"
            elif [[ -f "$HOME/.tmux.conf" ]]; then
                log_sub_item ".tmux.conf" "${C_WARNING}would backup and link${C_RESET}"
                work_needed=true
            else
                log_sub_item ".tmux.conf" "${C_OK}would link${C_RESET}"
                work_needed=true
            fi

            if [[ -f "$SCRIPT_DIR/tmux/tmux-256color" ]]; then
                if infocmp tmux-256color &>/dev/null; then
                    log_sub_item "tmux-256color" "${C_SKIP}already installed${C_RESET}"
                else
                    log_sub_item "tmux-256color" "${C_OK}would install${C_RESET}"
                    work_needed=true
                fi
            fi
            ;;

        "asdf")
            if [[ -L "$HOME/.tool-versions" ]]; then
                log_sub_item ".tool-versions" "${C_SKIP}already linked${C_RESET}"
            elif [[ -f "$HOME/.tool-versions" ]]; then
                log_sub_item ".tool-versions" "${C_WARNING}would backup and link${C_RESET}"
                work_needed=true
            else
                log_sub_item ".tool-versions" "${C_OK}would link${C_RESET}"
                work_needed=true
            fi
            ;;

        *)
            log_sub_item "configuration" "${C_INFO}would analyze and link${C_RESET}"
            work_needed=true
            ;;
    esac

    # Return 0 if work is needed (success case), 1 if everything is already configured (skip case)
    if [[ "$work_needed" == "true" ]]; then
        return 0
    else
        return 1
    fi
}

main() {
    case "${1:-}" in
        --list)
            # Temporarily disable set -e for discovery
            set +e
            discover_programs > /dev/null 2>&1
            list_success=$?
            set -e

            if [[ $list_success -eq 0 ]]; then
                echo -e "${C_BOLD}Available programs:${C_RESET}"
                for program in "${AVAILABLE_PROGRAMS[@]}"; do
                    echo "  - $program"
                done
            else
                echo -e "${C_ERROR}No programs with install scripts found${C_RESET}"
            fi
            exit 0
            ;;
        --help|-h)
            echo -e "${C_BOLD}Usage:${C_RESET}"
            echo "  $0                Install all programs"
            echo "  $0 <program>      Install specific program"
            echo "  $0 --list         List available programs"
            echo "  $0 --help         Show this help"
            echo "  $0 --dry-run      Show what would be done"
            exit 0
            ;;
    esac

    print_header
    discover_programs || exit 1

    if [[ $# -eq 0 ]]; then
        for program in "${AVAILABLE_PROGRAMS[@]}"; do
            install_program "$program"
        done
    else
        for program in "$@"; do
            if [[ " ${AVAILABLE_PROGRAMS[*]} " =~ " ${program} " ]]; then
                install_program "$program"
            else
                log_status "$S_ERROR" "Program '$program' not found"
                echo -e "        ${S_INFO} Available programs: ${AVAILABLE_PROGRAMS[*]}"
            fi
        done
    fi

    print_summary
}

main "$@"
