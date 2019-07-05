#!/usr/bin/env bash

# cdr {{{
# Enable the cdr command which automatically tracks cd history and allows revisiting via cdr <TAB>.
# It is preferable to using the DIRSTACK and dirs mechanism because it works across zsh sessions as well as across
# terminal emulators within one session.
#autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
#add-zsh-hook chpwd chpwd_recent_dirs
#zstyle ':chpwd:*' recent-dirs-file "${ZCACHE}/chpwd-recent-dirs"
# }}}

# zmv {{{
autoload -U zmv
alias mmv="noglob zmv -W"
mmvlc() { [[ $1 = -r ]] && zmv '(**/)(*)' '$1${(L)2}' || zmv '(*)' '${(L)1}'; } # To lower case.
mmvsp() { [[ $1 = -r ]] && zmv '(**/)(* *)' '$f:gs/ /_' || zmv '(* *)' '$f:gs/ /_'; } # Remove special characters.
# }}}

# chpwd {{{
# When switching directories, list directory content according to the type of cd command used.
#preexec() {
#    LS_USED=$(echo $1 | cut -d' ' -f1)
#}
#
#chpwd() {
#    case "${LS_USED}" in
#        cd)     ls -hF;;
#        cda)    ls -hlAF;;
#        cdl)    ls -hlF;;
#        cdn)    ;;
#        *)      ls -hF;;
#    esac
#    # Write dirstack to file.
##    print -l $PWD ${(u)dirstack} >| "${DIRSTACKFILE}"
#}
#alias {cda,cdl,cdn}="cd"
# }}}


