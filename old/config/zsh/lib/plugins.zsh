#!/usr/bin/env zsh


################################################################################
#  SETUP PLUGINS
################################################################################

###################
# CONFIGURE ZINIT #
###################

# Zinit Commands
#
# load:
#   Load plugin...
# light:
#   Load plugin in light mode, without reporting/tracking. See output from
#   'zinit report' command. When a plugin is light loaded, reporting of func-
#   tions, variables etc. is not available. For more information, see
#     - https://github.com/zdharma/zinit#example-usage
#     - https://github.com/zdharma/zinit#loading-and-unloading.
#   Note that unloading a plugin requires the plugin to be loaded with tracking
#   (zinit load). Tracking causes slight slowdown, this does however not influ-
#   ence Zsh startup time when using Turbo mode. See 'wait' ice modifier.
# snippet:
#   Source local or remote file (by direct URL).

# Zinit Ice Modifiers
#
# Zinit uses 'ice' modfiers as a term for adding something next to the 'zinit'
# command and that is temporary. Hence the modification will only last for a
# single zinnit command.
#
# Conditional Loading: https://github.com/zdharma/zinit#conditional-loading
# wait:
#   Ice modifier that postpones loading of a plugin, known in Zinit as Turbo
#   mode. When 'wait' is specified without value, it is equal to using wait'0'.
#   When using exclamation mark (wait'!...'), Zinit will reset the prompt after
#   loading plugin. This is needed by many themes.
#
# Plugin Output: https://github.com/zdharma/zinit#plugin-output
# lucid:
#   Skip "Loaded ..." message under prompt for 'wait' ice modifier.
#
# Completions: https://github.com/zdharma/zinit#completions
# blockf:
#   Blocks the traditional method of adding completions. Zinit uses own method
#   (based on symlinks instead of adding a number of directories to $fpath).
#   Zinit will automatically install completions of a newly downloaded plugins.
#
# Command Execution After Cloning, Updating or Loading:
# https://github.com/zdharma/zinit#command-execution-after-cloning-updating-or-loading
# atinit:
#   Run command after directory setup (cloning, checking, etc.) of plugin or
#   snippet but before loading.
# atload:
#   Run command after loading and from within the plugin's directory. Can also
#   be used with snippets. Passed code can be preceded with '!'', it will then
#   be investigated (if using 'load', not 'light').
#
# Others: https://github.com/zdharma/zinit#others
# light-mode:
#   Load plugin in 'light' mode when using 'for' syntax.

# Zinit Packages.
#
# Zinit supports special, dedicated packages that offload the user from pro-
# viding long and complex commands. For more information, see
#   - http://zdharma.org/zinit/wiki/Zinit-Packages/
#   - https://github.com/Zsh-Packages

# Install Zinit if missing.
if [[ ! -f ${XDG_CONFIG_HOME}/zsh/zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "${XDG_CONFIG_HOME}/zsh/zinit" && command chmod g-rwX "${XDG_CONFIG_HOME}/zsh/zinit"
    command git clone https://github.com/zdharma/zinit "${XDG_CONFIG_HOME}/zsh/zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
    zcompile ${XDG_CONFIG_HOME}/zsh/zinit/bin/zinit.zsh
fi

# Load Zinit.
source "${XDG_CONFIG_HOME}/zsh/zinit/bin/zinit.zsh"
ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo.
# (this is currently required for annexes)
# This was recommended by Zinit's installer.
zinit light-mode for \
    zdharma-continuum/z-a-rust \
    zdharma-continuum/z-a-as-monitor \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-bin-gem-node


# Theme the prompt with Powerlevel10k.
# Followed snippet on http://zdharma.org/zinit/wiki/GALLERY/#themes
zinit ice depth=1 atload'source ${ZDOTDIR}/.p10k.zsh; _p9k_precmd' lucid nocd
zinit light romkatv/powerlevel10k

# Load essential plugins.
#
# zsh-history-substring-search:
#   FishShell-like history search feature.
# zsh-autosuggestions:
#   FishShell-like fast and unobtrusive autosuggestions.
# fast-syntax-highlighting:
#   FishShell-like syntax highlighting (fast implementation).
# zsh-completions:
#   Additional completion definitions.
#
# Notes:
#   Plugins are loaded using the 'for' syntax with the use of Turbo mode
#   according to https://github.com/zdharma/fast-syntax-highlighting#zinit.
#
#   The zsh-history-substring-search plugin must be loaded before
#   zsh-autosuggestions plugin to avoid "unhandled ZLE widget" error.
#
#   The fast-syntax-highlighting plugin expects to be loaded last, even after
#   the completion initialization, i.e. 'compinit' function. In practice it
#   just have to be ensured that such plugins are loaded after plugins that are
#   issuing 'compdef', which basically mean completions that are not using the
#   underscore-starting function file. The completion initialization still has
#   to be performed before fast-syntax-highlighting plugin, hence the use of
#   'atinit' ice modifier, which will load 'compinit' right before loading the
#   plugin. 'zicompinit' is a built-in Zinit function that runs 'autoload
#   compinit; compinit'. 'zicdreplay' is another built-in Zinit function that
#   will replay any caught compdefs.
#

zinit wait lucid for \
    zsh-users/zsh-history-substring-search \
    atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
        zdharma/fast-syntax-highlighting \
    blockf \
        zsh-users/zsh-completions \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions

# Load additional plugins.
#
# alias-tips:
#   Help remembering shell aliases.
# fzf-tab:
#   Replace Zsh default completion selection menu with fzf.
# up:
#   Use 'up' to navigate directories.
#
zinit wait lucid for \
    djui/alias-tips \
    Aloxaf/fzf-tab \
    peterhurford/up.zsh


# Load snippets from Oh My Zsh.
#
# colored-man-pages:
#   Adds colors to man pages.
# dirhistory:
#   Adds keyboard shortcuts for navigating directory history and hierarchy.
# docker-compose:
#   Adds aliases for frequent docker-compose commands.
# git:
#   Adds many aliases for Git commands.
# thefuck:
#   Corrects previous console command by pressing 'Esc' twice.
#
zinit wait lucid for \
    OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh \
    OMZ::plugins/dirhistory/dirhistory.plugin.zsh \
    OMZ::plugins/docker-compose/docker-compose.plugin.zsh \
    OMZ::plugins/git/git.plugin.zsh \
    OMZ::plugins/thefuck/thefuck.plugin.zsh

# Load additional completions from Oh My Zsh.
#
# Note:
#   Completions from Oh My Zsh are loaded using the 'for' syntax with the use
#   of Turbo mode. The use of as"completion" ice modifier specifies that Zinit
#   should only load snippets starting with underscore (completion file).
#
zinit wait lucid for \
    as"completion" \
        OMZ::plugins/docker/_docker \
        OMZ::plugins/docker-compose/_docker-compose


# Install Zinit packages.
#
# fzf:
#   https://github.com/Zsh-Packages/fzf
#
zinit pack"bgn-binary+keys" for fzf
zinit ice as"program" cp"httpstat.sh -> httpstat" pick"httpstat"
zinit light b4b4r07/httpstat
