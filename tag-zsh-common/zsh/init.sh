#!/usr/bin/env bash
#
# Load shared custom zsh configurations

EXTENSION="sh"
[[ "${DEBUG}" ]] && echo init.zsh

# {{{ Source scripts
# Load auto scripts that need to be sourced first
load_scripts_in_folder "${ZSH_DIR}/autoload"

# Load on-demand scripts that need to be sourced first
if [[ "${ZSH_SCRIPTS}" ]]; then
    load_scripts_by_name "${ZSH_DIR}/scripts" "${ZSH_SCRIPTS[@]}"
fi
# }}}

# {{{ Cleanup
unset EXTENSION
# }}}
