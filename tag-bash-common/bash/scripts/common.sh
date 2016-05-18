#!/usr/bin/env bash

# Directories
alias md="mkdir -p"
alias rd="rmdir"
alias d="dirs -v | head -10"

# Push and pop directories on directory stack
alias pp="pushd"
alias p="popd"

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
[[ "${OSTYPE}" == "linux-gnu" ]] && alias ls="ls --group-directories-first --color=auto --time-style=long-iso"
alias l="ls"
alias ll="ls -lh"
alias la="ls -lAh"
alias l1="ls -1"

alias lh="ls -d .*"            # list hidden files/directories
alias llh="ls -lhd .*"         # list details of hidden files/directories
alias lnew="ls -lhrt"
alias lanew="ls -lAhrt"
alias lold="ls -lht"
alias laold="ls -lAht"
alias lbig="ls -lrSh"
alias labig="ls -lArSh"
alias lsmall="ls -lSh"
alias lasmall="ls -lASh"

alias cpv="rsync -Ph" # use rsync as cp alternative due to more information
alias cpr="rsync --partial --progress --append --rsh=ssh -r -h "
alias mvr="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
alias dfbtrfs="btrfs filesystem df -h /"

alias pingg="ping www.google.com"
ff() { find . | grep -is "$@"; }
ffc() { find . -type f | xargs grep -is "$@"; }
ffp() { find $(sed 's/:/ /g' <<< "${PATH}") | grep -is "$@"; }
psf() { ps aux | grep "$@" | grep -v grep; }
wgp() { wgetpaste -X "$@"; }
grab() { sudo chown -R ${USER}:${USER} ${1-.}; }
alias raw='grep -Ev "^\s*(;|#|$)"'
debug() { bash -x $(which "$1") "${@:1}"; }

alias cm="chmod"
alias cmx="chmod +x"

# {{{ Editing
alias vn="${VISUAL} ${HOME}/.note"
alias vnn="${VISUAL} ${HOME}/.notemed"
# }}}

# {{{ Navigation
alias cdt="cd ${TMPDIR}"
alias cdv="cd /var"
