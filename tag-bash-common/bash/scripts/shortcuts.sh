#!/usr/bin/env bash

# Shortcuts
alias b=popd
alias c=cat
alias cl=clear
alias h=history
alias f=find
alias k=kill
alias m="${VIDEO}"
alias n="note $HOME/.note"
alias nn="note $HOME/.notemed"
alias p=pacman
alias s='sudo '
alias v="${VISUAL}"
alias x=exit
alias y=yaourt

# Fasd uses these by default:
if have fasd;then
    # alias a="fasd -a"        # any
    # alias s="fasd -si"       # show / search / select
    # alias d="fasd -d"        # directory
    # alias f="fasd -f"        # file
    # alias sd="fasd -sid"     # interactive directory selection
    # alias sf="fasd -sif"     # interactive file selection
    # alias z="fasd_cd -d"     # cd, same functionality as j in autojump
    # alias zz="fasd_cd -d -i" # cd with interactive selection
    alias v="f -e ${VISUAL}" # quick opening files with vim
    alias m="f -e ${VIDEO}" # quick opening files with mplayer
    alias o="a -e ${_OPEN}" # quick opening files with xdg-open
fi