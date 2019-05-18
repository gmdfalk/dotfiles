#!/usr/bin/env zsh

setopt share_history

# {{{ Globals
alias -g ...="../.."
alias -g ....="../../.."
alias -g .....="../../../.."
alias -g CA="2>&1 | cat -A"
alias -g G="| grep"
alias -g GE="| grep -E"
alias -g GP="| grep -P"
alias -g GI="| grep -i"
alias -g GV="| grep -v"
alias -g H="| head"
alias -g L="| less"
alias -g LL="2>&1 | less"
alias -g N="&>/dev/null"
alias -g N1="1>/dev/null"
alias -g N2="2>/dev/null"
alias -g S="| sort"
alias -g SP="| curl -F 'sprunge=<-' http://sprunge.us"
alias -g T="| tail"
alias -g VAR=">>$HOME/.logs/var.txt"
alias -g WC="| wc"
alias -g WCL="| wc -l"
alias -g X="| xargs"
# }}}

# ls directories
alias lsd="ls -d *(-/N)"       # list visible directories
alias lsf="ls -d *(-.N)"       # list visible directories
alias lhd="ls -d .*(-/N)"      # list hidden directories
alias lad="ls -d *(-/DN)"      # list all directories
alias lld="ll -d *(-/N)"       # list details of visible directories
alias llad="ls -lhd *(-/DN)"   # list details of all directories
alias llhd="ls -lhd .*(-/N)"   # list details of hidden directories
alias llhf="ls -lh .*(-.N)"    # list details of hidden files

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
alias dud="du -hs *(/)"            # show directory sizes
alias lsx="ls -l *(*)"             # only executables
alias lsw="ls -ld *(R,W,X.^ND/)"   # world-{readable,writable,executable} files

# zmv {{{
autoload -U zmv
alias mmv="noglob zmv -W"
mmvlc() { [[ $1 = -r ]] && zmv '(**/)(*)' '$1${(L)2}' || zmv '(*)' '${(L)1}'; } # To lower case.
mmvsp() { [[ $1 = -r ]] && zmv '(**/)(* *)' '$f:gs/ /_' || zmv '(* *)' '$f:gs/ /_'; } # Remove special characters.
alias mmvall="mmvsp ; mmvlc"
mmvspecial() { # remove  / : ; * = " ' ( ) < > | from filenames
    unwanted="[(:);*?\"<>|']"
    zmv -Q "(**/)(*$~unwanted*)(D)" '$1${2//$~unwanted/}'
}
# }}}
