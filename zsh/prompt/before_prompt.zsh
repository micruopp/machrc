#!/bin/zsh

# before_prompt.zsh
# @desc Before the prompt is displayed

# Enhanced git prompt with detailed status and upstream tracking
git_prompt_precmd() {
  # Clear any prior values to avoid stale prompt artifacts
  vcs_info_msg_0_=''

  vcs_info

  # Build the final, wrapped git segment
  GIT_PROMPT_INFO=''

  # Check if we're in a git repository
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    return
  fi

  # Check for detached HEAD state
  local branch=''
  local detached=false

  if ! git symbolic-ref -q HEAD &>/dev/null; then
    # We're in detached HEAD state
    detached=true
    branch="$(git rev-parse --short HEAD 2>/dev/null)"
  elif [[ -n ${vcs_info_msg_0_} ]]; then
    # Normal branch - extract from vcs_info
    local full="${vcs_info_msg_0_}"
    branch="${full%% *}"  # Everything before first space
  else
    return
  fi

  # Extract git status
  local git_status=''
  if [[ -n ${vcs_info_msg_0_} ]]; then
    # Normal branch - extract from vcs_info
    local full="${vcs_info_msg_0_}"
    git_status="${full#* }"    # Everything after first space
    # If there's no space, branch and status are the same (no status)
    [[ "$branch" == "$git_status" ]] && git_status=''
  elif $detached; then
    # Detached HEAD - manually get status since vcs_info may not populate it
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
    (( added > 0 )) && git_status+='+'
    (( modified > 0 )) && git_status+='*'
    (( deleted > 0 )) && git_status+='x'
    (( untracked > 0 )) && git_status+='?'
  fi

  # Get upstream tracking info
  local upstream=''
  if git rev-parse --abbrev-ref @{upstream} &>/dev/null; then
    local ahead behind
    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)

    if [[ $ahead -gt 0 && $behind -gt 0 ]]; then
      upstream=" ⇣${behind}/⇡${ahead}"
    elif [[ $ahead -gt 0 ]]; then
      upstream=" ⇡${ahead}"
    elif [[ $behind -gt 0 ]]; then
      upstream=" ⇣${behind}"
    fi
  fi

  # Build final prompt - add ⎇ symbol only for branches, not detached HEAD
  if $detached; then
    GIT_PROMPT_INFO="@${branch}"
  else
    GIT_PROMPT_INFO="⎇ ${branch}"
  fi
  [[ -n $git_status ]] && GIT_PROMPT_INFO+=" $git_status"
  GIT_PROMPT_INFO+="${upstream}"
}

add-zsh-hook precmd git_prompt_precmd

# Add vertical spacing before prompt
precmd() {
  echo ""
}
