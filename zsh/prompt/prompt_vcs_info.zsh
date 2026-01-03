#!/bin/zsh

# prompt_vcs_info.zsh
# @desc Configure Z-shell's built-in version control system info for the prompt

# TODO: Possible enhancements:
# - Add upstream arrows (↑ ↓ ↕) via %p
# - Add stash count (git stash list | wc -l)
# - Make this async for large repos
# - Move this into a prompt_git.zsh module


# For dynamic prompt evaluation
# setopt PROMPT_SUBST

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Enable vcs_info for git status
# precmd_vcs_info() { vcs_info }
# precmd_functions+=( precmd_vcs_info )

# Enable git backend
zstyle ':vcs_info:*' enable git

# Detect repository states
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' check-for-staged-changes true

# Custom markers
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' untrackedstr '?'

# Branch formats
zstyle ':vcs_info:git:*' formats '%b %c%u%m'
zstyle ':vcs_info:git:*' actionformats '%b|%a %c%u%m'

# Upstream tracking
zstyle ':vcs_info:git:*' get-revision true
zstyle ':vcs_info:git:*' use-simple true
# zstyle ':vcs_info:git:*' get-dirty true # Is this a real thing?


# Configure vcs_info to show git branch and status
# zstyle ':vcs_info:git:*' formats '%b%u%c'
# zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c'
# zstyle ':vcs_info:*' check-for-changes true
# zstyle ':vcs_info:git:*' unstagedstr '*'
# zstyle ':vcs_info:git:*' stagedstr '+'
# zstyle ':vcs_info:git:*' stagedstr '●'

# ------------------------------------------------------------
# Helper: build git state indicators
# ------------------------------------------------------------

__machrc_build_git_state() {
  local state=""

  # Staged changes
  [[ -n ${vcs_info_msg_1_} ]] && state+="+"

  # Unstaged changes
  [[ -n ${vcs_info_msg_2_} ]] && state+="*"

  # Untracked files
  [[ -n ${vcs_info_msg_3_} ]] && state+="?"

  [[ -n $state ]] && echo " $state"
}

# ------------------------------------------------------------
# Helper: upstream indicators
# ------------------------------------------------------------

__machrc_build_git_upstream() {
  local ahead behind

  ahead=${vcs_info_msg_4_%% *}
  behind=${vcs_info_msg_4_#* }

  if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
    echo " ↕${ahead}/${behind}"
  elif [[ $ahead -gt 0 ]]; then
    echo " ↑${ahead}"
  elif [[ $behind -gt 0 ]]; then
    echo " ↓${behind}"
  fi
}

# ------------------------------------------------------------
# Normalize state ordering: + * ?
# ------------------------------------------------------------

__machrc_normalize_git_state() {
  local raw="$1"
  local state=""

  [[ $raw == *+* ]] && state+="+"
  [[ $raw == *** ]] && state+="*"
  [[ $raw == *\?* ]] && state+="?"

  [[ -n $state ]] && echo " $state"
}
