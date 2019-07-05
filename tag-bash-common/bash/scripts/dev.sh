#!/usr/bin/env bash

alias g=git
alias raw='grep -Ev "^\s*(;|#|$)"'
psf() { ps aux | grep "$@" | grep -v grep; }
wgp() { wgetpaste -X "$@"; }
debug() { bash -x $(which "$1") "${@:1}"; }
#sprunge() { curl -F 'sprunge=<-' http://sprunge.us }
myip() { curl ipinfo.io; }
speedtest() { curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -; }

