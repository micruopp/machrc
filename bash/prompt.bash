
# Git has some official support for displaying source information in the prompt.
# The docs have notes on how to achieve results in both bash and zsh, so a cross-comptaible prompt may be possible.
# I'll need to decide along the way if I want to merge them into a single prompt to maintain; I'm not sure which
# would be easier right now.
# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-Bash
# It’s also useful to customize your prompt to show information about the current directory’s Git repository. This can be as simple or complex as you want, but there are generally a few key pieces of information that most people want, like the current branch, and the status of the working directory. To add these to your prompt, just copy the contrib/completion/git-prompt.sh file from Git’s source repository to your home directory, add something like this to your .bashrc:
# ```
# . ~/git-prompt.sh
# export GIT_PS1_SHOWDIRTYSTATE=1
# export PS1='\w$(__git_ps1 " (%s)")\$ '
# ```
# The \w means print the current working directory, the \$ prints the $ part of the prompt, and __git_ps1 " (%s)" calls the function provided by git-prompt.sh with a formatting argument. Now your bash prompt will look like this when you’re anywhere inside a Git-controlled project.
# ```
# ~/curr/dir (development *)$ _
# ```
# https://github.com/git/git/blob/master/contrib/completion/git-prompt.sh

# A more hand-rolled approach can also be taken...:
# https://gist.github.com/justintv/168835
# https://thucnc.medium.com/how-to-show-current-git-branch-with-colors-in-bash-prompt-380d05a24745
#parse_git_branch() {
#     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
#}
#export PS1="\u@\h \[\e[32m\]\w \[\e[91m\]\$(parse_git_branch)\[\e[00m\]$ "
