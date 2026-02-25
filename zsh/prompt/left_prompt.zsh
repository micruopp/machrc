#!/bin/zsh

# left_prompt.zsh
# @desc Left side of the prompt

#   TODO: Refactor to a "resources" file
#   - https://stackoverflow.com/questions/28799198/zsh-inserts-extra-spaces-when-performing-searches-and-completion
#   - https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html


__machrc_left_prompt() {
  # 8 spaces padding
  local left_padding="        "

  # Get current directory relative to home
  local relative_location='%~'

  local the_prompt=">_"

  # Get git status using vcs_info
  # local git_status=''
  # if [[ -n $vcs_info_msg_0_ ]]; then
  #   gitstatus=" $vcs_info_msg_0_"
  # fi

  # Prompt line with directory and git status
  # local info_line="${left_padding}%F{blue}${relative_location}%f (${vcs_info_msg_0_})"
  local info_line="${left_padding}%F{blue}${relative_location}%f ${GIT_PROMPT_INFO}"

  # Input prompt (on the next line)
  local input_prompt="${left_padding}"$'%{$boldon%}%{$the_prompt%}%{$resetall%} '

  # Combine with newline between them
  local left_prompt="${info_line}"$'\n'"${input_prompt}"

  print -P "$left_prompt"
}

PROMPT='$(__machrc_left_prompt)'


# Prompt definition
# PROMPT='%F{blue}%~%f (${vcs_info_msg_0_})
# %F{green}>_ %f'
