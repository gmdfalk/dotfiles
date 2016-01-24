#!/usr/bin/env bash
#
# Load shared custom bash configurations

EXTENSION="bash"

# {{{ Helper functions
load_scripts_by_name() {
    local directory="${1}"
    [[ ! -d "$directory" ]] && return 1

    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        if [[ -r "${directory}/${script}.${EXTENSION}" ]]; then
            echo "${directory}/${script}.${EXTENSION}"
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
        echo "$script"
        [[ -r "$script" ]] && . "$script"
    done

    [[ -n "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
}
# }}}

# {{{ Source scripts

# Load auto scripts that need to be sourced first
load_scripts_in_folder "${BASH_CUSTOM_DIR}/pre-autoload"

# Load on-demand scripts that need to be sourced first
if [[ -n "$BASH_PRE_SCRIPTS" ]]; then
    load_scripts_by_name "${BASH_CUSTOM_DIR}/pre" "${BASH_PRE_SCRIPTS[@]}"
fi

# Load on-demand scripts that need to be sourced last
if [[ -n "$BASH_POST_SCRIPTS" ]]; then
    load_scripts_by_name "${BASH_CUSTOM_DIR}/post" "${BASH_POST_SCRIPTS[@]}"
fi

# Load auto scripts that need to be sourced last
load_scripts_in_folder "${BASH_CUSTOM_DIR}/post-autoload"

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
