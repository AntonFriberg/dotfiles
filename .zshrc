# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
  virtualenvwrapper
  docker
  docker-compose
  fzf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# yarn global install configuration
export PATH="$PATH:`yarn global bin`"

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
export SSH_KEY_PATH="~/.ssh/id_rsa"
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh/.ssh-agent
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh/.ssh-agent)"
fi

# Environment Variables
export BAT_THEME="Nord"

# Aliases
alias axis_connect='sshuttle --daemon --dns --pidfile=/tmp/sshuttle.pid -r lnxantonfr1 10.0.0.0/8 172.16.0.0/12 && echo "Connected."'
alias axis_disconnect='kill $(< /tmp/sshuttle.pid) && echo "Disconnected."'
alias battery="acpi"
alias du="ncdu --color dark -rr"
alias pandoc='docker run --rm -u `id -u`:`id -g` -v `pwd`:/pandoc dalibo/pandocker'


# config alias to manage dotfiles in version control
function config {
  /usr/bin/git --git-dir="${HOME}"/.dotfiles/ --work-tree="${HOME}" "${@}"
}

# Fix mullvad autocompletion from https://gitlab.com/adihrustic/Mullvad-WireGuard-Wrapper
autoload -U compinit && compinit
autoload -U bashcompinit && bashcompinit
source /usr/share/bash-completion/completions/wvpn

