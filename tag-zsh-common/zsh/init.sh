#!/usr/bin/env bash
#
# Load shared custom zsh configurations

# {{{ Preparation
_BASE_DIR="${ZSH_DIR:-${HOME}/.zsh}"
_SCRIPTS="${ZSH_SCRIPTS[@]}"
[[ "${DEBUG}" ]] && echo init.zsh
# }}}

# {{{ Source scripts
# Load auto scripts that need to be sourced first
load_scripts "${_BASE_DIR}/autoload" "*"

# Load on-demand scripts that need to be sourced first
load_scripts "${_BASE_DIR}/scripts" "${_SCRIPTS[@]}"
# }}}

# {{{ Cleanup
unset _BASE_DIR _SCRIPTS
# }}}
