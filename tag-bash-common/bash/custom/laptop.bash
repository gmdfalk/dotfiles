#!/usr/bin/env bash

alias wol2="wol 40:61:86:87:F3:FE"
alias wol2i="wol -i 192.168.0.2 40:61:86:87:F3:FE"

alias ssh2="$SSH2"

doff() {
    local cmd
    [[ -n "$1" ]] && cmd="$SSH2 DISPLAY=:0 "
    cmd+="xset dpms force off"
    eval ${cmd}
}

don() {
    local cmd
    [[ -n "$1" ]] && cmd="$SSH2 DISPLAY=:0 "
    cmd+="xset dpms force on"
    eval ${cmd}
}



