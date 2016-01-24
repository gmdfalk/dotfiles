#!/usr/bin/env bash
#
# Load shared custom bash configurations

[[ -z "$BASH_DIR" ]] && BASH_DIR="$HOME/.bash"
[[ -z "$BASH_PRE_SCRIPTS" ]] && BASH_PRE_SCRIPTS=(util env)
[[ -z "$BASH_SCRIPTS_DIR" ]] && BASH_SCRIPTS_DIR="${BASH_DIR}/custom"
EXTENSION="bash"

# Error out if $BASH_SCRIPTS_DIR doesn't exist.
[[ ! -d "$BASH_SCRIPTS_DIR" ]] && exit 1

load_scripts_by_name() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        if [[ -f "${directory}/${script}.${EXTENSION}" ]]; then
            echo "Loading ${directory}/${script}.${EXTENSION}"
            . "${directory}/${script}.${EXTENSION}"
        fi
    done
}

load_scripts_in_folder() {
    local directory="${1}"

    # Ignore 0 results on glob expansion
    [[ -n "$ZSH_VERSION" ]] && setopt null_glob || shopt -s nullglob

    for script in "$directory"/*.${EXTENSION}; do
        echo "Automatically loading $script"
        [[ -f "$script" ]] && . "$script"
    done

    [[ -n "$ZSH_VERSION" ]] && unsetopt null_glob || shopt -u nullglob
}

# {{{ Source scripts

# Load any customization scripts in the lib folder.
load_scripts_in_folder "${BASH_SCRIPTS_DIR}/lib"

# Load scripts that need to be .d first
if [[ -n "$BASH_PRE_SCRIPTS" ]]; then
    load_scripts_by_name "${BASH_SCRIPTS_DIR}/pre" "${BASH_PRE_SCRIPTS[@]}"
fi

# Load any customization scripts in the autoload folder.
load_scripts_in_folder "${BASH_SCRIPTS_DIR}/autoload"

# Load scripts that need to be .d last
if [[ -n "$BASH_POST_SCRIPTS" ]]; then
    load_scripts_by_name "${BASH_SCRIPTS_DIR}/post" "${BASH_POST_SCRIPTS[@]}"
fi
# }}}

# {{{ Cleanup
unset EXTENSION
# }}}
