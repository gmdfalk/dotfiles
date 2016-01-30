#!/usr/bin/env zsh

## aliases and functions
alias mmv="noglob zmv -W"
alias mv="nocorrect mv"
alias rm="nocorrect rm"
alias cp="nocorrect cp"
alias ls0="ls **/*(ND.L0m+0m-2) **/*.bak"
alias rm0="rm -i *(.L0) *.bak(.)"

# edit
alias vnew="v *(.om[1])"         # edit newest file
alias vnew3="v -p *(.om[1,3])"   # open 3 newest files in tabs
alias vtoday="v p *(m0)"        # re-edit all files changed today!
alias mnew="m *(.om[1])"
alias mnew3="m *(.om[1,3])"
alias mtoday="m *(m0)"

# ls hidden
alias lh="ls -d .*"            # list hidden files/directories
alias llh="ls -lhd .*"         # list details of hidden files/directories
alias llhd="ls -lhd .*(-/N)"       # list details of hidden directories
alias llhf="ls -lh .*(-.N)"        # list details of hidden files

# ls directories
alias lsd="ls -d *(-/N)"        # list visible directories
alias lhd="ls -d .*(-/N)"      # list hidden directories
alias lad="ls -d *(-/DN)"      # list all directories
alias lld="ll -d *(-/N)"       # list details of visible directories
alias llad="ls -lhd *(-/DN)"       # list details of all directories

# ls files
alias lf="ls *(-.N)"           # list visible files
alias lhf="ls .*(-.N)"         # list hidden files
alias laf="ls -A *(-.DN)"      # list all files
alias llf="ll *(-.N)"          # list details of visible files
alias llaf="ls -lhA *(-.DN)"       # list details of all files

# ls empty
alias len="ls -ld **/*(/^F)"
alias le="ls -d *(-/DN^F)"         # list all empty directories
alias ler="ls -d **/*(-/DN^F)"     # list all empty directories recursively
alias lefr="ls -d **/*(-/N^F)"     # list all empty directories recursively
alias lle="ls -ld *(-/DN^F)"       # list details of all empty directories
alias ller="ls -lhd **/*(-/DN^F)"  # list details of all empty directories recursively

# ls various
alias dud="du -hs *(/)"        # show directory sizes
alias lsx="ls -l *(*)"         # only executables
alias lsw="ls -ld *(R,W,X.^ND/)"   # world-{readable,writable,executable} files
alias ls2m="ls -l *(Lm+2) 2>/dev/null" # list files bigger than 2 megabytes
alias lnx="ls *~*.*(.)"        # list files without extension
alias lpics="ls *.(jpg|jpeg|gif) N2"

mmvlc() { [[ $1 = -r ]] && zmv '(**/)(*)' '$1${(L)2}' || zmv '(*)' '${(L)1}'; }
mmvsp() { [[ $1 = -r ]] && zmv '(**/)(* *)' '$f:gs/ /_' || zmv '(* *)' '$f:gs/ /_'; }
alias mmvboth="mmvsp ; mmvlc"
alias mmvrboth="mmvspr ; mmvlcr"
mmvspecial() { # remove  / : ; * = " ' ( ) < > | from filenames
    unwanted="[(:);*?\"<>|']"
    zmv -Q "(**/)(*$~unwanted*)(D)" '$1${2//$~unwanted/}'
}