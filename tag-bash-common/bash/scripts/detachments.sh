#!/usr/bin/env bash

# Detach these processes from shell by default
if have q; then
    declare -a processes=(firefox thunderbird eog spotify hexchat vlc geany gedit medit gvim pcmanfm mplayer smplayer)
    for process in ${processes[@]}; do
        alias $process="q $process"
    done
fi
