#!/bin/zsh

# prompt_vcs_info.zsh
# @desc Configure Z-shell's built-in version control system info for the prompt
#
# Git / VCS Status Symbols:
#   ✚  (U+271A) added files
#   ●  (U+25CF) modified files
#   ✖  (U+2716) deleted files
#   ✔  (U+2714) clean working tree -- TODO: Clean should be lack of an indicator
#   …  (U+2026) untracked files
#   ⎇  (U+2387) branch indicator
#   @  (U+0040) detached HEAD -- is this really the unicode for "@"?
#   ⇡  (U+21E1) ahead of upstream
#   ⇣  (U+21E3) behind upstream
#   ⇕  (U+21D5) diverged from upstream
#
# Example output: ⎇ main ● ⇡2/⇣1
#
# TODO: Possible enhancements:
# - Add stash count (git stash list | wc -l)
# - Make this async for large repos

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Enable git backend
zstyle ':vcs_info:*' enable git

# Detect repository states
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' check-for-staged-changes true

# Custom markers (used by the hook below)
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' unstagedstr '*'

# Branch formats
# %b = branch name
# %m = misc (our custom detailed status from hook)
zstyle ':vcs_info:git:*' formats '%b %m'
zstyle ':vcs_info:git:*' actionformats '%b|%a %m'

# Upstream tracking
zstyle ':vcs_info:git:*' get-revision true
zstyle ':vcs_info:git:*' use-simple false

# Hook to detect detailed git status
+vi-git-status() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
    return
  fi

  # Store detailed status in user_data for later retrieval
  local -a status_lines
  status_lines=(${(f)"$(git status --porcelain 2>/dev/null)"})

  local added=0 modified=0 deleted=0 untracked=0

  for line in $status_lines; do
    case "${line:0:2}" in
      '??') ((untracked++)) ;;
      'A '|'AM') ((added++)) ;;
      ' M'|'MM'|'M ') ((modified++)) ;;
      ' D'|'D '|'DM') ((deleted++)) ;;
      *) ;;
    esac
  done

  # Build status string
  local git_status=''
  (( added > 0 )) && git_status+='+'
  (( modified > 0 )) && git_status+='*'
  (( deleted > 0 )) && git_status+='x'
  (( untracked > 0 )) && git_status+='?'

  # Wrap in bold if not empty
  [[ -n "$git_status" ]] && git_status="%B${git_status}%b"

  # If nothing, leave empty
  # Store in misc for %m expansion
  hook_com[misc]="$git_status"
}

zstyle ':vcs_info:git*+set-message:*' hooks git-status
