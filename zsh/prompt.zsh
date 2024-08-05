# https://zsh.sourceforge.io/Intro/intro_14.html
# https://aperiodic.net/pip/prompt/

#. $MACHRC_DIR/zsh/ansi.zsh

# IMPORTANT!
setopt promptsubst

# Version control
autoload -Uz vcs_info

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

local vcs_format="%{\e[39m%}%b%{$(tput sgr0)%} %{\e[1;36m%}(%s)%{$(tput sgr0)%}"
#local nvcs_format="%{$ITALON%}nvcs%{$ITALOFF%}"
local nvcs_format=""
local action_format=$vcs_format' '$ITALON'time for some action'$ITALOFF
#zstyle ':vcs_info:*' actionformats '...|%F{1}%a%F{5}]%f '

zstyle ':vcs_info:*' actionsformats $action_format
zstyle ':vcs_info:*' formats $vcs_format
zstyle ':vcs_info:*' nvcsformats $nvcs_format

local term_width
# zsh has 1 column of padding on the right
(( term_width = $COLUMNS - 1 ))

local lpad="        "
local rpad=" "

local lpad_width=$(echo -n $lpad | wc -m)
local rpad_width=$(echo -n $rpad | wc -m)

l_prompt() {
  local mach='$(echo -ne "$ITALON$USER@$(hostname -s)$ITALOFF")'
  local dir='$(echo -ne "$ITALON${PWD/\/Users\/$USER/~}$ITALOFF")'
  local vcs='$(echo -ne ${vcs_info_msg_0_})'
  # for some reason, this places extra spacing after the right prompt unless
  #   the escapes are wrapped in `%{ %}`... not sure
  #   I think it's a prompt-only thing:
  #   - https://stackoverflow.com/questions/28799198/zsh-inserts-extra-spaces-when-performing-searches-and-completion
  #   - https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
  local p=$'%{$boldon%}>_ %{$boldoff%}'


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
  printf "%s%s%s" $vcs_msg $p $rpad
}

update_rprompt() {
  RPROMPT="$(r_prompt)"
}
add-zsh-hook precmd update_rprompt

precmd() {
  vcs_info
  print "\n"
}

PROMPT=$(l_prompt)
RPROMPT="$(r_prompt)"

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

