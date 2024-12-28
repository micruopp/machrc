# apparatus.zsh
#
# the stuff I need to do the stuff I do

ITALON="$(tput sitm)"

# Function to efficiently edit and source machine run commands.
mac() {
  case "$1" in
    help)
      echo "There's no help for you here."
      ;;
    load)
      __load_machrc
      ;;
    reload)
      __load_machrc
      ;;
    *)
      #echo "Aim your shot, buddy"
      # TODO: search for file within $MACHRC_DIR, open first match if exists

      echo -e "$italon""Looking for $1""$italoff"
      #find $MACHRC_DIR -name "$1"
      #__edit_and_src_machrc
      ;;
  esac
}


__load_machrc() {
  source ~/.zshrc
}

__edit_and_src_machrc() {
  # TODO: this should open vim to $MACHRC_DIR and source any edited files
  # (how do I do that second part? vim plugin to keep track of which files I write? and then source,
  # or do the appropriate action, for each of those files? yeah, that might work...)
  # or maybe I just `exec zsh`? That's simple and resources my setup.
  # What's the downsides?
  local TARGET_FILE="/zsh/zshrc"
  # 1. Get target file query from input
  #   a. Probably sanitize it, jic
  # 2. Search $MACHRC_DIR for query
  #   a. If multiple matches are found, display a modal to select.
  #   b. Maintain a mapping of queries to hits, like a jumplist.
  # 3. Open file for editing.
  # 4. Based on filetype, perform necessary sourcing upon exiting.
  #   a. NOTE: I'd like these to be a separate module, so I can call them
  #         independently. I'm imagining using a split window, leaving the
  #         editor open, and reloading the files in the terminal pane.
  #         Perhaps it can know what is the currently open file, as well, so
  #         I can have a convenience command like, `mac reload`
  #         I can probably maintain a list of edited files, and `reload` can 
  #         iterate through this reloading each, then flush the file.

  local TARGET="$MACHRC_DIR$TARGET_FILE"
  echo "$TARGET"
  $EDITOR "$TARGET" && source "$TARGET"
  # Upon exiting, I want to clear the screen and print what files I sourced
  #   and reloaded.
}

__pad_and_list_dir_info() {
  # list the current directory, adding a tab for padding
  #command ls -l --color=always | sed 's/^/\t/'
  command ls --color=always $@ | sed 's/^/\t/'
}

change_and_list() {
  clear
  if [[ $# -ne 0 ]]; then
    if [[ "$1" = "-" ]]; then
      cd - &> /dev/null
    elif [[ -d $@ ]]; then
      cd $@
      #echo -e "\n\t$italon$PWD$ITALOFF\n"
      #__pad_and_list_dir_info
    else
      echo "\n"
      echo -e "\t$italon""Directory $italoff$boldon$@$boldoff$italon not found."
      #echo -e "Still in $italoff$boldon$PWD$boldoff$resetall"
    fi
    #echo -e "\n\t$italon$PWD$ITALOFF\n"
    #__pad_and_list_dir_info
    #echo -e "\n\t$PWD"
    echo ""
    --List-as-tree
  fi
}

# TODO: Remove changing dirs, but enable `l` to take args
__list() {
  clear
  if [[ $# -ne 0 ]]; then
    if [[ "$1" = "-" ]]; then
      cd - &> /dev/null
    elif [[ -d $@ ]]; then
      cd $@
      #echo -e "\n\t$italon$PWD$ITALOFF\n"
      #__pad_and_list_dir_info
    else
      echo "\n"
      echo -e "\t$italon""Directory $italoff$boldon$@$boldoff$italon not found."
      #echo -e "Still in $italoff$boldon$PWD$boldoff$resetall"
    fi
    #echo -e "\n\t$italon$PWD$ITALOFF\n"
    #__pad_and_list_dir_info
    #echo -e "\n\t$PWD"
    echo ""
    --List-as-tree
  fi
}

--List-as-tree() {
  #tree -C -L 1 | sed "s/^\.$/$(echo "\n\t$PWD" | sed 's/[\/&]/\\&/g')/"
  #echo "\n\t$PWD"
  #tree -C -L 1 | sed "s/(\x1B\[[0-9;]*m)\./\1$(echo "$PWD" | sed 's/[\/&]/\\&/g')/" | sed "s/^/\t/"
  # FIXME: given the input "l ..", the first line incorrectly renders the listed directory
  #   - the Present Working Directory is rendered instead, with a trailing "."
  #   - part of the solution should be to remove the usage of $PWD and replace it with the given argument
  #   - --List-as-tree should likely expect a directory name, rather than blindly using all args
  tree -C -L 1 $@ | sed "s/\(\x1B\[[0-9;]*m\)\./\1$(echo "$PWD" | sed 's/[\/&]/\\&/g')/" | sed "s/^/\t/"
}

#cl() {
  #change_and_list $@
  #clear
  #echo -e $italon$PWD$italoff
  #ls -l
#}

alias cl=change_and_list
alias cs=cl
alias c=change_and_list
alias l="--List-as-tree"
alias ls="__pad_and_list_dir_info"

# TODO: if entirety of command is ".", run "c ."
# TODO: if entirety of command is "..", run "c .."
