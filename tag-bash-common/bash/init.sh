#!/usr/bin/env bash

BASH_DIR="$HOME/.bash/custom"
PRE_DIR="${BASH_DIR}/pre"
POST_DIR="${BASH_DIR}/post"

load_scripts() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
#        echo "${directory}/${script}.sh"
        [[ -f "${directory}/${script}.sh" ]] && source "${directory}/${script}.sh"
    done
}

[[ -z "$PRE_SCRIPTS" ]] && PRE_SCRIPTS=(utilities env)
[[ -z "$POST_SCRIPTS" ]] && POST_SCRIPTS=(z git fallbacks)

load_scripts "${PRE_DIR}" "${PRE_SCRIPTS[@]}"
load_scripts "${POST_DIR}" "${POST_SCRIPTS[@]}"
# }}}
