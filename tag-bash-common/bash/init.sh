#!/usr/bin/env bash
#
# Load shared custom bash configurations

# {{{ Preparation
_BASE_DIR="${BASH_DIR:-${HOME}/.bash}"
_SCRIPTS="${BASH_SCRIPTS[@]}"
# }}}

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

    if [[ -n "$@" ]]; then
        # Only load the files passed as arguments after $directory.
        while read -rd ' ' script || [[ -n "${script}" ]]; do
            scripts+=("${directory}/${script}.${extension}")
        done <<< "$@"
    else
        # Load all files in the given $directory, as long as they end with .$extension.
        scripts=(${directory}/*.$extension) # &>/dev/null
    fi

    for script in "${scripts[@]}"; do
        if [[ -r "${script}" ]]; then
            [[ -n "${DEBUG}" ]] && echo "${script}"
            source "${script}"
        fi
    done
}
# }}}

# {{{ Source scripts
# Load scripts from autoload folder.
load_scripts "${_BASE_DIR}/autoload"

# Load on-demand scripts as defined via $BASH_SCRIPTS.
load_scripts "${_BASE_DIR}/scripts" "${_SCRIPTS[@]}"
# }}}

# {{{ Post config
# Initialize fasd, the command-line productivity booster (https://github.com/clvv/fasd).
have fasd && eval "$(fasd --init auto)"
# }}}

# {{{ Cleanup
unset _BASE_DIR _SCRIPTS
# }}}
