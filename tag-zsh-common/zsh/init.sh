#!/usr/bin/env zsh
#
# Load shared custom zsh configurations

[[ -z "$ZSH_DIR" ]] && ZSH_DIR="$HOME/.bash"
ZSH_PRE_DIR="${ZSH_DIR}/custom/pre"
ZSH_POST_DIR="${ZSH_DIR}/custom/post"

load_scripts() {
    local directory="${1}"
    # Read all arguments after $1 into array
    local scripts=("${@:2}")

    for script in ${scripts[@]}; do
        echo "${directory}/${script}.zsh"
        [[ -f "${directory}/${script}.zsh" ]] && source "${directory}/${script}.zsh"
    done
}

[[ -z "$ZSH_PRE_SCRIPTS" ]] && ZSH_PRE_SCRIPTS=(utilities env)
[[ -z "$ZSH_POST_SCRIPTS" ]] && ZSH_POST_SCRIPTS=(globals)

load_scripts "${ZSH_PRE_DIR}" "${ZSH_PRE_SCRIPTS[@]}"
load_scripts "${ZSH_POST_DIR}" "${ZSH_POST_SCRIPTS[@]}"
# }}}
