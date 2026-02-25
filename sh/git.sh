#!/bin/sh

# git.sh
# @desc Aliases and helpers for Git CLI

gitac() {
  echo "\"$@\""
  #git add .
  #git commit -m "$@"
}

gitcm() {
  git commit -m "$1"
}

gitlo() {
  git log --oneline
}

gitst() {
  git status
}

ggraph() {
  git log --all --decorate --oneline --graph
}

gbranch() {
  git -c color.branch=always branch -a | grep -v "remote"
}
