#!/usr/bin/env bash

count() {
    local seconds
    case "$1" in
        *[sS]) seconds=${1/%?/};;
        *[mM]) seconds=$(( ${1/%?/} * 60 ));;
        *[hH]) seconds=$(( ${1/%?/} * 3600 ));;
        *[0-9]) seconds=$1;;
        "") seconds=0;;
        *)  echo "Bad option." && return 1;;
    esac
    local secs=${seconds}

    do_count() {
        local message="$1"
        local operator="$2"
        printf "${message}" $((secs))
        sleep 1 &>/dev/null
        secs=$(( $secs $operator 1 ))
    }
    if (( seconds > 0 )); then
        while (( secs >= 0 )); do
            do_count "\r%02d/${seconds}s" -
        done
    else # count up
        while true; do
            do_count "\r%02ds" +
        done
    fi
    echo
}
