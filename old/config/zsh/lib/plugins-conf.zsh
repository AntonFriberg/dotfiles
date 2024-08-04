#!/usr/bin/env zsh

################################################################################
#  CONFIGURE PLUGINS
################################################################################

### zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"
# Faster tab completions
zstyle ':completion:' accept-exact '(N)'
zstyle ':completion:' use-cache yes
zstyle ':completion::complete:' cache-path '${ZDOTDIR:-$HOME}'

### zsh-history-substring-search
# Configure zsh-history-substring-search plugin. See key binding configuration
# also.
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

### alias-tips
export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
#export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="_ ll vi"

################
# SETUP PROMPT #
################

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ${ZDOTDIR:-$HOME}/.p10k.zsh ]] || source ${ZDOTDIR:-$HOME}/.p10k.zsh
