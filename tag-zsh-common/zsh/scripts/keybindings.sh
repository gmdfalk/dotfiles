#!/usr/bin/env bash
#
# Key bindings for ZSH
# Alt+Up/j: Backward history search
# Alt+Down/k: Forward history search
# Esc-Esc: Toggle insert sudo before command.

# {{{ Sudo
# From https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/sudo/sudo.plugin.zsh
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
# Defined shortcut keys: [Esc] [Esc]
bindkey "\e\e" sudo-command-line
# }}}

# Based on what has already been entered at the prompt, do a history search when pressing Alt+Up/Down
bindkey "^[[1;3A" history-beginning-search-backward
bindkey "^[[1;3B" history-beginning-search-forward
# Use Alt+j/k for vim-style history search
bindkey "^[k" history-beginning-search-backward
bindkey "^[j" history-beginning-search-forward
