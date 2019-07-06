#!/usr/bin/env bash

# Keybindings {{{
# The default wait time after pressing ESC is 4 deciseconds (400 milliseconds). Let's change that to 1.
export KEYTIMEOUT=1

# Emacs bindings mode is default for ZSH. Let's change that to vi.
bindkey -v

# Restore emacs functionality:
bindkey '^p' up-history
bindkey '^n' down-history
bindkey '^?' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward  # Note that Ctrl-r still works as expected in vi normal mode.

# History
bindkey "^k" history-substring-search-up
bindkey "^[k" history-substring-search-up
bindkey "^[[1;3A" history-substring-search-up
bindkey "^j" history-substring-search-down
bindkey "^[j" history-substring-search-down
bindkey "^[[1;3B" history-substring-search-down
# }}}

# Sudo {{{
# Repeat or execute a command with sudo prepended.
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
bindkey "^s" sudo-command-line
# }}}
