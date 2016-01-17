#!/usr/bin/env bash
#
# Load shared custom bash configurations

[[ -z "$BASH_DIR" ]] && BASH_DIR="$HOME/.bash"
BASH_PRE_DIR="${BASH_DIR}/custom/pre"
BASH_POST_DIR="${BASH_DIR}/custom/post"

load_scripts() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        echo "${directory}/${script}.sh"
        [[ -f "${directory}/${script}.sh" ]] && source "${directory}/${script}.sh"
    done
}

[[ -z "$BASH_PRE_SCRIPTS" ]] && BASH_PRE_SCRIPTS=(utilities env)
[[ -z "$BASH_POST_SCRIPTS" ]] && BASH_POST_SCRIPTS=(z git fallbacks)

load_scripts "${BASH_PRE_DIR}" "${BASH_PRE_SCRIPTS[@]}"
load_scripts "${BASH_POST_DIR}" "${BASH_POST_SCRIPTS[@]}"
# }}}
