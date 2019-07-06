#!/usr/bin/env bash

# Admin/Dev {{{
alias g=git
alias raw='grep -Ev "^\s*(;|#|$)"'
psf() { ps aux | grep "$@" | grep -v grep; }
wgp() { wgetpaste -X "$@"; }
debug() { bash -x $(which "$1") "${@:1}"; }
#sprunge() { curl -F 'sprunge=<-' http://sprunge.us }
myip() { curl ipinfo.io; }
speedtest() { curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -; }

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
grab() { chown -R ${USER}:${USER} ${1-.}; }

# Sanitize permissions, i.e. apply 022 umask (755 for directories and 644 for files),
# and change owner to me:users.
sanitize() {
    chmod -R u=rwX,go=rX "$@"
    chown -R ${USER}:users "$@"
}
# }}}

# Media {{{
# Count down (if argument is given) or up and continually print progress into the same line.
# Usage: count [<amount>[<unit>]].
# Example: count 3 (seconds is default); count 1h && echo "Wow, that took a while"
count() {
    local seconds
    case "$1" in
        *[sS]) seconds=${1/%?/};;
        *[mM]) seconds=$(( ${1/%?/} * 60 ));;
        *[hH]) seconds=$(( ${1/%?/} * 3600 ));;
        *[0-9]) seconds=$1;;
        "") seconds=0;;
        *)  echo "Bad option." && return 1;;
    esac
    local secs=${seconds}

    do_count() {
        local message="$1"
        local operator="$2"
        printf "${message}" $((secs))
        sleep 1 &>/dev/null
        secs=$(( $secs $operator 1 ))
    }
    if (( seconds > 0 )); then
        while (( secs >= 0 )); do
            do_count "\r%02d/${seconds}s" -
        done
    else # count up
        while true; do
            do_count "\r%02ds" +
        done
    fi
    echo
}

# From https://zxq9.com/archives/795:
#YY-MM-DD_hh:mm:ss             | date +%F_%T                | 2013-05-17_10:16:09
#YYMMDD_hhmmss                 | date +%Y%m%d_%H%M%S        | 20130517_101609
#YYMMDD_hhmmss (with local TZ) | date +%Y%m%d_%H%M%S%Z      | 20130517_101609JST
#YYMMDD_hhmmss (UTC version)   | date --utc +%Y%m%d_%H%M%SZ | 20130517_011609Z
#YYMMSShhmmss                  | date +%Y%m%d%H%M%S         | 20130517101609
#YYMMSShhmmssnnnnnnnnn         | date +%Y%m%d%H%M%S%N       | 20130517101609418928482
#Seconds since UNIX epoch:     | date +%s                   | 1368753369
#Nanoseconds since UNIX epoch: | date +%s%N                 | 1368753369431083605
#ISO8601 Local TZ timestamp    | date +%FT%T%Z              | 2013-05-17T10:16:09JST
#ISO8601 UTC timestamp         | date --utc +%FT%TZ         | 2013-05-17T01:16:09Z
timestamp() {
    local date
    case "$@" in
        ft)     date="$(date +%F_%T)" ;;
        "")     date="$(date +%Y%m%d_%H%M%S)" ;;
        tz)     date="$(date +%Y%m%d_%H%M%S%Z)" ;;
        utc)    date="$(date --utc +%Y%m%d_%H%M%SZ)" ;;
        long)   date="$(date +%Y%m%d%H%M%S)" ;;
        full)   date="$(date +%Y%m%d%H%M%S%N)" ;;
        s)      date="$(date +%s)" ;;
        ns)     date="$(date +%s%N)" ;;
        iso)    date="$(date +%FT%T%Z)" ;;
        isoutc) date="$(date --utc +%FT%TZ)" ;;
        *)      echo "Usage: timestamp [ ft | tz | utc | long | full | s | ns | iso | isoutc ]" && return ;;
    esac
    echo "${date}"
}

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
alias n="note $HOME/.note"
alias nn="note $HOME/.notemed"
alias vn="${VISUAL} ${HOME}/.note"
alias vnn="${VISUAL} ${HOME}/.notemed"
# }}}

