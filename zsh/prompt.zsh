# https://zsh.sourceforge.io/Intro/intro_14.html
# https://aperiodic.net/pip/prompt/

#. $MACHRC_DIR/zsh/ansi.zsh

UNI_LAMBDA="λ"

# IMPORTANT!
setopt promptsubst

autoload -Uz compinit && compinit

# Version control
autoload -Uz vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' get-revision true

# TODO: display number of added, modified, unadded, removed files
#   oh-my-zsh parses `git status --porcelain` to display file info
#   - https://stackoverflow.com/questions/9915543/git-list-of-new-modified-deleted-files
#   - https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/git.zsh

# enabled systems
zstyle ':vcs_info:*' enable git cvs svn hg fossil

vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

#vcs_format=" $UNI_LAMBDA %b%{$(tput setab 5)%}(%s) "
vcs_format=" $UNI_LAMBDA %b %u%c %{$fgyellow%}(%s)%{$resetall%} "
#vcs_format=" %b%{$(tput setab 5)%}(%s) "
#nvcs_format="%{$ITALON%}nvcs%{$ITALOFF%}"
nvcs_format=""
action_format=$vcs_format' '$ITALON'time for some action'$ITALOFF
#zstyle ':vcs_info:*' actionformats '...|%F{1}%a%F{5}]%f '

zstyle ':vcs_info:*' actionsformats $action_format
zstyle ':vcs_info:*' formats $vcs_format
zstyle ':vcs_info:*' nvcsformats $nvcs_format


prompt.git_count_changes() {
  # Get the git status output in porcelain format
  git_status=$(git status --porcelain)

  # Initialize counters
  staged=0
  unstaged=0
  untracked=0
  ignored=0

  # Parse each line of the git status output
  while IFS= read -r line; do
      # Extract the staged and unstaged status (first and second columns)
      staged_status="${line:0:1}"
      unstaged_status="${line:1:1}"

      # Count staged changes (any non-space character in the first column except '?' or '!')
      if [[ "$staged_status" != " " && "$staged_status" != "?" && "$staged_status" != "!" ]]; then
          ((staged++))
      fi

      # Count unstaged changes (any non-space character in the second column except '?' or '!')
      if [[ "$unstaged_status" != " " && "$unstaged_status" != "?" && "$unstaged_status" != "!" ]]; then
          ((unstaged++))
      fi

      # Count untracked files (lines starting with '??')
      if [[ "$line" == "?? "* ]]; then
          ((untracked++))
      fi

      # Count ignored files (lines starting with '!!')
      if [[ "$line" == "!! "* ]]; then
          ((ignored++))
      fi
  done <<< "$git_status"

  # Print the counts
  echo "S:$staged U:$unstaged ?:$untracked !:$ignored"
}


local term_width
# zsh has 1 column of padding on the right
(( term_width = $COLUMNS - 1 ))

lpad="        "
#rpad=" "
rpad=""

lpad_width=$(echo -n $lpad | wc -m)
rpad_width=$(echo -n $rpad | wc -m)

l_prompt() {
  local mach='$(echo -ne "$ITALON$USER@$(hostname -s)$ITALOFF")'
  local dir='$(echo -ne "$ITALON${PWD/\/Users\/$USER/~}$ITALOFF")'
  local vcs='$(echo -ne ${vcs_info_msg_0_})'
  # for some reason, this places extra spacing after the right prompt unless
  #   the escapes are wrapped in `%{ %}`... not sure
  #   I think it's a prompt-only thing:
  #   - https://stackoverflow.com/questions/28799198/zsh-inserts-extra-spaces-when-performing-searches-and-completion
  #   - https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
  #local p=$'%{$boldon%}>_ %{$boldoff%}'
  local p=$'%{$boldon%}>_ %{$resetall%}'
  #local p=$'>_ %{$revoff%} '


  # output
  #printf "%s%s\n" $lpad $mach
  #printf "%s%s.%s\n" $lpad $dir $vcs
  #printf "%s%s" $lpad $p
  printf "%s%s" $lpad $p
}

r_prompt() {
  vcs_info
  local now=$(date +"%H:%M:%S%z")
  local styled_date="%{$ITALON%}${now}%{$ITALOFF%}"
  local p="%{$boldon%} <<%{$boldoff%}"
  local vcs_msg=$(echo -ne $vcs_info_msg_0_)
  #printf "%s%s%s" $styled_date $p $rpad
  #printf "%s%s%s" $vcs $p $rpad
  #printf "%s%s%s" $vcs_msg $p $rpad
  #printf "%s%s%s%s%s%s" '$(__get_cwd) ' "%{$(tput rev)%}" "$vcs_msg" "%{$(tput sgr0)%}" $p $rpad
  printf "%s%s%s%s%s%s" "%{$fgblue%}$(__get_cwd)%{$resetall%}" "" "$vcs_msg" '$(prompt.git_count_changes)' $p $rpad
}

__get_cwd() {
  echo -n "${PWD##*/}"
}

update_rprompt() {
  RPROMPT="$(r_prompt)"
}
add-zsh-hook precmd update_rprompt

precmd() {
  vcs_info
  #print "\n"
  print ""
}

PROMPT=$(l_prompt)
#RPROMPT="$(r_prompt)"
RPROMPT=$(r_prompt)

preexec() {
  local now=$(date +"%H:%M:%S%z")

  #local suf=$' %{$boldon%}<<%{$boldoff%}'
  #local suf=$' %${boldon%}<<%${boldoff%}'
  local suf=" <<"
  local styled_suf=$(printf "%s%s%s" $boldon $suf $boldoff)
  #local suf_width=$(echo -n $suf | wc -m)
  local suf_width=${#suf}
  local rpad_width=$(echo -n $rpad | wc -m)

  local pad_width
  (( pad_width = ${term_width} - ${suf_width} - ${rpad_width} ))

  # output
  #printf "%s%${pad_width}s%s%s%s\n" $ITALON $now $ITALOFF $suf $rpad
  local post_prompt=$(printf "%s%${pad_width}s%s%s%s\n" $ITALON $now $ITALOFF $styled_suf $rpad)

  #echo "[DEBUG] term: ${term_width} suf: ${suf_width} rpad: ${rpad_width} pad: ${pad_width} now: ${#now}"

  local bold_on="\033[1m"
  local bold_off="\033[0m"
  
  # Print bold text before executing each command
  #echo -e "${bold_on}<<${bold_off}"
  #echo -e "$post_prompt"
  echo ""
}

