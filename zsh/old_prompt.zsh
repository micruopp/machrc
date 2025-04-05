# prompt.sh
# prompt configuration

setopt promptsubst


# TODO: move to different file
# simple padding solution:
# https://unix.stackexchange.com/questions/145258/add-leading-characters-in-front-of-string-using-printf-or-echo
# while [ ${#line} -lt 20 ]; do
#line=0$line
#done
#
#or
#
#n=${#line}
#while [ $n -lt 20 ]; do
#  printf '0'
#  n=$((n-1))
#done
#printf "$line\n"


# Z-Shell order of execution:
# TODO: find this from old zshrc file
#   it's somewhere...
#   (is the source from the docs, or a stackoverflow?)
# https://zsh.sourceforge.io/Intro/intro_14.html

# Maybe shorten the PWD to just the directory name,
# or move it to the first line with machine, and dedicate the 
# second to source control, giving a fallback message if nothing is found:
# _No source control detected._
# Left prompt
# ```
#
#     $USER@$HOSTNAME
#     $PWD_relative_to_home.vcs_name:vcs_branch +vcs_file_adds , -vcs_file+dels (untracked?)
#     > 
# ```
#
# Right prompt
# ```
#
# ... machine_info
# ... 
# ... last_command_info (command, time to execute, exit status?)
# ```
# Preexec() 
# ```
#
#
# get version control info
# https://stackoverflow.com/questions/1128496/to-get-a-prompt-which-indicates-git-branch-in-zsh
# TODO: Simplify and customize this copypasta
# TODO: Also, understand it
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
# TODO: What is this 'zstyle'?!
zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

r_prompt() {
  echo "$USER@$HOSTNAME"
  date +"%H:%M:%S" 
  vcs_info_wrapper
}

_h_padding() {
  printf "\t"
}
_v_padding() {
  print ""
  print ""
}
# https://aperiodic.net/phil/prompt/
# https://superuser.com/questions/807573/how-to-find-length-of-string-in-shell
# https://stackoverflow.com/questions/4409399/padding-characters-in-printf
_justify() {
  # TODO: add equal spacing between args
  # 1. get $COLUMNS
  # 1. get size of each input
  # 1. determine pad_size
  #   pad_size = ($COLUMNS - sum(input_size)) / inputs_length
  # 1. build return string with pad_size of pad_char between inputs
  #padlimit=60
  #pad=$(printf '%*s' "$padlimit")
  #pad=${pad// /-}
  #string2='bbbbbbb'
  #for string1 in a aa aaaa aaaaaaaa
  #do
  #     printf '%s' "$string1"
  #     printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2} )) "$pad"
  #     printf '%s\n' "$string2"
  #     string2=${string2:1}
  #done
  local term_width=(($COLUMNS - 1))
  for arg in $@
  do
    #printf "$arg"
    
  done
  line="The final line"
  print $term_width
}
# _c_align() {
# }
# _l_align
# _r_align() {}

# ZSH Key:
#   - %n -> $USERNAME
#   - %m -> $HOSTNAME
#   - %~ -> $PWD, relative to the home directory
#   - %F{0-255}%f -> font color
#   - %B%b -> bold
#
# Simplify the prompt
#   "$(tput blink)" to blink; "$(tput sgr0)" to default
#PROMPT=$'\n    %F{69}%n@%B%m\n    %~\n    >%b%f%F{159} '
#PROMPT=$' $(date +"%H:%M:%S")\$ '

# TODO: Rework left prompt into a function; see above example.
#_lprompt='\n    %F{69}%n@%B%m\n    %~\n    >%b%f%F{159} '

#RPROMPT=$'$(r_prompt)'
r_prompt() {
  printf "<<<"
}

l_prompt() {
  _v_padding
  #_h_padding

  local term_width
  (( term_width = $COLUMNS - 1 ))

  #local lhs=${(%B%n@%m%b)}
  #local lhs=${#${(%):-(%n@%m)}}
  #local lhs="        user@host"
  # echo $TIMEFMT =>
  # %J  %U user %S system %P cpu %*E total
  local lhs="        $USER@$(hostname -s)"
  # doesn't work -- static time
  #local rhs=$(echo $(date))
  # works? -- dyanmic time
  #local now=$'$(date)'
  # it works?! for both?!?!
  # nope. it's a static time...
  #local now=$(`date`)
  local now=$'$(date)'
  local date_width=28

  local lhs_length=$(echo -n $lhs | wc -m)
  # this returns the correct length -- executing the command first
  # can't figure how to get this to work with a variable
  #local rhs_length=$(( ${#$(date)} ))
  local rhs_length=$(echo -n $now | wc -m )

  local pad_width
  #(( pad_width = ${COLUMNS} - ${lhs_length} - ${rhs_length} - 2 ))
  # minus 2 because Z-shell
  # - 1 because ($COLUMNS - 1) is the max width of a line without wrapping
  # - 1 because there's a column of padding on the right side
  # - (now it's just - 1? idk, I'm losing my mind a little...)
  #   (it's -2 usually, -1 if I'm doing some formatting stuff I guess)
  (( pad_width = ${COLUMNS} - ${lhs_length} - ${date_width} + 5 ))
  #local pad=$(printf "%${pad_width}s" "")
  echo $pad_width
  #echo $pad

  #now=$(_justify "$(date)" " and a string")
  #_h_padding
  #printf "%s%s%s\n" $lhs_length $pad_width $rhs_length
  printf "%s%${pad_width}s\n" $lhs $now
  #_h_padding
  printf "%s\n" $'$(_h_padding)%~'
  _h_padding
  printf "%s" $'%B>_%b '
  # TODO: only show if `%m` != $HOSTNAME, i.e. if it's another machine
  #   if $CURR_HOSTNAME != $HOSTNAME
  #   printf "$USER@$HOSTNAME"
}

#PROMPT=$'\n\n\t%n@%B%m%b:%~\n\t%B>%b '

# NOTE: any output from precmd is cleared from the window after a `clear` command
precmd() {
  # print pre-prompt
  #_v_padding
}

RPROMPT=$(r_prompt)
PROMPT=$(l_prompt)

preexec() {
  _v_padding
  # leaving an unclosed style tag permeates the effect 
  #   until another style is set
  # echo -n "\\e[0;37m"
}
