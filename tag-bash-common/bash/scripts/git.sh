#!/usr/bin/env bash

# {{{ Preparation
# Hub is a fully compatible wrapper for git that adds GitHub support, e.g. creating issues and pull requests.
have hub && alias git="hub"
# }}}

# {{{ Basics
# When no arguments are given, do git status.
#g() { [[ "$#" -gt 0 ]] && git "$@" || git status --short; }
alias g="git"
alias gs="git status -s"
# }}}

