#!/usr/bin/env bash
#
# Load shared custom bash configurations

EXTENSION="sh"
[[ "$DEBUG" ]] && echo init.bash

# {{{ Helper functions
load_scripts_by_name() {
    local directory="$1"
    [[ ! -d "$directory" ]] && return 1

    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    local file
    for script in "${scripts[@]}"; do
        file="${directory}/${script}.${EXTENSION}"
        if [[ -r "${file}" ]]; then
            [[ "$DEBUG" ]] && echo "${file}"
            source "${file}"
        fi
    done
}

load_scripts_in_folder() {
    local directory="$1"
    [[ ! -d "${directory}" ]] && return 1

    # Ignore 0 results on glob expansion
    [[ "${ZSH_VERSION}" ]] && setopt null_glob || shopt -s nullglob

    for script in "${directory}"/*.${EXTENSION}; do
        if [[ -r "${script}" ]];then
            [[ "${DEBUG}" ]] && echo "${script}"
            source "${script}"
        fi
    done

    [[ "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
}
# }}}

# {{{ Source scripts
# Load auto scripts that need to be sourced first
load_scripts_in_folder "${BASH_DIR}/autoload"

# Load on-demand scripts that need to be sourced first
if [[ "${BASH_SCRIPTS}" ]]; then
    load_scripts_by_name "${BASH_DIR}/scripts" "${BASH_SCRIPTS[@]}"
fi
# }}}

# {{{ Post config
# Initialize fasd, the command-line productivity booster (https://github.com/clvv/fasd)
have fasd && eval "$(fasd --init auto)"
# }}}

# {{{ Cleanup
unset EXTENSION
# }}}
