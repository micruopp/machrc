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

