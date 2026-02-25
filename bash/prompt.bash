# Linux (WSL) path
#source /etc/bash_completion.d/git-prompt
# macOS (silicon) path
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWUPSTREAM="auto"

PS1="\[\033[01;34m\]\w \[\033[0m\]"'$(__git_ps1 "(%s)")'"\n\[\033[01;32m\]>_ \[\033[00m\]"
PS0="\n"

prompt_add_blank_line() {
  if [[ $ADD_BLANK_LINE = 1 ]]; then
    echo ""
  fi
  ADD_BLANK_LINE=1
}

check_if_cmd_is_clear() {
  if [[ "$BASH_COMMAND" == "clear" ]]; then
    ADD_BLANK_LINE=0
  fi
}

trap 'check_if_cmd_is_clear' DEBUG
PROMPT_COMMAND='prompt_add_blank_line'

ADD_BLANK_LINE=0
