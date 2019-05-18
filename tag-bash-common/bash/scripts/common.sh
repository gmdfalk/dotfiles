#!/usr/bin/env bash

# Notes {{{
note() { # Write a note to a target file
    local target=$1
    [[ -f "${target}" ]] || touch "${target}"
    if [[ "$#" == 0 ]];then
        echo "Usage: note <filename> <message>"
    elif [[ "$#" == 1 ]];then
        cat "${target}" | tail -n 20
    else
        shift
        echo "$@" >> "${target}"
    fi
}
alias vn="${VISUAL} ${HOME}/.note"
alias vnn="${VISUAL} ${HOME}/.notemed"
# }}}

# Navigation {{{
alias d="dirs -v -l"

# Push and pop directories on directory stack
alias pu="pushd"
alias po="popd"
alias pp="pushd \$(pwd)"

# Move through directory stack ($(dirs)).
alias ..="cd .."         # Go up one directory
alias ...="cd ../.."     # Go up two directories
alias ....="cd ../../.." # Go up three directories
# }}}

# File Manager {{{
[[ "${OSTYPE}" == "linux-gnu" ]] && alias ls="ls --group-directories-first --color=auto --time-style=long-iso"
add_completion_alias "l" "ls"
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

ff() { find . 2>/dev/null | grep -is "$@"; }
ffc() { find . -type f 2>/dev/null | xargs grep -is "$@"; }
ffp() { find $(sed 's/:/ /g' <<< "${PATH}") 2>/dev/null | grep -is "$@"; }

# Swap two files/directories.
swap() {
    [[ "$#" != 2 ]] && echo "need 2 arguments" && return 1
    [[ ! -e "$1" ]] && echo "target $1 does not exist" && return 1
    [[ ! -e "$2" ]] && echo "target $2 does not exist" && return 1
    local tmpfile="tmp.$$"
    mv "$1" "${tmpfile}"
    mv "$2" "$1"
    mv "${tmpfile}" "$2"
}

# Take ownership of a file or directory.
grab() { ${_SUDO} chown -R ${USER}:${USER} ${1-.}; }

# Sanitize permissions, i.e. apply 022 umask (755 for directories and 644 for files),
# and change owner to me:users.
sanitize() {
    ${_SUDO} chmod -R u=rwX,go=rX "$@"
    ${_SUDO} chown -R ${USER}:users "$@"
}
# }}}

# Shortcuts {{{
alias c=cat
alias cl=clear
add_completion_alias "h" "history"
add_completion_alias "f" "find"
add_completion_alias "k" "kill"
alias m="${_VIDEO}"
alias n="note $HOME/.note"
alias nn="note $HOME/.notemed"
add_completion_alias "s" "sudo"
alias v="${VISUAL}"
alias x=exit
# }}}

# fasd {{{
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
# }}}





