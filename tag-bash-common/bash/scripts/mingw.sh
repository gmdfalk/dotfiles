#!/usr/bin/env bash
#

if [[ "$OSTYPE" == "msys" ]]; then
    alias grep="/bin/grep"
    alias git="/bin/git"
    alias killagents="for p in $(ps aux | grep ssh-agent | awk '{print $1}'); do kill $p; done"
fi
