#!/usr/bin/env zsh
#
# Key bindings for ZSH
# Alt+Up/j: Backward history search
# Alt+Down/k: Forward history search
# Ctrl+s: Execute current command (or previous one if line editor is empty) with sudo.


# Vi Mode {{{
# Emacs bindings mode is default for ZSH. Let's change that to vi.
bindkey -v

# The default wait time after pressing ESC is 4 deciseconds (400 milliseconds). Let's change that to 1.
export KEYTIMEOUT=1

# Every time the line editor reads a new line of input (zle-line-input), as well as every time the keymap variable
# $KEYMAP changes during line editing, apply this function to redraw the prompt to tell us what vi mode we are in.
# See http://dougblack.io/words/zsh-vi-mode.html.
zle-line-init zle-keymap-select() {
    # Displays [NORMAL] in yellow.
    VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
    # Set the right prompt to either '[NORMAL]' or '' plus $EPS1.
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
    # Redraw the current prompt.
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select
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

# Based on what has already been entered at the prompt, do a history search when pressing Alt+Up/Down
bindkey "^[[1;3A" history-beginning-search-backward
bindkey "^[[1;3B" history-beginning-search-forward
# Use Alt+j/k for vim-style history search
bindkey "^[k" history-beginning-search-backward
bindkey "^[j" history-beginning-search-forward
