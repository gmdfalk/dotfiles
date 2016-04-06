#!/usr/bin/env bash

# Directories
alias md="mkdir -p"
alias rd="rmdir"
alias d="dirs -v | head -10"

# Push and pop directories on directory stack
alias pu="pushd"
alias po="popd"

# Move through directory stack.
alias -- -="cd -"
alias 1="cd -"
alias 2="cd -2"
alias 3="cd -3"
alias 4="cd -4"
alias 5="cd -5"
alias 6="cd -6"
alias 7="cd -7"
alias 8="cd -8"
alias 9="cd -9"
alias ..="cd .." # Go up one directory
alias ...="cd ../.." # Go up two directories
alias ....="cd ../../.." # Go up three directories

# Shortcuts
alias c=cat
alias cl=clear
alias h=history
alias f=find
alias k=kill
alias m="${VIDEO}"
alias n="note $HOME/.note"
alias nn="note $HOME/.notemed"
alias p=pacman
alias s=sudo
alias v="${VISUAL}"
alias x=exit
alias y=yaourt
alias _=sudo

# Fasd uses these by default:
if have fasd; then
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

# List directory contents
alias lsa="ls -lah"
alias l="ls -lah"
alias ll="ls -lh"
alias la="ls -lAh"
alias l1="ls -1"

[[ "$(uname)" == "Linux" ]] && ls="ls --color=auto"

alias irc="$IRC_CLIENT"

# Language aliases
alias rb="ruby"
alias py="python"
alias py2="python2"
alias py3="python3"
alias ipy="ipython"
alias ipy2="ipython2"
alias ipy3="ipython3"

# Tree
if ! have tree; then
    alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi


alias cpv="rsync -Ph" # use rsync as cp alternative due to more information
