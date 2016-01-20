#!/usr/bin/env bash
#
# Load shared custom bash configurations

[[ -z "$BASH_DIR" ]] && BASH_DIR="$HOME/.bash"
[[ -z "$BASH_PRE_SCRIPTS" ]] && BASH_PRE_SCRIPTS=(utilities env)
[[ -z "$BASH_POST_SCRIPTS" ]] && BASH_POST_SCRIPTS=(fallbacks)
SCRIPTS_DIR="${BASH_DIR}/custom"
# Error out if $SCRIPTS_DIR doesn't exist.
[[ ! -d "$SCRIPTS_DIR" ]] && exit 1
EXTENSION="sh"

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
    [[ -n "$ZSH_VERSION" ]] && setopt null_glob || shopt -s nullglob

    for script in "$directory"/*.${EXTENSION}; do
        echo "Automatically loading $script"
        [[ -f "$script" ]] && source "$script"
    done

    [[ -n "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
}


# Load scripts that need to be sourced first
if [[ -n "$BASH_PRE_SCRIPTS" ]]; then
    load_scripts_by_name "${SCRIPTS_DIR}/pre" "${BASH_PRE_SCRIPTS[@]}"
fi

# Load any customization scripts in the root of SCRIPTS_DIR where load order doesn't matter.
load_scripts_in_folder "${SCRIPTS_DIR}"

# Load scripts that need to be sourced last
if [[ -n "$BASH_POST_SCRIPTS" ]]; then
    load_scripts_by_name "${SCRIPTS_DIR}/post" "${BASH_POST_SCRIPTS[@]}"
fi
# }}}
