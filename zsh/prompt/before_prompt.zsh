#!/bin/zsh

# before_prompt.zsh
# @desc Before the prompt is displayed

# ------------------------------------------------------------
# precmd hook — runs before every prompt
# ------------------------------------------------------------

# git_prompt_precmd() {
#   vcs_info

#   # Detached HEAD handling
#   if [[ -z ${vcs_info_msg_0_} && -n $(git rev-parse --short HEAD 2>/dev/null) ]]; then
#     vcs_info_msg_0_="@$(git rev-parse --short HEAD)"
#   fi

#   GIT_PROMPT_INFO=""
#   if [[ -n ${vcs_info_msg_0_} ]]; then
#     GIT_PROMPT_INFO="(${vcs_info_msg_0_}$(__machrc_build_git_state)$(__machrc_build_git_upstream))"
#   fi
# }

git_prompt_precmd() {
  vcs_info

  GIT_PROMPT_INFO=""

  if [[ -n ${vcs_info_msg_0_} ]]; then
    local branch action state

    branch=${vcs_info_msg_0_%% *}
    # action=${vcs_info_msg_0_#*$branch}
    state=$(__machrc_normalize_git_state "$vcs_info_msg_0_")

    # GIT_PROMPT_INFO="${branch}${action}${state}"
    GIT_PROMPT_INFO="(${branch}${state})"
  fi
}

add-zsh-hook precmd git_prompt_precmd

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
  # Ensure vcs_info runs before each prompt
  # vcs_info

  # Render anything to show before the prompt
  echo ""
  echo "THIS IS THE BEFORE PROMPT HOOK"
  echo ""
}
