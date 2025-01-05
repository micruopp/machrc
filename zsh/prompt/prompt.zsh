#!/bin/zsh

# prompt.zsh
# @desc Root prompt file

# IMPORTANT!
setopt promptsubst
# Probably make a `conf_prompt.zsh` file if I get a lot more of the above

. "$MACHRC_DIR/zsh/prompt/after_prompt.zsh"
. "$MACHRC_DIR/zsh/prompt/before_prompt.zsh"
. "$MACHRC_DIR/zsh/prompt/left_prompt.zsh"
#. "$MACHRC_DIR/zsh/prompt/right_prompt.zsh"
