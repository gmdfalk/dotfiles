#!/usr/bin/env bash

# Blockify shortcuts
bb() {
    local signal
    local cmd
    case "$1" in
        "") blockify-dbus get && return 0;;
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

bbr() {
    bb "$1" "htpc"
}

pc() {
    case "$1" in
        "") arg="status";;
        p) arg="previous";;
        n) arg="next";;
        t) arg="play-pause";;
        v) arg="volume $2";;
        s) arg="stop";;
        *) echo "Bad option" && return 0;;
    esac
    if have playerctl-wrapper; then
        playerctl-wrapper "$arg"
    else
        playerctl "$arg"
    fi
}
