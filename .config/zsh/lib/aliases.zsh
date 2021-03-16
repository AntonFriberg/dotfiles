#!/usr/bin/env zsh

################################################################################
#  CONFIGURE ALIASES
################################################################################

# Directory navigation.
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'
# Directory management.
alias md='mkdir -p'

# Listing files and directories.
alias lsa='ls -lAh'
alias la='ls -lAh'
alias l='ls -lh'
alias ll='ls -lh'

alias less="less -R"

# Always add full time-date stamps in ISO8601 'yyyy-mm-dd hh:mm' format to the
# 'history' command.
alias history="history -i"

# Aliases exempted from spelling correction.
alias cp='nocorrect cp'
alias gist='nocorrect gist'
alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias sudo='nocorrect sudo'

### Custom aliases.
# Untar gzip.
alias untarz="tar -xvzf"
# Untar bzip2.
alias untarb="tar -xvjf"
# Untar xz.
alias untarx="tar -xvJf"
# Show all processes.
alias ps="ps aux"

### Custom oneliners.
alias update-arch="yay -Syu"
alias update-ubuntu="sudo apt update && sudo apt upgrade && sudo apt autoremove"
