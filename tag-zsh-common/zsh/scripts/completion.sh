#!/usr/bin/env zsh


# Allow autocompletion of command-line switches for aliases.
setopt COMPLETE_ALIASES

# Automatically rehash when trying to autocomplete a command, i.e. find commands that are new in $PATH.
zstyle ':completion:*' rehash true

# Enable full completion for some custom aliases.
typeset -A completion_aliases=(
    sc systemctl
    g git
    s sudo
)
for k v ("${(@kv)completion_aliases}") compdef "${k}"="${v}"
