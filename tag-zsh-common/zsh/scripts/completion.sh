#!/usr/bin/env zsh


# Allow autocompletion of command-line switches for aliases.
setopt COMPLETE_ALIASES

# Automatically rehash when trying to autocomplete a command, i.e. find commands that are new in $PATH.
zstyle ':completion:*' rehash true