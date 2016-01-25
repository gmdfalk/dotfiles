#!/usr/bin/env zsh
#
# Load shared custom zsh configurations

EXTENSION="zsh"

[[ "$DEBUG" ]] && echo init.zsh

# {{{ Helper functions
load_scripts_by_name() {
    local directory="${1}"
    [[ ! -d "$directory" ]] && return 1

    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        if [[ -r "${directory}/${script}.${EXTENSION}" ]]; then
            [[ "$DEBUG" ]] && echo "${directory}/${script}.${EXTENSION}"
            source "${directory}/${script}.${EXTENSION}"
        fi
    done
}

load_scripts_in_folder() {
    local directory="${1}"
    [[ ! -d "$directory" ]] && return 1

    # Ignore 0 results on glob expansion
    setopt null_glob

    for script in "$directory"/*.${EXTENSION}; do
        [[ "$DEBUG" ]]&& echo "$script"
        source "$script"
    done

    unsetopt null_glob
}
# }}}

# {{{ Source scripts

# Load auto scripts that need to be sourced first
load_scripts_in_folder "${ZSH_CUSTOM_DIR}/pre-autoload"

# Load on-demand scripts that need to be sourced first
if [[ -n "$ZSH_PRE_SCRIPTS" ]]; then
    load_scripts_by_name "${ZSH_CUSTOM_DIR}/pre" "${ZSH_PRE_SCRIPTS[@]}"
fi

# Load on-demand scripts that need to be sourced last
if [[ -n "$ZSH_POST_SCRIPTS" ]]; then
    load_scripts_by_name "${ZSH_CUSTOM_DIR}/post" "${ZSH_POST_SCRIPTS[@]}"
fi

# Load auto scripts that need to be sourced last
load_scripts_in_folder "${ZSH_CUSTOM_DIR}/post-autoload"

# }}}

# {{{ Cleanup

unset EXTENSION VERBOSE

# }}}
