#!/usr/bin/env bash
#
# Load shared custom bash configurations

_BASE_DIR="${BASH_DIR:-${HOME}/.bash}"
_SCRIPTS="${BASH_SCRIPTS[@]}"
[[ "$DEBUG" ]] && echo init.bash

# {{{ Helper functions
myread() {
    if [[ "${ZSH_VERSION}" ]]; then
        read -A "$@"
    else
        read -a "$@"
    fi

}

load_scripts() {
    local directory="$1"
    [[ -d "${directory}" ]] && shift || return 1
    local extension="sh"
    local -a scripts

    # Ignore 0 results on glob expansion
    [[ "${ZSH_VERSION}" ]] && setopt null_glob || shopt -s nullglob

    cd "${directory}"
    if [[ "$@" == "*" ]]; then
        scripts=(*.$extension)
    else
        while read -rd ' ' script || [[ "${script}" ]]; do
            scripts+=("${script}.${extension}");
        done <<< "$@"
    fi

    for script in "${scripts[@]}"; do
        if [[ -r "${script}" ]]; then
            [[ "${DEBUG}" ]] && echo "${script}"
            source "${script}"
        fi
    done

    [[ "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
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
