. $MACHRC_DIR/zsh/ansi.zsh

ITALON="$(tput sitm)"

mac() {
  # TODO: this should open vim to $MACHRC_DIR and source any edited files
  # (how do I do that second part? vim plugin to keep track of which files I write? and then source,
  # or do the appropriate action, for each of those files? yeah, that might work...)
  # or maybe I just `exec zsh`? That's simple and resources my setup.
  # What's the downsides?
  $EDITOR $MACHRC_DIR/zsh/zshrc && source $MACHRC_DIR/zsh/zshrc
}

__pad_and_list_dir_info() {
  # list the current directory, adding a tab for padding
  command ls -l --color=always | sed 's/^/\t/'
}

change_and_list() {
  if [ $# -ne 0 ]; then
    cd $@
  fi
  clear
  # print the current directory name
  echo -e "\n\t$italon$PWD$ITALOFF\n"
  __pad_and_list_dir_info
}

cl() {
  change_and_list $@
  #clear
  #echo -e $italon$PWD$italoff
  #ls -l
}
# deprecated -- gonna remove once my muscle memory is changed to `cl`
alias cs=cl
alias ls="__pad_and_list_dir_info"
