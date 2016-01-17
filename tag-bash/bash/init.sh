#!/usr/bin/env bash

BASH_DIR="$HOME/.bash"
PRE_DIR="${BASH_DIR}/pre"
POST_DIR="${BASH_DIR}/post"

load_plugins() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local plugins=("${@:2}")

    for plugin in ${plugins[@]}; do
#        echo "${directory}/${plugin}.sh"
        [[ -f "${directory}/${plugin}.sh" ]] && source "${directory}/${plugin}.sh"
    done
}

[[ -z "$PRE_PLUGINS" ]] && PRE_PLUGINS=(utilities env)
[[ -z "$POST_PLUGINS" ]] && POST_PLUGINS=(z git fallbacks)

load_plugins "${PRE_DIR}" "${PRE_PLUGINS[@]}"
load_plugins "${POST_DIR}" "${POST_PLUGINS[@]}"
# }}}
