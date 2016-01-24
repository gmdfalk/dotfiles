#!/usr/bin/env bash

# Detach these processes from shell by default
if have quiet; then
    declare -a processes=(firefox thunderbird eog spotify hexchat vlc geany gedit medit gvim pcmanfm)
    for process in ${processes[@]}; do
        alias $process="quiet $process"
    done
fi
