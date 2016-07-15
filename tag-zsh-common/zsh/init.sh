#!/usr/bin/env bash
#
# Load shared custom zsh configurations

# {{{ Preparation
_BASE_DIR="${ZSH_DIR:-${HOME}/.zsh}"
_SCRIPTS="${ZSH_SCRIPTS[@]}"
[[ -n "${DEBUG}" ]] && echo init.zsh
# }}}

# {{{ Source scripts
# Load scripts from autoload folder.
load_scripts "${_BASE_DIR}/autoload"

# Load on-demand scripts as defined via $ZSH_SCRIPTS.
load_scripts "${_BASE_DIR}/scripts" "${_SCRIPTS[@]}"
# }}}

# {{{ Cleanup
unset _BASE_DIR _SCRIPTS
# }}}
