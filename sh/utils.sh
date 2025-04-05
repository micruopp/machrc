# utils.sh

statusOf() {
  $@
  echo -e "\n$1 exited with status of $?"
}





# os.sh
# scripts for os stuff

# os detection
# https://stackoverflow.com/questions/394230/how-to-detect-the-os-from-a-bash-script
# https://github.com/dylanaraps/neofetch/issues/433

is_macos() {
  # darwin
}

is_linux() {
  # linux-gnu
}

is_bsd() {
  # freebsd
}

is_windows() {
  # cygwin
  # msys
  # win32?
}

is_android() {
  # android
}
