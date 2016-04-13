#!/usr/bin/env bash

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

# Change the keyboard layout. For a full list of available layouts and variants look here: http://pastebin.com/v2vCPHjs.
# The german layout is horrible for programming, which is why i often switch to GB (sometimes US international).
# Umlauts for GB:            ä=AltGr+[a, ö=AltGr+[o, ü=AltGr+[u, ß=AltGr+s.
# Umlauts for Mac GB:        ä=Alt+ua,   ö=Alt+uo,   ü=Alt+uu,   ß=Alt+s.
# On OS X, you can use xkbswitch (https://github.com/myshov/xkbswitch-macosx) as an alternative to setxkbmap.
# Umlauts for US altgr-intl: ä=AltGr+q,  ö=AltGr+p,  ü=AltGr+y,  ß=AltGr+s.
kbd() {
    case "$@" in
        den|DEN)
            setxkbmap de -variant nodeadkeys;;
        usi|USI)
            setxkbmap us -variant altgr-intl;;
        gb|GB|uk|UK|en|EN)
            setxkbmap gb;;
        '')
            setxkbmap -query;;
        *)
            setxkbmap "$@";;
    esac
    # Reapply any customizations to the layout.
    have xmodmap && xmodmap "${HOME}/.Xmodmap" &>/dev/null
    #have xbindkeys && xbindkeys
}
