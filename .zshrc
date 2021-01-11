# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Config paths
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_CURRENT_DESKTOP="sway"

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="bira"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  fzf
)

source $ZSH/oh-my-zsh.sh

# Fix completions
autoload -U compinit && compinit

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Turn off compression for AUR installs
alias makepkg='PKGEXT=".pkg.tar" makepkg'

# ssh
#export SSH_KEY_PATH="~/.ssh/id_rsa"
#if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent > ~/.ssh/.ssh-agent
#fi
#if [[ "$SSH_AGENT_PID" == "" ]]; then
#    eval "$(<~/.ssh/.ssh-agent)"
#fi

# Environment Variables
export BAT_THEME="Nord"

# Aliases
alias axis_connect='systemctl --user start sshuttle.service'
alias axis_disconnect='systemctl --user stop sshuttle.service'
alias axis_status='systemctl --user status sshuttle.service'
alias battery="acpi"
alias du="ncdu --color dark -rr"
alias pandoc='docker run --rm -u `id -u`:`id -g` -v `pwd`:/pandoc dalibo/pandocker'

# Fix ssh on exotic terminals see terminfo complexity for more info
function ssh {
  TERM=xterm-256color /usr/bin/ssh "${@}"
}

# config alias to manage dotfiles in version control
function config {
  /usr/bin/git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}" "${@}"
}

# fix yadm autocompletion
# https://github.com/TheLocehiliosan/yadm/tree/master/completion
fpath=(/home/afriberg/.config/yadm/_yadm $fpath)
# Fix mullvad autocompletion from https://gitlab.com/adihrustic/Mullvad-WireGuard-Wrapper
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
source /usr/share/bash-completion/completions/wvpn


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
