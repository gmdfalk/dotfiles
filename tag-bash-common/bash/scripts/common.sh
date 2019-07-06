#!/usr/bin/env bash

# Config {{{
HISTSIZE=500000
SAVEHIST=$HISTSIZE

## Add scripts directory to $PATH, if it's missing.
BIN_DIR="${HOME}/bin"
case ":$PATH:" in
    *":$BIN_DIR:"*) :;; # already there
    *) PATH="$BIN_DIR:$PATH";; # or PATH="$PATH:$new_entry"
esac
PAGER=less
LESS="-F -g -i -M -R -S -w -X -z-4"

if [[ -z "${VISUAL}" ]]; then
    have vim && VISUAL="vim -p" || VISUAL="vi"
fi
EDITOR="${VISUAL}"
[[ -n "$DISPLAY" ]] && BROWSER="chromium" || BROWSER="lynx"
[[ -z "$LANG" ]] && export LANG="en_US.UTF-8"
export BROWSER \
       EDITOR \
       LESS \
       PAGER \
       PATH \
       TMPDIR \
       VISUAL
# }}}

# Shortcuts {{{
alias c=cat
alias cl=clear
alias h="history"
alias f="find"
alias k="kill"
alias s="sudo "
alias v="${VISUAL}"
alias x=exit
# }}}

# File Manager {{{
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
[[ "${OSTYPE}" == "linux-gnu" ]] && alias ls="ls --group-directories-first --color=auto --time-style=long-iso"
alias ll="ls -lh"
alias la="ls -lAh"
alias lh="ls -lhd .*"         # list details of hidden files/directories
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
# }}}

