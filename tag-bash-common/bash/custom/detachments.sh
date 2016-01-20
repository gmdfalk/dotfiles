#!/usr/bin/env bash

# Detach these processes from shell by default
declare -a processes=(firefox thunderbird eog spotify hexchat vlc geany gedit medit gvim pcmanfm)
for process in ${processes[@]}; do
    alias $process="q $process"
done
