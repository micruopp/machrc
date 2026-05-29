#!/usr/bin/env bash

# cleanup/macos.sh
# @desc macOS system cleanup — disk analysis and safe cleanup for known disk hogs
#
# Usage:
#   ./cleanup/macos.sh [options] [target ...]
#
# Options:
#   -n, --dry-run    Show what would be removed without removing anything
#   -a, --analyze    Disk usage analysis only, no cleanup
#   -y, --yes        Skip per-section confirmation prompts
#
# Targets (default: all):
#   xcode            Xcode DerivedData, iOS DeviceSupport, unavailable simulators
#   docker           Docker system prune + volume prune (Colima-compatible)
#   node             npm cache
#   media            Apple mediaanalysisd / photoanalysisd caches
#   logs             ~/Library/Logs


# ─────────────────────────────────────────────────────────────
# Flags
# ─────────────────────────────────────────────────────────────

DRY_RUN=false
ANALYZE_ONLY=false
YES=false
TARGETS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)  DRY_RUN=true;      shift ;;
    -a|--analyze)  ANALYZE_ONLY=true; shift ;;
    -y|--yes)      YES=true;          shift ;;
    -*)            echo "Unknown option: $1" >&2; exit 1 ;;
    *)             TARGETS+=("$1");   shift ;;
  esac
done

[[ ${#TARGETS[@]} -eq 0 ]] && TARGETS=("all")


# ─────────────────────────────────────────────────────────────
# Output helpers
# ─────────────────────────────────────────────────────────────

BOLD=$'\e[1m'
DIM=$'\e[2m'
RED=$'\e[31m'
YELLOW=$'\e[33m'
CYAN=$'\e[36m'
GREEN=$'\e[32m'
RESET=$'\e[0m'

header()  { echo; echo "${BOLD}${CYAN}── $* ──${RESET}"; echo; }
info()    { echo "   ${DIM}$*${RESET}"; }
warn()    { echo "   ${YELLOW}! $*${RESET}"; }
ok()      { echo "   ${GREEN}✔${RESET}  $*"; }
fail()    { echo "   ${RED}✖${RESET}  $*"; }

size_of() {
  du -sh "$1" 2>/dev/null | cut -f1
}


# ─────────────────────────────────────────────────────────────
# Core actions
# ─────────────────────────────────────────────────────────────

# Remove a path, with dry-run support
remove() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    info "Not found: $path"
    return
  fi
  local size
  size=$(size_of "$path")
  if $DRY_RUN; then
    warn "[dry-run] Would remove: $path  (${size})"
  else
    echo "   Removing $path  (${size}) ..."
    rm -rf "$path"
    ok "Removed: $path"
  fi
}

# Kill a named process, with dry-run support
kill_proc() {
  local name="$1"
  if pgrep -x "$name" &>/dev/null; then
    if $DRY_RUN; then
      warn "[dry-run] Would kill: $name"
    else
      killall "$name" 2>/dev/null && ok "Killed: $name" || true
    fi
  else
    info "Not running: $name"
  fi
}

# Ask for confirmation; skipped in --yes or --dry-run mode
confirm() {
  $YES      && return 0
  $DRY_RUN  && return 0
  local reply
  read -rp "   ${BOLD}Proceed? [y/N]${RESET} " reply
  [[ "$reply" =~ ^[Yy]$ ]]
}


# ─────────────────────────────────────────────────────────────
# Analysis
# ─────────────────────────────────────────────────────────────

analyze() {
  header "Disk Usage Analysis"

  echo "   ${BOLD}Top-level home (top 10):${RESET}"
  du -xh -d 1 ~ 2>/dev/null | sort -hr | head -10 | sed 's/^/   /'

  echo
  echo "   ${BOLD}~/Library (top 10):${RESET}"
  du -xh -d 1 ~/Library 2>/dev/null | sort -hr | head -10 | sed 's/^/   /'

  echo
  echo "   ${BOLD}~/Library/Containers (top 10):${RESET}"
  du -xh -d 1 ~/Library/Containers 2>/dev/null | sort -hr | head -10 | sed 's/^/   /'

  echo
  echo "   ${BOLD}~/Library/Developer (top 10):${RESET}"
  du -xh -d 1 ~/Library/Developer 2>/dev/null | sort -hr | head -10 | sed 's/^/   /'

  echo
  echo "   ${BOLD}APFS local snapshots:${RESET}"
  tmutil listlocalsnapshots / 2>/dev/null | sed 's/^/   /' || info "None found or tmutil unavailable"
}


# ─────────────────────────────────────────────────────────────
# Cleanup targets
# ─────────────────────────────────────────────────────────────

cleanup_xcode() {
  header "Xcode"
  info "DerivedData, iOS DeviceSupport, unavailable simulators"

  local dd="$HOME/Library/Developer/Xcode/DerivedData"
  local ds="$HOME/Library/Developer/Xcode/iOS DeviceSupport"

  [[ -d "$dd" ]] && echo "   DerivedData:       $(size_of "$dd")" || info "DerivedData: not found"
  [[ -d "$ds" ]] && echo "   iOS DeviceSupport: $(size_of "$ds")" || info "iOS DeviceSupport: not found"

  echo
  confirm || { info "Skipped."; return; }

  remove "$dd"
  remove "$ds"

  if $DRY_RUN; then
    warn "[dry-run] Would run: xcrun simctl delete unavailable"
  else
    if command -v xcrun &>/dev/null; then
      xcrun simctl delete unavailable 2>/dev/null && ok "Deleted unavailable simulators"
    else
      info "xcrun not available — skipping simulators"
    fi
  fi
}

cleanup_docker() {
  header "Docker / Colima"
  info "docker system prune -a, docker volume prune"

  if ! command -v docker &>/dev/null; then
    info "Docker not found — skipping."
    return
  fi

  echo
  confirm || { info "Skipped."; return; }

  if $DRY_RUN; then
    warn "[dry-run] Would run: docker system prune -a --force"
    warn "[dry-run] Would run: docker volume prune --force"
  else
    docker system prune -a --force && ok "docker system prune complete"
    docker volume prune --force    && ok "docker volume prune complete"
  fi
}

cleanup_node() {
  header "Node.js"
  info "npm cache (~/.npm)"

  local npm_cache="$HOME/.npm"
  [[ -d "$npm_cache" ]] && echo "   npm cache: $(size_of "$npm_cache")" || info "npm cache: not found"

  echo
  confirm || { info "Skipped."; return; }

  if $DRY_RUN; then
    warn "[dry-run] Would run: npm cache clean --force"
  else
    if command -v npm &>/dev/null; then
      npm cache clean --force && ok "npm cache cleared"
    else
      info "npm not available — skipping"
    fi
  fi
}

cleanup_media() {
  header "Apple Media Analysis"
  info "mediaanalysisd and photoanalysisd — macOS recreates these automatically"

  local ma="$HOME/Library/Containers/com.apple.mediaanalysisd"
  local pa="$HOME/Library/Containers/com.apple.photoanalysisd"

  [[ -d "$ma" ]] && echo "   mediaanalysisd:  $(size_of "$ma")" || info "mediaanalysisd: not found"
  [[ -d "$pa" ]] && echo "   photoanalysisd:  $(size_of "$pa")" || info "photoanalysisd: not found"

  echo
  confirm || { info "Skipped."; return; }

  kill_proc mediaanalysisd
  kill_proc photoanalysisd

  remove "$ma"
  remove "$pa"
}

cleanup_logs() {
  header "Logs"
  info "~/Library/Logs"

  local logs="$HOME/Library/Logs"
  [[ -d "$logs" ]] && echo "   ~/Library/Logs: $(size_of "$logs")" || info "Logs dir not found"

  echo
  confirm || { info "Skipped."; return; }

  remove "$logs"
}


# ─────────────────────────────────────────────────────────────
# Dispatch
# ─────────────────────────────────────────────────────────────

main() {
  echo
  echo "${BOLD}machrc — macOS cleanup${RESET}"
  $DRY_RUN      && echo "   ${YELLOW}Dry-run mode — no changes will be made.${RESET}"
  $ANALYZE_ONLY && { analyze; echo; ok "Done."; exit 0; }

  for target in "${TARGETS[@]}"; do
    case "$target" in
      all)    cleanup_xcode; cleanup_docker; cleanup_node; cleanup_media; cleanup_logs ;;
      xcode)  cleanup_xcode  ;;
      docker) cleanup_docker ;;
      node)   cleanup_node   ;;
      media)  cleanup_media  ;;
      logs)   cleanup_logs   ;;
      *)      fail "Unknown target: $target"; exit 1 ;;
    esac
  done

  echo
  ok "Done."
}

main
