#!/usr/bin/env bash
#
# Load shared custom bash configurations

EXTENSION="bash"

[[ "$DEBUG" ]] && echo init.bash

# {{{ Helper functions
load_scripts_by_name() {
    local directory="${1}"
    [[ ! -d "$directory" ]] && return 1

    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        if [[ -r "${directory}/${script}.${EXTENSION}" ]]; then
            [[ "$DEBUG" ]] && echo "${directory}/${script}.${EXTENSION}"
            . "${directory}/${script}.${EXTENSION}"
        fi
    done
}

load_scripts_in_folder() {
    local directory="${1}"
    [[ ! -d "$directory" ]] && return 1

    # Ignore 0 results on glob expansion
    [[ -n "$ZSH_VERSION" ]] && setopt null_glob || shopt -s nullglob

    for script in "$directory"/*.${EXTENSION}; do
        [[ "$DEBUG" ]] && echo "$script"
        [[ -r "$script" ]] && . "$script"
    done

    [[ -n "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
}

# }}}

# {{{ Source scripts

# Load auto scripts that need to be sourced first
load_scripts_in_folder "${BASH_DIR}/autoload"

# Load on-demand scripts that need to be sourced first
if [[ -n "$BASH_SCRIPTS" ]]; then
    load_scripts_by_name "${BASH_DIR}/scripts" "${BASH_SCRIPTS[@]}"
fi

# }}}

# {{{ Post config

# Initialize fasd, the command-line productivity booster (https://github.com/clvv/fasd)
if have fasd; then
    eval "$(fasd --init auto)"
fi

# }}}

# {{{ Cleanup

unset EXTENSION

# }}}
