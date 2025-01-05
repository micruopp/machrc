#!/bin/zsh

# left_prompt.zsh
# @desc Left side of the zsh prompt

#   TODO: Refactor to a "resources" file
#   - https://stackoverflow.com/questions/28799198/zsh-inserts-extra-spaces-when-performing-searches-and-completion
#   - https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html


l_prompt() {
  # 8 spaces  (or 2 tabs)
  #local lpad="        "
  # 4 spaces  (or 1 tabs)
  local lpad="    "
  local p=$'%{$boldon%}>_  %{$resetall%}'

  local left_prompt="$lpad$p"

  print "$left_prompt"
}

PROMPT="$(l_prompt)"
