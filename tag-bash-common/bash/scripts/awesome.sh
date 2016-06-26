#!/usr/bin/env bash

# Loading this module only makes sense if the awesome binary exists in $PATH.
have awesome || return 1

alias ea="e $HOME/.config/awesome/rc.lua"
alias ma="m $HOME/.config/awesome/rc.lua"
alias ga="g $HOME/.config/awesome/rc.lua"
alias aex="killall awesome"
alias are="echo 'awesome.restart()' | awesome-client"
# just an example to remember:
apipe() { echo 'return require("awful").util.getdir("config")' | awesome-client; }
alias tail_awesome="tail -f ~/.logs/awe_*"
kdrop() { for i in $(ps aux | grep urxvt_drop | awk '{print $2}'); do kill $i; done; }

