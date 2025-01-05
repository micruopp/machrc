# I forgot I actually like the padding on top, when my prompt is left-padded
# If there was no left-padding, I wouldn't want top-padding
# It's about symmetry

#precmd_add_padding() {
#  if [[ $ADD_PROMPT_PADDING != 0 ]]; then
#    echo ""
#  fi
#  ADD_PROMPT_PADDING=1
#}
#
#preexec_check_if_clear_command() {
#  if [[ "$1" == "clear" ]]; then
#    ADD_PROMPT_PADDING=0
#  fi
#}
#
# TODO: this should go in a separate file regardless
#autoload -Uz add-zsh-hook
#add-zsh-hook precmd precmd_add_padding
#add-zsh-hook preexec preexec_check_if_clear_command
#
#ADD_PROMPT_PADDING=0

precmd() {
  echo ""
}
