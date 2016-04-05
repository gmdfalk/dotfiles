#!/usr/bin/env bash
#
# Load shared custom bash configurations

_BASE_DIR="${BASH_DIR:-${HOME}/.bash}"
_SCRIPTS="${BASH_SCRIPTS[@]}"
[[ "$DEBUG" ]] && echo init.bash

# {{{ Helper functions
have() {
    type "$@" &>/dev/null
}

# Loads scripts/plugins and takes two arguments:
# - directory: The folder to load scripts from.
# - scripts: A space separated list of script names or "*" for all scripts in the folder.
load_scripts() {
    local directory="$1"
    [[ -d "${directory}" ]] && shift || return 1
    local extension="sh"
    local -a scripts

    if [[ "$@" == "*" ]]; then
        scripts=(${directory}/*.$extension) # &>/dev/null
    else
        while read -rd ' ' script || [[ "${script}" ]]; do
            scripts+=("${directory}/${script}.${extension}");
        done <<< "$@"
    fi

    for script in "${scripts[@]}"; do
        if [[ -r "${script}" ]]; then
            [[ "${DEBUG}" ]] && echo "${script}"
            source "${script}"
        fi
    done

}
# }}}

# {{{ Source scripts
# Load auto scripts that need to be sourced first
load_scripts "${_BASE_DIR}/autoload" "*"

# Load on-demand scripts that need to be sourced first
load_scripts "${_BASE_DIR}/scripts" "${_SCRIPTS[@]}"
# }}}

# {{{ Post config
# Initialize fasd, the command-line productivity booster (https://github.com/clvv/fasd)
have fasd && eval "$(fasd --init auto)"
# }}}

# {{{ Cleanup
unset _BASE_DIR _SCRIPTS
# }}}
