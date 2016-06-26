#!/usr/bin/env zsh


# Allow autocompletion of command-line switches for aliases.
setopt COMPLETE_ALIASES

# Automatically `rehash` when trying to autocomplete, i.e. find and register commands that are new in $PATH.
zstyle ':completion:*' rehash true

# _COMPLETION_ALIASES is a list of completion pairs, e.g. ("g:git" "h:hub" "sc:systemctl").
# We split each element at the colon and assign with compdef to allow full zsh completion for our aliases.
apply_completion_aliases() {
    local alias command
    for pair in "${_COMPLETION_ALIASES[@]}"; do
        IFS=: read alias command <<< "${pair}"
        compdef "$alias"="$command"
    done
}
apply_completion_aliases
