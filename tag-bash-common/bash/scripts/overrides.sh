#!/usr/bin/env bash

# Detach these processes from shell by default
if have q; then
    declare -a processes=( spotify hexchat vlc pcmanfm )
    for process in "${processes[@]}"; do
        alias ${process}="q $process"
    done
    unset process
fi

if ! have clear; then
    alias clear='printf "\033c"'
fi

if ! have tree; then
    alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi
