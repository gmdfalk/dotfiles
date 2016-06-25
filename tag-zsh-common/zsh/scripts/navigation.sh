#!/usr/bin/env zsh

ZCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ ! -d "$ZCACHE" ]] && mkdir -p "${ZCACHE}"

# general {{{
DIRSTACKSIZE=${DIRSTACKSIZE:-20}
DIRSTACKFILE="${DIRSTACKFILE:-${ZCACHE}/dirs}"

# Automatically track directories used.
setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME PUSHD_MINUS

# Don't allow omitting 'cd' when changing directories and keep duplicates.
unsetopt AUTO_CD PUSHD_IGNORE_DUPS
# }}}

# chpwd {{{
# When switching directories, list directory content according to the type of cd command used.

preexec() {
    LS_USED=$(echo $1 | cut -d' ' -f1)
    #print -Pn "\e]2;$1 (%~) %n@%m\a"
}

chpwd() {
    case "${LS_USED}" in
        cd)     ls --color=auto --group-directories-first -hF;;
        cda)    ls --color=auto --group-directories-first -hlAF;;
        cdl)    ls --color=auto --group-directories-first -hlF;;
        cdn)    ;;
        *)      ls --color=auto --group-directories-first -hF;;
    esac
    # Write dirstack to file.
#    print -l $PWD ${(u)dirstack} >| "${DIRSTACKFILE}"
}
alias {cda,cdl,cdn}="cd"
# }}}

# cdr {{{
# Enable the cdr command which automatically tracks cd history and allows revisiting via cdr <TAB>.
# It is preferable to using the DIRSTACK and dirs mechanism because it works across zsh sessions as well as across
# terminal emulators within one session.
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file "${ZCACHE}/chpwd-recent-dirs"
# }}}