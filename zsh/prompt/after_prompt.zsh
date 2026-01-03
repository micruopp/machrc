#!/bin/zsh

# after_prompt.zsh
# @desc After the prompt, before the output of the execution

preexec() {
  # Render anything to show after the prompt
  echo ""
  echo "THIS IS THE AFTER PROMPT HOOK"
  echo ""
}
