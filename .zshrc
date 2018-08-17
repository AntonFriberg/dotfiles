# Path to your oh-my-zsh installation.
export ZSH="/home/afriberg/.oh-my-zsh"

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
)

source $ZSH/oh-my-zsh.sh

# User configuration

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
alias makepkg='PKGEXT=.tar makepkg'

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh/.ssh-agent
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh/.ssh-agent)"
fi

alias axis_connect="sshuttle --dns -r lnxantonfr1 10.0.0.0/8 172.16.0.0/12"
alias battery="acpi"

# config alias to manage dotfiles in version control
function config {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
