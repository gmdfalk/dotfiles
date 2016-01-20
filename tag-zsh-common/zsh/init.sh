#!/usr/bin/env zsh
#
# Load shared custom zsh configurations

[[ -z "$ZSH_DIR" ]] && ZSH_DIR="$HOME/.zsh"
[[ -z "$ZSH_PRE_SCRIPTS" ]] && ZSH_PRE_SCRIPTS=()
[[ -z "$ZSH_POST_SCRIPTS" ]] && ZSH_POST_SCRIPTS=()
SCRIPTS_DIR="${ZSH_DIR}/custom"
# Error out if $SCRIPTS_DIR doesn't exist.
[[ ! -d "$SCRIPTS_DIR" ]] && exit 1
EXTENSION="zsh"

load_scripts_by_name() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        if [[ -f "${directory}/${script}.${EXTENSION}" ]]; then
            echo "Loading ${directory}/${script}.${EXTENSION}"
            source "${directory}/${script}.${EXTENSION}"
        fi
    done
}

load_scripts_in_folder() {
    local directory="${1}"
    # Ignore 0 results on glob expansion
    setopt null_glob

    for script in "$directory"/*.${EXTENSION}; do
        echo "Automatically loading $script"
        source "$script"
    done

    unsetopt null_glob
}


# Load scripts that need to be sourced first
if [[ -n "$ZSH_PRE_SCRIPTS" ]]; then
    load_scripts_by_name "${SCRIPTS_DIR}/pre" "${ZSH_PRE_SCRIPTS[@]}"
fi

# Load any customization scripts in the root of SCRIPTS_DIR where load order doesn't matter.
load_scripts_in_folder "${SCRIPTS_DIR}"

# Load scripts that need to be sourced last
if [[ -n "$ZSH_POST_SCRIPTS" ]]; then
    load_scripts_by_name "${SCRIPTS_DIR}/post" "${ZSH_POST_SCRIPTS[@]}"
fi
# }}}
