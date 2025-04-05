# utils.zsh

__list_processes() {
  ps aux | grep -v "grep" | grep "$1"
}
alias lp=__list_processes

# Print source time.
# TODO: Probably change this to something giving a better indication
#       of performance.
#time=$(date +"%H:%M:%S")
# echo -e "\033[3m.zshrc\033[0m sourced @ ${time}"
# 
# cal -3

# Print message with padding
__print_with_padding() {

}
