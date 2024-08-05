# tput
ITALON=$(tput sitm)
ITALOFF=$(tput ritm)

# ANSI escapes
# https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797
# (is tput more portable?
#   check `man terminfo`
#   https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html)
boldon=$'\e[1m'
boldoff=$'\e[22m'
italon=$'\e[3m'
italoff=$'\e[23m'
blinkon=$'\e[5m'
blinkoff=$'\e[25m'
revon=$'\e[7m'
revoff=$'\e[27m'
hiddenon=$'\e[8m'
hiddenoff=$'\e[28m'
strikeon=$'\e[9m'
strikeoff=$'\e[29m'

fgblack=$'\e[30m'
fgred=$'\e[31m'
fggreen=$'\e[32m'
fgyellow=$'\e[33m'
fgblue=$'\e[34m'
fgmagenta=$'\e[35m'
fgcyan=$'\e[36m'
fgwhite=$'\e[37m'
fgdefault=$'\e[39m'
bgblack=$'\e[40m'
bgred=$'\e[41m'
bggreen=$'\e[42m'
bgyellow=$'\e[43m'
bgblue=$'\e[44m'
bgmagenta=$'\e[45m'
bgcyan=$'\e[46m'
bgwhite=$'\e[47m'
bgdefault=$'\e[49m'

resetall=$'\e[0m'
