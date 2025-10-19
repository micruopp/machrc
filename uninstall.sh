#!/bin/bash
# uninstall.sh - Polished uninstaller for machrc dotfiles

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export MACHRC_DIR="$SCRIPT_DIR"
START_TIME=$(date +%s)
START_TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

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
        *"OK"*) ((COUNT_OK++)) ;;
        *"SKIP"*) ((COUNT_SKIP++)) ;;
        *"ERROR"*) ((COUNT_ERROR++)) ;;
    esac
    ((COUNT_TOTAL++))
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

    echo -e "${C_HEADER}╔══════════════════════════════════════════════════════════════════════╗${C_RESET}"
    echo -e "${C_HEADER}║ machrc Uninstall • host=${hostname} • user=${username} • shell=${shell_name} • ${timezone}${C_RESET}"
    echo -e "${C_HEADER}╚══════════════════════════════════════════════════════════════════════╝${C_RESET}"
    echo -e "Started: ${START_TIMESTAMP}  •  Repo: ${SCRIPT_DIR}\n"
}

print_summary() {
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    local duration_formatted=$(printf "%02d:%02d:%02d" $((duration/3600)) $((duration%3600/60)) $((duration%60)))

    echo -e "\n${C_BOLD}${C_HEADER}SUMMARY${C_RESET}"
    log_status "$S_OK" "$COUNT_OK succeeded"
    log_status "$S_SKIP" "$COUNT_SKIP skipped (not found)"
    if [[ $COUNT_ERROR -gt 0 ]]; then
        log_status "$S_ERROR" "$COUNT_ERROR failed"
    fi
    echo -e "  Duration: ${duration_formatted}\n"

    if [[ $COUNT_ERROR -eq 0 ]]; then
        echo "Uninstall completed successfully."
        echo -e "${C_BOLD}${C_HEADER}Done.${C_RESET}"
    else
        echo "Some operations failed. Check the output above for details."
    fi
}

discover_programs() {
    log_status "$S_DOING" "Discovering available programs"

    while IFS= read -r -d '' uninstall_script; do
        program_dir=$(dirname "$uninstall_script")
        program_name=$(basename "$program_dir")
        if [[ "$program_name" != "machrc" && "$program_name" != "." ]]; then
            AVAILABLE_PROGRAMS+=("$program_name")
        fi
    done < <(find "$SCRIPT_DIR" -name "uninstall.sh" -not -path "$SCRIPT_DIR/uninstall.sh" -print0)

    if [ ${#AVAILABLE_PROGRAMS[@]} -eq 0 ]; then
        log_status "$S_ERROR" "No programs with uninstall scripts found"
        return 1
    fi

    log_status "$S_OK" "Found ${#AVAILABLE_PROGRAMS[@]} programs: ${AVAILABLE_PROGRAMS[*]}"
    return 0
}

uninstall_program() {
    local program="$1"
    local uninstall_script="$SCRIPT_DIR/$program/uninstall.sh"

    if [[ ! -f "$uninstall_script" ]]; then
        log_status "$S_ERROR" "Uninstall script not found for $program"
        return 1
    fi

    echo -e "\n${C_BOLD}$(echo "$program" | tr '[:lower:]' '[:upper:]')${C_RESET}"
    log_status "$S_DOING" "Uninstalling $program configuration"

    if output=$(bash "$uninstall_script" 2>&1); then
        while IFS= read -r line; do
            [[ -z "$line" ]] && continue
            line=${line#> }

            if [[ "$line" =~ "Removing symlink"|"Uninstalling" ]]; then
                local item_name=$(echo "$line" | sed 's/.*Removing symlink: \|.*Uninstalling //' | cut -d' ' -f1)
                log_sub_item "$(basename "$item_name")" "${C_OK}removed${C_RESET}"
            elif [[ "$line" =~ "Restoring backup" ]]; then
                local item_name=$(echo "$line" | sed 's/.*-> //' | cut -d' ' -f1)
                log_sub_item "$(basename "$item_name")" "${C_OK}restored${C_RESET}"
            elif [[ "$line" =~ "✓".*"successfully" ]]; then
                continue
            elif [[ "$line" =~ "No.*found" ]]; then
                log_sub_item "config" "${C_SKIP}not found${C_RESET}"
            fi
        done <<< "$output"

        log_status "$S_OK" "$program uninstalled"
        return 0
    else
        log_status "$S_ERROR" "$program uninstall failed"
        echo -e "        ${S_INFO} Hint: check the error above"
        return 1
    fi
}

main() {
    case "${1:-}" in
        --list)
            if discover_programs > /dev/null 2>&1; then
                echo -e "${C_BOLD}Available programs for uninstall:${C_RESET}"
                for program in "${AVAILABLE_PROGRAMS[@]}"; do
                    echo "  - $program"
                done
            else
                echo -e "${C_ERROR}No programs with uninstall scripts found${C_RESET}"
            fi
            exit 0
            ;;
        --help|-h)
            echo -e "${C_BOLD}Usage:${C_RESET}"
            echo "  $0                Uninstall all programs (with confirmation)"
            echo "  $0 <program>      Uninstall specific program"
            echo "  $0 --list         List available programs"
            echo "  $0 --help         Show this help"
            exit 0
            ;;
    esac

    print_header
    discover_programs || exit 1

    if [[ $# -eq 0 ]]; then
        echo -e "${C_WARNING}WARNING: This will uninstall ALL programs!${C_RESET}"
        echo -e "This action will remove configurations and restore backups if available."
        echo -e "\nPrograms to be uninstalled: ${C_ERROR}${AVAILABLE_PROGRAMS[*]}${C_RESET}"

        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${C_WARNING}Uninstall cancelled.${C_RESET}"
            exit 0
        fi

        # Reverse order for uninstall (in case of dependencies)
        for ((i=${#AVAILABLE_PROGRAMS[@]}-1; i>=0; i--)); do
            program="${AVAILABLE_PROGRAMS[i]}"
            uninstall_program "$program"
        done
    else
        for program in "$@"; do
            if [[ " ${AVAILABLE_PROGRAMS[*]} " =~ " ${program} " ]]; then
                uninstall_program "$program"
            else
                log_status "$S_ERROR" "Program '$program' not found"
                echo -e "        ${S_INFO} Available programs: ${AVAILABLE_PROGRAMS[*]}"
            fi
        done
    fi

    print_summary
}

main "$@"
