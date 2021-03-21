#!/usr/bin/env zsh

################################################################################
#  CONFIGURE PLUGINS
################################################################################

### zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

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
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
