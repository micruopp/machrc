# aliases.zsh
# the place for general aliases, duh.

alias vi="$EDITOR"
alias ed="$EDITOR"

alias ls="ls -l"
alias la="ls -la"

alias up="cl .."
in() {
  cl $@
}
alias c="in"
