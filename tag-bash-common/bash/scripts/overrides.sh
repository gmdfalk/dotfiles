#!/usr/bin/env bash

# Detach these processes from shell by default
if have q; then
    declare -a processes=(
        firefox thunderbird eog spotify hexchat vlc geany gedit medit gvim pcmanfm mplayer smplayer
        evince libreoffice lowriter localc intellij-idea-ultimate-edition jetbrains-rubymine webstorm pycharm
    )
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

if have grc; then
    alias .cl="grc -es --colour=auto"
    alias configure=".cl ./configure"
    alias diff=".cl diff"
    alias make=".cl make"
    alias gcc=".cl gcc"
    alias g++=".cl g++"
    alias as=".cl as"
    alias ld=".cl ld"
    alias netstat=".cl netstat"
    alias ping=".cl ping"
    alias traceroute=".cl traceroute"
fi
