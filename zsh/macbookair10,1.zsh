# .zshrc

# Because I always forget this stuff:
# https://zsh.sourceforge.io/Intro/intro_3.html
# `.zshenv' is sourced on all invocations of the shell, unless the -f option is set. It should contain commands to set the command search path [(i.e. your $PATH)], plus other important environment variables. `.zshenv' should not contain commands that produce output or assume the shell is attached to a tty.
# `.zshrc' is sourced in interactive shells. It should contain commands to set up aliases, functions, options, key bindings, etc.
# `.zlogin' is sourced in login shells. It should contain commands that should be executed only in login shells. [`.zlogin' is not the place for alias definitions, options, environment variable settings, etc.; as a general rule, it should not change the shell environment at all. Rather, it should be used to set the terminal type and run a series of external commands (fortune, msgs, etc).] 
# `.zlogout' is sourced when login shells exit. 
# `.zprofile' is similar to `.zlogin', except that it is sourced before `.zshrc'. `.zprofile' is meant as an alternative to `.zlogin' for ksh fans; the two are not intended to be used together, although this could certainly be done if desired.

export EDITOR=nvim
export MACHRC_DIR=/Users/$USER/Developer/machrc

# IMPORTANT!
# any difference between these?
setopt promptsubst
setopt prompt_subst


# Version control
# get version control info
# https://stackoverflow.com/questions/1128496/to-get-a-prompt-which-indicates-git-branch-in-zsh
# TODO: Simplify and customize this copypasta
# TODO: Also, understand it
autoload -Uz vcs_info

# oh-my-zsh parses `git status --porcelain` to display file info
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/git.zsh
# https://stackoverflow.com/questions/9915543/git-list-of-new-modified-deleted-files
# TIL about the `porcelain` flag

local vcs_format='%F{5}%f%s%F{5}%F{3}:%F{5}%F{2}%b%F{5}%f'
local action_format=' \e[3mtime for some action\e[23m'
local nvcs_format='\e[3mnvcs\e[23m'

#zstyle ':vcs_info:*' actionformats \
#    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' actionsformats $vcs_format$action_format
zstyle ':vcs_info:*' formats $vcs_format
zstyle ':vcs_info:*' nvcsformats $nvcs_format

# enabled systems
zstyle ':vcs_info:*' enable git cvs svn hg fossil

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}

# Prompt

local term_width
# zsh has 1 column of padding on the right
(( term_width = $COLUMNS - 1 ))

local lpad="        "
local rpad=" "

local lpad_width=$(echo -n $lpad | wc -m)
local rpad_width=$(echo -n $pad | wc -m)

l_prompt() {
  # the quotes continue to confuse me...
  # https://unix.stackexchange.com/questions/40595/reevaluate-the-prompt-expression-each-time-a-prompt-is-displayed-in-zsh
  local dir='$(echo -ne "\e[3m${PWD/\/Users\/$USER/~}\e[23m")'
  local dir2='$(echo -n ${PWD/\/Users\/$USER/\~} | wc -m)'
  local dir1='${PWD/\/Users\/$USER/\~}'
  #local dir_width='$(($(echo ${PWD/\/Users\/$USER/\~} | wc -m)))'
  local dir_width=20
  #local dir_width=$(echo -n ${dir} | wc -m) # not working
  
  echo $dir2
  printf "%s\n" $dir2

  echo -e '\e[3mitalic\e[23m'
  local mach='$(echo -ne "\e[3m$USER@$(hostname -s)$rpad\e[23m")'
  
  #local vcs=$(echo ${$(vcs_info_wrapper):-})
  local vcs='$(echo ${vcs_info_msg_0_})'

  printf "[DEBUG] term_width: %s\n" ${term_width}
  printf "[DEBUG] dir_width: %s\n" ${dir_width}
  printf "\n"

  # output
  printf "%s%s\n" $lpad $mach
  printf "%s%s.%s\n" $lpad $dir $vcs
  printf "%s%s" $lpad $'%B>_%b '
}

r_prompt() {
  printf "<<%s" $rpad
}

precmd() {
  vcs_info

  print "\n"
  #print "PRECMD"
}

RPROMPT=$(r_prompt)
PROMPT=$(l_prompt)

preexec() {
  local term_width
  # zsh has 1 column of padding on the right
  (( term_width = $COLUMNS - 1 ))

  local now=$(date +"%H:%M:%S%z")
  local rhs="$now"

  local suf=" <<"
  local suf_width=$(echo -n $suf | wc -m)
  local rpad_width=$(echo -n $rpad | wc -m)

  local pad_width
  (( pad_width = ${term_width} - ${suf_width} - ${rpad_width} ))

  #print "[DEBUG] lhs_width: %s pad_width: %s rhs_width: %s" $lhs_width $pad_width $rhs_width

  # output
  printf "%${pad_width}s%s%s\n" $rhs $suf $rpad
}


mac() {
  $EDITOR $MACHRC_DIR/zsh/zshrc && source $MACHRC_DIR/zsh/zshrc
}
