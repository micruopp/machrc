# apple_arm.sh
# @desc Apple Silicon-specific scripts

# ---------------
# Third-party
# ---------------

# TODO: Homebrew sets env variables, use those instead of separate files,
#   assuming the rest of the path is the same between systems

# asdf
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
