#!/usr/bin/env bash

# Blockify shortcuts
bl() {
    local signal
    local cmd
    case "$1" in
        "") blockify-dbus get song && return 0;;
        ex) signal='TERM';;       # Exit
        b) signal='USR1';;        # Block
        u) signal='USR2';;        # Unblock
        p) signal='RTMIN';;       # Previous song
        n) signal='RTMIN+1';;     # Next song
        t) signal='RTMIN+2';;     # Toggle play song
        tb) signal='RTMIN+3';;    # Toggle block song
        pi) signal='RTMIN+10';;   # Previous interlude song
        ni) signal='RTMIN+11';;   # Next interlude song
        ti) signal='RTMIN+12';;   # Toggle play interlude song
        tir) signal='RTMIN+13';;  # Toggle interlude resume
        *) echo "Bad option" && return 0;;
    esac
    cmd="pkill --signal $signal -f 'python.*blockify'"
    if [[ $2 == "htpc" ]];then
        cmd="$SSH2 \"${cmd}\""
    fi
    eval "${cmd}"
}

blr() {
    bl "$1" "htpc"
}